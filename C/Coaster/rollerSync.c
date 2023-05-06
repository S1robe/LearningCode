/*
 * Name: Garrett Prentice
 * Section: 1002
 * Description: Simulate a semaphore expressions with a theme park example between passengers and a roller car.
 *
 */


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <string.h>

int n;
int c;
int i;
int p = 0;
int rides = 1;
int filledseats = 0;
int situated = 0;
int leaving;

sem_t riding;
sem_t togo;
pthread_mutex_t boarding;
pthread_mutex_t board;
pthread_mutex_t situating;
pthread_mutex_t leave;
pthread_mutex_t exiting;

pthread_t car;
pthread_t * threads;
int * livingThreads;

sigset_t sigset;
struct sigaction new, old;

void handleSIGUSR1() {}

void wake() {
    for (int i = 0; i < n; i++)
        if(livingThreads[i] != -1)
            pthread_kill(threads[i], SIGUSR1);
}

void* coaster(){
    time_t before, current;
    // while passengers are present
    time(&before);
    time(&current);

    while(p != n){
        while(difftime(current, before) < 2 && filledseats != c){
            time(&current);
        }
        pthread_mutex_lock(&boarding); // NO MORE BOARDING!

        while(situated != filledseats); // wait for passengers to print & situate

        // Coaster go vroom!
        printf("Car: %d %s riding the roller coaster. Off we go on the %d ride!\n",
               filledseats, (filledseats == 1) ? "passenger is" : "passengers are", rides);
        sleep(5);
        printf("Car:  ride %d  completed. \n", rides++);

        leaving = filledseats; // # in should = # out
        filledseats = situated = 0; // clear the seats
        wake();
        while(leaving != 0);
        time(&before);
        pthread_mutex_unlock(&boarding);
    }
    printf("Car: Roller coaster shutting down.\n");
    pthread_exit(0);
}

void* passenger(void* arg){
    unsigned long whoami = (unsigned long)arg;
    livingThreads[whoami] = whoami;
    int tmp, chosen,
    max_iter = (rand()%(i+1)),
    j = 0;
    chosen = max_iter;
    while(max_iter){
        // this must be here to prevent the block  from being interrupted by the signal.
        pthread_sigmask(SIG_BLOCK, &sigset, NULL);
            sleep((rand()%11));    //Brace for excitement

        pthread_mutex_lock(&boarding);
        pthread_mutex_unlock(&boarding);        // Locked out of boarding

        // Get on the coaster
        sem_wait(&riding);
            // Register with the car that were on

            pthread_mutex_lock(&board);
                filledseats++;
            pthread_mutex_unlock(&board);
            j++;
            printf("Thread %ld: Wooh! I’m about to ride the roller coaster for the %d %s time! I have %d iterations left. \n",
                   whoami, // %ld
                   j,       // %d
                   ((tmp = (j % 10)) == 1) ? "st" : ((tmp == 2) ? "nd" : ((tmp == 3) ? "rd" : "th")), // %s
                   max_iter--); // %d

            // unmask while we are in the coaster so that it  can wake us up after its ready
            pthread_sigmask(SIG_UNBLOCK, &sigset, NULL);

            // Synchronize with the car that were ready to go!

        pthread_mutex_lock(&board);  // acquire board
            pthread_mutex_lock(&situating); // acquire situating prevents situated from ever equalling filledseats too early
                situated++;
        pthread_mutex_unlock(&board);
            pthread_mutex_unlock(&situating);

            sleep(200000); // wait for the car to wake us up

        if(max_iter == 0) {
            printf("thread %ld: Completed %d iterations on the roller coaster. Exiting. \n", whoami, j);
        }
        pthread_mutex_lock(&leave);
            leaving--;
        pthread_mutex_unlock(&leave);
        sem_post(&riding); // this both frees a slot, and signals to the waiting threads in sem_wait() to get up.
    }
    livingThreads[whoami] = -1;
    pthread_mutex_lock(&exiting);
        p++;
    pthread_mutex_unlock(&exiting);
    if(chosen == 0)
        printf("thread %ld: Completed %d iterations on the roller coaster. Exiting. \n", whoami, j);
    pthread_exit(0);
}

//Treated as a bool
int validate(int argc, char* argv[]){
    char options;

    //Usage
    if( argc < 7 ) {
      printf("Usage: -n <count> -c <count> -i <count>\n");
      return 0;
    }
    // check for the required arguments, p cool builtin, actually.
    while ((options = getopt(argc, argv, ":n:c:i:")) != -1) {
        switch (options) {
            case 'n': // finds n
                n = atoi(optarg);
                if (n <= 0) {
                    printf("./roller: invalid n value - %s\n", optarg);
                    return 0;
                }
                break;
            case 'c': // finds c
                c = atoi(optarg);
                if (c <= 0) {
                    printf("./roller: invalid c value - %s\n", optarg);
                    return 0;
                }
                break;
            case 'i': // finds i
                i = atoi(optarg);
                if (i <= 0) {
                    printf("./roller: invalid i value - %s\n", optarg);
                    return 0;
                }
                break;
            default:
                printf("./roller: invalid option - %c\n", optopt); // args not found are in optopt.
                return 0;
        }
    }
    //Peak error handling performance!
    if ((c > n) || (n > 100) || c == 0 || n == 0 || i == 0) {
        printf("n (>c ) and n (<= 100) arguments required\n");
        return 0;
    }
    return 1;
}

//Treated as a bool
int initSigs(){
    sigaddset(&sigset, SIGUSR1); // fill in the signal im using to wake the waiting threads
    int result = sigaction(SIGUSR1, NULL, &old);//Preserve old sig
    if(result) return 0;
    new.sa_handler = handleSIGUSR1; // assign new signal handler function.
    result = sigaction(SIGUSR1, &new, NULL);
    if(result) return 0;
    return 1;
}

int main(int argc, char* argv[]) {
    if (!validate(argc, argv)) return 0;
    if (!initSigs()) return 0;

    // init semaphore
    sem_init(&riding, 0, c);
    sem_init(&togo, 0, 0);
    pthread_mutex_init(&boarding, NULL);
    pthread_mutex_init(&board, NULL);
    pthread_mutex_init(&situating, NULL);
    pthread_mutex_init(&leave, NULL);
    pthread_mutex_init(&exiting, NULL);

    threads = (pthread_t *) malloc(sizeof(pthread_t) * n);
    livingThreads = (int *) malloc(sizeof(int) * n);

    //Create car thread
    pthread_create(&car, NULL, coaster, NULL);

        //Enter the passengers: oh hey a roller coaster!
        for (unsigned long x = 0; x < n; x++){
            if(pthread_create(&threads[x], NULL, passenger, (void *) x)){
                printf("Pthread Create Error");
                exit(0);
            }
        }

        //Wait for the kids to leave the amusement park.
        for(int x = 0; x < n; x++) {
            pthread_join(threads[x], NULL);
        }

    //waitForRide for ride to shutdown.
    pthread_join(car, NULL);

    sigaction(SIGUSR1, &old, NULL); // revert the signal action

    sem_destroy(&riding); //blow up the semaphore
    sem_destroy(&togo); //blow up the semaphore
    pthread_mutex_destroy(&exiting);
    pthread_mutex_destroy(&leave);
    pthread_mutex_destroy(&situating);
    pthread_mutex_destroy(&leave);
    pthread_mutex_destroy(&exiting);
    return 0;
}
