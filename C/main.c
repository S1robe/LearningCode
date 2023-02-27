#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <stdbool.h>
#include <string.h>

struct {
    int n;
    int c;
    int i;
} args;

sem_t sem;

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
        if(difftime(current, before) >= 2 | !sem_getvalue(&sem, &sval)){
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
            sem_post(&sem); // unlock the semaphore
            time(&before); // restart timer
        }
    }
    printf("Car: Roller coaster shutting down.\n");
    pthread_exit(0);
}

void* passenger(void* arg){
    int max_iter = (rand()%(args.i+1));
    int whoami = *(int*)arg;
    int j = 1;
    while(max_iter){
        //Brace for excitement
        sleep((rand()%11));
        //boardCar()
            // attempt to lock the semaphore, if success, get in the car
            while(sem_trywait(&sem)){
                printf("\033[0;32m Thread %d: Wooh! I’m about to ride the roller coaster for the ");
                //Yay formatting
                switch(j % 10){
                    case 1: printf("%d st", j); break;
                    case 2: printf("%d nd", j); break;
                    case 3: printf("%d rd", j); break;
                    default: printf("%d th", j);
                }
                printf("time! I have %d iterations left. \033[0m\n", max_iter--);

            }
            //Block untill the car says ride is done.
            sem_wait(&sem); // wait at this point for the car to signal being back!;
            j++;

    }
    printf("thread %d: Completed %d iterations on the roller coaster. Exiting.\n", whoami, j);
    args.n--;
    pthread_exit(0);
}


//Treated as a bool
int validate(int argc, char** argv){
    if(argc < 7){
        printf("Usage: -n <count> -c <count> -i <count>\n");
        return 0;
    }
    // Check option -n
    if(strlen(argv[1]) < 3 | strncmp(argv[1], "-n", 3) != 0){
        if(strlen(argv[1]) >= 2)
            printf("./roller: invalid option - %c\n", argv[1][1]);
        else
            printf("./roller: invalid option - %s\n", argv[1]);
        return 0;
    }

    // Check value of 'n'
    char *t = argv[2];
    while(*t)
        if((*t < '0') || (*t > '9')){
            printf("./roller: invalid value - %s\n", argv[2]);
            return 0;
        }
        else t++;
    args.n = atoi(argv[2]);
    if(args.n > 100 | args.n < 0) {
        printf("n (>c ) and n (<= 100) arguments required\n");
        return 0;
    }

    //Check option -c
    if(sizeof(argv[3]) < 3 | strncmp(argv[3], "-c", 3) != 0){
        if(strlen(argv[3]) >= 2)
            printf("./roller: invalid option - %c\n", argv[3][1]);
        else
            printf("./roller: invalid option - %s\n", argv[3]);
        return 0;
    }

    //Get C value
    t = argv[4];
    while(*t)
        if((*t < '0') || (*t > '9')){
            printf("./roller: invalid value - %s", argv[4]);
            return 0;
        }
        else t++;

    args.c = atoi(argv[4]);
    if(args.n <= args.c){
        printf("n (>c ) and n (<= 100) arguments required\n");
        return 0;
    }

    //Check option -i
    if(sizeof(argv[5]) < 3 | strncmp(argv[5], "-i", 3) != 0){
        if(strlen(argv[5]) >= 2)
            printf("./roller: invalid option - %c\n", argv[5][1]);
        else
            printf("./roller: invalid option - %s\n", argv[5]);
        return 0;
    }

    //Get i value
    t = argv[6];
    while(*t)
        if((*t < '0') || (*t > '9')){
            printf("./roller: invalid value - %s", argv[6]);
            return 0;
        }
        else t++;

    args.i = atoi(argv[6]);
    if(args.i > 20 | args.i < 0){
        printf("i <= 20 required.");
        return 0;
    }

    return 1;
}

int main(int argc, char** argv) {
    memset(&args, 0, sizeof(args)); // blowup the stuct
    if(!validate(argc, argv)) return 0;
    sem_init(&sem, 0, args.c); // start the semaphore with the max # of passenegers per car.

    //Create car thread
    pthread_t car;
    //Start car thread
    pthread_create(&car, NULL, *coaster, NULL);

    //Enter the passengers
    pthread_t threads[args.n];
    //oh hey a rollercoaster!
    for(int x = 0; x < args.n; x++)
        pthread_create(&(threads[0]), NULL, *passenger, &x);

    //Wait for the kids to leave the amusement park.
    for(int x = 0; x < args.n; x++)
        pthread_join(threads[x], NULL);

    return 0;
}
