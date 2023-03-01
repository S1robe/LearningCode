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
int p;

sem_t sem;
pthread_t * threads;
sigset_t sigset;
struct sigaction new, old;
int notBoarding;

void sighandle(int sig){}

void wake() {
    for (int g = 0; g < n; g++)
        pthread_kill(threads[g], SIGUSR1);
}

void* coaster(void* arg){
    int rides = 1;
    time_t before;
    time_t current;
    int sval;
    time(&before);
    // while passenegers are present
    while(p){
        notBoarding = 0;
        // while the time elapsed < 2s, and all seats are not filled
        time(&current);
        sem_getvalue(&sem, &sval);
        if((difftime(current, before) >= 2) | (sval == 0)){
            notBoarding = 1;
            int filledseats = c - sval;
            // if only 1 person on the coaster
            printf("\033[0;31m Car: %d %s riding the roller coaster. Off we go on the %d ride!\033[0m\n"
                   , filledseats, (filledseats == 1) ? "passenger is" : "passengers are", rides);
                //Do coaster things
            sleep(5);
            printf("\033[0;31m Car:  ride %d  completed. \033[0m\n", rides++);
            // wake up the kiddos
            wake();
            time(&before); // restart timer
        }
    }
    printf("\033[0;31m Car: Roller coaster shutting down.\033[0m\n");
    pthread_exit(0);
}

void* passenger(void* arg){
    int max_iter = (rand()%(i+1));
    unsigned long whoami = (unsigned long)arg;
    int j = 0;
    while(max_iter){
        // this must be here to prevent the block  from being interrupted by the signal.
        pthread_sigmask(SIG_BLOCK, &sigset, NULL);
        //Brace for excitement
        sleep((rand()%11));
        while(notBoarding);
        if(sem_wait(&sem) == -1) printf("Block was interrupted!"); // should never happen
        {
            int tmp;
            j++;
            printf("\033[0;32m Thread %ld: Wooh! I’m about to ride the roller coaster for the %d %s time! I have %d iterations left. \033[0m\n",
                   whoami, // %ld
                   j,       // %d
                   ((tmp = (j % 10)) == 1) ? "st" : ((tmp == 2) ? "nd" : ((tmp == 3) ? "rd" : "th")), // %s
                   max_iter--); // %d
            // unmask while we are in the coaster so that it  can wake us up after its ready
            pthread_sigmask(SIG_UNBLOCK, &sigset, NULL);
            sleep(10);
        }
        sem_post(&sem); // this both frees a slot, and signals to the waiting threads in sem_wait() to get up.
    }
    printf("\033[0;31m thread %ld: Completed %d iterations on the roller coaster. Exiting. \033[0m\n", whoami, j);
    p--;
    pthread_exit(0);
}

//Treated as a bool
int validate(int argc, char** argv){
    char options;
    //Usage
    if( argc < 7 ) {
      printf("Usage: -n <count> -c <count> -i <count>\n");
      return 0;
    }
    // check for the required arguemnts, p cool builtin actually.
    while ((options = getopt(argc, argv, ":n:c:i:")) != -1) {
        switch (options) {
            case 'n': // finds n
                n = atoi(optarg);
                if (n <= 0) {
                    printf("./roller: invalid n value - %s\n", optarg);
                    return 0;
                }
                p = n;
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
    new.sa_handler = sighandle; // assign new signal handler function.
    result = sigaction(SIGUSR1, &new, NULL);
    if(result) return 0;
    return 1;
}

int main(int argc, char** argv) {
    if(!validate(argc, argv)) return 0;
    if(!initSigs()) return 0;

    // init semaphor
    sem_init(&sem, 0, c);

        //Create car thread
    pthread_t car;
        //Start ride
    pthread_create(&car, NULL, coaster, NULL);

        //Enter the passengers
    threads = (pthread_t *) malloc(sizeof(pthread_t) * n);
        //oh hey a rollercoaster!
    for(unsigned long x = 0; x < n; x++)
        pthread_create(&(threads[x]), NULL, passenger, (void *)x);

        //Wait for the kids to leave the amusement park.
    for(int x = 0; x < n; x++)
        pthread_join(threads[x], NULL);

        //waitForRide for ride to shutdown.
    pthread_join(car, NULL);

    sigaction(SIGUSR1, &old, NULL); // revert the signal action

    sem_destroy(&sem); //blow up the semaphor

    return 0;
}
