#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <string.h>

struct {
    unsigned long n;
    int c;
    int i;
} args;

sem_t sem;
sigset_t sigint;
int wait = 0;

void* coaster(void* arg){
    int rides = 1;
    time_t before;
    time_t current;
    int sval;
    time(&before);
    // while passenegers are present
    while(args.n){
        time(&current);
                        // while the time elapsed < 2s, and all seats are not filled
        if((difftime(current, before) >= 2) | !sem_getvalue(&sem, &sval)){
            wait = 1;
            int filledseats = args.c - sval; //
            // if only 1 person on the coaster
            if(filledseats == 1)
                printf("Car: %d passenger is", filledseats);
            else
                printf("Car: %d passengers are", filledseats);

            printf(" riding the roller coaster. Off we go on the %d ride!\n", rides);
            //Do coaster things
            sleep(5);
            printf("\033[0;31m Car: Ride %d completed! \033[0m\n", rides++);
            kill(-1, SIGCONT); // ironic, but wake everybody up
            time(&before); // restart timer
        }
    }
    printf("Car: Roller coaster shutting down.\n");
    pthread_exit(0);
}

void* passenger(void* arg){
    int max_iter = (rand()%(args.i+1));
    int whoami = *(int*)arg;
    int j = 0;
    while(max_iter){
        //Brace for excitement
        sleep((rand()%11));
        //boardCar()
            // attempt to lock the semaphore, if success, get in the car, else wait in line.
            if(sem_wait(&sem) != 0){
                printf("Semaphore Error!");
                int err = -1;
                pthread_exit(&err);
            }
                printf("\033[0;32m Thread %d: Wooh! I’m about to ride the roller coaster for the ");
                // one more iteration one
                j++;
                //Yay formatting
                switch(j % 10){
                    case 1: printf("%d st", j); break;
                    case 2: printf("%d nd", j); break;
                    case 3: printf("%d rd", j); break;
                    default: printf("%d th", j);
                }
                printf("time! I have %d iterations left. \033[0m\n", max_iter--);
            raise(SIGSTOP); // block till signal
            sem_post(&sem); // unlock the semaphore

    }
    printf("thread %d: Completed %d iterations on the roller coaster. Exiting.\n", whoami, j);
    args.n--;
    pthread_exit(0);
}

//Treated as a bool
int validate(int argc, char** argv){
    char options;
    char * end;
    while ((options = getopt(argc, argv, ":n:c:i:")) != -1) {
        switch (options) {
            case 'n':
                args.n = strtol(optarg, &end, 10);
                if (args.n <= 0) {
                    printf("invalid n value - %s\n", optarg);
                    return  EXIT_SUCCESS;
                }
                break;
            case 'c':
                args.c = atoi(optarg);
                if (args.c <= 0) {
                    printf("invalid c value - %s\n", optarg);
                    return  EXIT_SUCCESS;
                }
                break;
            case 'i':
                args.i = atoi(optarg);
                if (i <= 0) {
                    printf("invalid I value - %s\n", optarg);
                    return  EXIT_SUCCESS;
                }
                break;
            default:
                printf(stderr, "Unknown argument %c\n", c);
                return EXIT_SUCCESS;
        }
    }
    if ((args.c > args.n) || (args.n > 100) || args.c == 0 || args.n == 0 || args.i == 0) {
        printf("n (>c ) and n (<= 100) arguments required\n");
        return  EXIT_SUCCESS;
    }
}

int main(int argc, char** argv) {
    memset(&args, 0, sizeof(args)); // blowup the stuct
    if(!validate(argc, argv)) return 0;
    sem_init(&sem, 0, args.c); // start the semaphore with the max # of passenegers per car.

    //Create car thread
    pthread_t car;
    //Start car thread
    pthread_create(&car, NULL, coaster, NULL);

    //Enter the passengers
    pthread_t threads[args.n];
    //oh hey a rollercoaster!
    for(int x = 0; x < args.n; x++)
        pthread_create(&(threads[x]), NULL, passenger, &x);

    //Wait for the kids to leave the amusement park.
    for(int x = 0; x < args.n; x++)
        pthread_join(threads[x], NULL);
    sem_destroy(&sem);

    return 0;
}
