#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "math.h"
#include "string.h"
#include <limits.h>

/*
struct {
  int threads;
  unsigned long limit;
} args;*/

pthread_mutex_t lock;

unsigned long* arr;

unsigned long limit = 0;

int amiNums = 0;
int idx = 0;
int idxLimit = 0;

/**
 * Handles summing proper divisor for threads.
 * Returns the sum of the proper divisor of num
 */
int sumPropDiv(int num){
  if(num == 1) // no divsors
    return 0;

  int sum = 0;
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
  printf("\nThread # %d: Roger Roger\n\n", (*(int*)arg)); // lol

  int myNum = 0;

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

    int amiNum = sumPropDiv(myNum);
    // if the potential amiNum is not within range
    // or >= to itself its already been checked!
    // dont do this!
    if((amiNum < limit) && (sumPropDiv(amiNum) == myNum)){
      pthread_mutex_lock(&lock);
      amiNums++; // for duplicates this will be fixed later
      if(idx == idxLimit)
        arr = reallocarray(arr, (idxLimit = idxLimit + 2), sizeof(int)); // Extend array for new placement
      arr[idx] = myNum; // place number
      idx++;
      arr[idx] = amiNum;
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


  unsigned int tCnt = atoi(argv[2]);
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


  if((limit = atoi(argv[4])) < 100 ){
    printf("Error, limit must be > 100.");
    return 0;
  }

  if(limit > INT_MAX){
    printf("Error, limit must be < 2^64 -1");
  }

  return 1;
}

//Removes dupilcates of sorted list, T(n)
int remdup(int size){
  int x = 0;
  for (int i = 1; i < size; i ++) {
    if (arr[x] != arr[i]) {
      arr[++x] = arr[i];
    }
  }
  return x+1; // return new size
}

int cmp(const void * a, const void * b){
  return *((int*) a)  == *((int*)b) ? 0 : *((int*)a) > *((int*)b) ? 1 : -1;
}

int main(int argc, char ** argv){

  if(!validate(argc, argv)) return 1; // invalid CLI

  if(pthread_mutex_init(&lock, NULL) != 0)    // init mutex
   perror("\nMutex allocation and initilization failed!\n Exiting.\n"); //no mutex :(

  int tCnt = atoi(argv[2]); // threadCnt

  idxLimit = limit/2;       // arbitrary initial index limit because using realloc later, trying to cut down on that being called as much!

  arr = (unsigned long *) malloc(sizeof(unsigned long)*(idxLimit)); // make dynamic array

  pthread_t thrds[tCnt];    // make baby thread

  for(int i = 0; i < tCnt; i++){
    if(pthread_create(&thrds[i], NULL, amicable, &i) != 0){
      printf("Thread %d creation failed!\n", i);
      exit(1);
    }
  }

  for(int i = 0; i < tCnt; i++)
    pthread_join(thrds[i], NULL);

  amiNums = remdup(idxLimit) -2; // fix from index


  // Yay formatting
  printf("CS 370 - Project #3\n%s\n\n%s%d\n%s%d\n%s%s\n\n%s\n\n%s\n",
          "Amicable Numbers Program",
          "Hardware Cores: ", 6,
          "Thread Count:   ", tCnt,
          "Numbers Limit:  ", argv[4],
          "Please wait. Running ...",
          "Amicable Numbers");


  for(int i = amiNums;  i >= 0; i--){
    printf("%7lu", arr[i]);
    i--;
    printf("%7lu\n", arr[i]);
  }

  amiNums = (amiNums+1)/2; // fix from index and divide to become pairs

  printf("\nCount of amicable number pairs from 1 to %s is %d", argv[4],  amiNums );
}


