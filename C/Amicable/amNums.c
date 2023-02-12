#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include <math.h>

pthread_mutex_t lock;

unsigned long (*arr)[2];

unsigned long limit = 0;

unsigned int amiNums = 0;
unsigned int idx = 0;
unsigned long idxLimit = 0;


/**
 * Handles summing proper divisor for threads.
 * Returns the sum of the proper divisor of num
 */
unsigned long sumPropDiv(unsigned long num){
  if(num == 1) // no divsors
    return 0;

  unsigned long sum = 0;
  // largest proper divsor can only be as big as the sqrt of num
  for (int i = 2; i <= sqrt(num); i++)
    if ((num % i) == 0){
      if (i == (num/i)) sum += i; // if num = i^2 add only one
      else  sum += (i + num/i);   // otherwise add both
    }

  return (sum + 1); // 1 is a divisor
}

//Thread function
void* amicable(void* arg){
  //printf("\nThread # %d: Roger Roger\n\n", (*(int*)arg)); // lol

  unsigned long myNum = 0;

  while(1){ // just go till were out of numbers
    pthread_mutex_lock(&lock); // lock it down
    if(limit < 10){
      pthread_mutex_unlock(&lock); // release for use
      pthread_exit(0);
    }
    myNum = limit;
    limit--;
    pthread_mutex_unlock(&lock); // release for use


    // If number is amicable, then it should end up back where it started after 2 calls. Duplicates will be removed in main, i Like 1 O(N log N) instead of many O(n) checks for duplicates.

    unsigned long amiNum = sumPropDiv(myNum);
    // if the potential amiNum is not within range
    // or >= to itself its already been checked!
    // dont do this!
    if((amiNum < limit) && (sumPropDiv(amiNum) == myNum)){
      pthread_mutex_lock(&lock);
      amiNums++; // for duplicates this will be fixed later

      if(idx == idxLimit)
        arr = reallocarray(arr, (idxLimit = idxLimit + 1)*2, sizeof(unsigned long)); // Extend array for new placement

      arr[idx][0] = myNum; // place number
      arr[idx][1] = amiNum;
      idx++;
      pthread_mutex_unlock(&lock);
    }
  }
}

//Treated as a bool
int validate(int argc, char** argv){
  if(argc < 5){
    printf("Usage: ./amNums -t <threadCount> -l <limitValue> ");
    return 0;
  }

  if(strncmp(argv[1], "-t", 3) != 0){
    printf("Error, invalid thread count specifier.");
    return 0;
  }

  char *t = argv[2];
  while(*t)
    if((*t < '0') || (*t > '9')){
      printf("Error, invalid thread count value.");
      return 0;
    }
    else t++;


  int tCnt = atoi(argv[2]);
  if((tCnt < 1) | (tCnt > 100)){
    printf("Error, thread count must be >= 1 and <= 100.");
    return 0;
  }


  if(strncmp(argv[3], "-l", 3) != 0){
    printf("Error, invalid limit value specifier.");
    return 0;
  }

  t = argv[4];
  while(*t)
    if((*t < '0') || (*t > '9')){
      printf("Error, invalid limit value.");
      return 0;
    }
    else t++;

  char *end;
  // gimme size!
  long long lim = strtol(argv[4], &end, 10); // works?

  // parse "string" as long in base 10, leave end where we left off, shouldnt be the first thing, or not null
  if(*end == argv[4][0] || *end != '\0' || lim > 4294967295L){ // strtol returns 0 if failure.
    printf("Error, limit outside of range, must be < 2^32 -1");
    return 0;
  }

  limit = lim;

  if(limit  < 100 ){
    printf("Error, limit must be > 100.");
    return 0;
  }

  return 1;
}

//Some how unecessary?
//Removes dupilcates of sorted list, T(n)
//int remdup(int size){
//  int x = 0;
//  for (int i = 1; i < size; i++) {
//    if (arr[x][0] != arr[i][0]) {
//      arr[++x][0] = arr[i][0];
//      arr[x][1] = arr[i][1];
//    }
//  }
//  return x+1; // return new size
//}

void merge(int l, int m, int r)
{
    int i, j, k,
    nd1 = m - l + 1,
    nd2 = r - m;

    unsigned long L[nd1][2], R[nd2][2];

    for (i = 0; i < nd1; i++){
        L[i][0] = arr[l + i][0];
        L[i][1] = arr[l + i][1];
    }
    for (j = 0; j < nd2; j++){
        R[j][0] = arr[m + 1 + j][0];
        R[j][1] = arr[m + 1 + j][1];
    }

    i = j = 0;
    k = l;
    while (i < nd1 && j < nd2) {
        if (L[i][1] <= R[j][1]) { // take left while l <= r
            arr[k][0] = L[i][0];
            arr[k][1] = L[i][1];
            i++;
        }
        else {
            arr[k][0] = R[j][0];
            arr[k][1] = R[j][1];
            j++;
        }
        k++;
    }

    while (i < nd1) { // take rest of L
        arr[k][0] = L[i][0];
        arr[k][1] = L[i][1];
        i++;
        k++;
    }

    while (j < nd2) { // take rest of R
        arr[k][0] = R[j][0];
        arr[k][1] = R[j][1];
        j++;
        k++;
    }
}

void ms(int l, int r)
{
    if (l < r) {
        int m = (l+r) / 2;
        ms(l, m);  // break left
        ms(m + 1, r); // break right
        merge(l, m, r); // merge lists
    }
}


int main(int argc, char ** argv){

  if(!validate(argc, argv)) return 1; // invalid CLI

  if(pthread_mutex_init(&lock, NULL) != 0)    // init mutex
   perror("\nMutex allocation and initilization failed!\n Exiting.\n"); //no mutex :(

  int tCnt = atoi(argv[2]); // threadCnt


  // Have to check this otherwise malloc will fail because it will be a weird array and just bad...
  if(limit %256 == 0)
    idxLimit = limit/256;       // arbitrary initial index limit because using realloc later, trying to cut down on that being called as muc
  else
    idxLimit = (limit+(256-limit%256))/256;     // should be fine


  arr = malloc(idxLimit * sizeof(*arr)); // initialize 2 rows each with idxLimit*sizeof(unsigned long) for a full 2d array of idxLimit*2

  //  arr = (unsigned long ) malloc(sizeof(unsigned long)*(idxLimit)); // make dynamic array

  pthread_t thrds[tCnt];    // make baby thread

  for(int i = 0; i < tCnt; i++){
    if(pthread_create(&thrds[i], NULL, amicable, &i) != 0){
      printf("Thread %d creation failed!\n", i);
      return 1;
    }
  }

  for(int i = 0; i < tCnt; i++)
    pthread_join(thrds[i], NULL);


  // Yay formatting
  printf("CS 370 - Project #3\n%s\n\n%s%d\n%s%d\n%s%s\n\n%s\n\n%s\n",
          "Amicable Numbers Program",
          "Hardware Cores: ", 6,
          "Thread Count:   ", tCnt,
          "Numbers Limit:  ", argv[4],
          "Please wait. Running ...",
          "Amicable Numbers");

  //sort
  ms(0, amiNums-1); // exclude the last index because that is 0, always, safety <3

  for(int i = 0;  i < amiNums; i++){
    printf("%7lu%7lu\n", arr[i][1], arr[i][0]);
  }

  free(arr);
  printf("\nCount of amicable number pairs from 1 to %s is %d\n", argv[4],  amiNums );
  return 0;
}

// need to write a sorting function that sorts upper "parallel array" and then applies result simultaneously to the mirror
