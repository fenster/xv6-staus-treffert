#include "types.h"
#include "stat.h"
#include "user.h"
#include "thread.h"

#define MAX 10

static volatile int x = 0;
static volatile int loops = 0;
struct mutex_t mutex, print;
struct cond_t empty, full;

void* producer(void *arg);
void* consumer(void *arg);
void put(int value);
int get();

int buffer[MAX];
int fill      = 0;
int use       = 0;
int volatile numfilled = 0;
int numconsumers;

int done = 0;


/**
*		Creates a case in which two threads will be racing to write one variable.  Exected
*   x will not be equal to actual x for a large enough loop unless there are locks.
*/
int main(int argc, char *argv[])
{
	//Create 2 new threads.
	if(argc != 3){
		printf(2, "Usage: condtest <loop count> <num consumers>\n");
		exit();
	}
	
	int pid;
	loops = atoi(argv[1]);
	numconsumers = atoi(argv[2]);
	//initialize locks and condition variables
	mutex_init(&mutex);
	cond_init(&empty);
	cond_init(&full);
	//create one producer
	pid = thread_create(&producer, (void *)"A");	//Thread 1: Add 1 to x
	printf(2, "Parent created producer with pid %d.\n", pid);
	int i;
	//create x number of consumers
	for (i = 0; i < numconsumers; i++){
		pid = thread_create(&consumer, 0);
		mutex_lock(&print);
		printf(2, "Created consumer %d with pid %d.\n", i, pid);
		mutex_unlock(&print);
	}
	//wait for children
	for(i = 0; i < numconsumers+1; i++){
		thread_wait();
	}

	
	exit();

}

void* producer(void *arg) {
    int i;
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);            // p1
        while (numfilled == MAX){       // p2
        		mutex_lock(&print);
        		printf(2, "Producer going to sleep.\n");
        		mutex_unlock(&print);
            cond_wait(&empty, &mutex); // p3
        }
        put(i);                        // p4
        mutex_lock(&print);
        printf(2, "put %d\n", i);
        mutex_unlock(&print);
        cond_signal(&full);            // p5
        mutex_unlock(&mutex);          // p6
    }
    done = 1;
    exit();
}
void* consumer(void *arg) {
    int pid = getpid();
    int i;
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);
        while (numfilled == 0){
        		if(done == 1){
        			int j;
        			for(j = 0; j < numconsumers; j++){
        				cond_signal(&full);
        				mutex_unlock(&mutex);
        			}
        			mutex_lock(&print);
        			printf(2, "Child %d exits.\n", pid);
        			mutex_unlock(&print);
        			exit();
        		}else{
        		  mutex_lock(&print);
        			printf(2, "Child %d going to sleep.\n", pid);
        			mutex_unlock(&print);
            	cond_wait(&full, &mutex);
            }
        }
        int tmp = get();
        mutex_lock(&print);
        printf(2, "child %d got %d\n", pid, tmp);
        mutex_unlock(&print);
        cond_signal(&empty);
        mutex_unlock(&mutex);
    }
    mutex_lock(&print);
    printf(2, "Child %d exits.\n", pid);
    mutex_unlock(&print);
    exit();
}

void put(int value) {
    buffer[fill] = value;    // line F1
    fill = (fill + 1) % MAX; // line F2
    numfilled++;
    return;
}

int get() {
    int tmp = buffer[use];
    use = (use + 1) % MAX;
    numfilled--;
    return tmp;
}

