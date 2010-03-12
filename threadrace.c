#include "types.h"
#include "stat.h"
#include "user.h"
#include "thread.h"

void* addone(void *arg);

static volatile int x = 0;
static volatile int numloops = 0;
struct mutex_t lock;

/**
*		Creates a case in which two threads will be racing to write one variable.  Exected
*   x will not be equal to actual x for a large enough loop unless there are locks.
*/
int main(int argc, char *argv[])
{
	//Create 2 new threads.
	if(argc != 2){
		printf(2, "Usage: threadrace <loop count>\n");
		exit();
	}
	
	int pid;
	char *arg = argv[1];
	numloops = atoi(arg);
	//create a lock
	mutex_init(&lock);
	printf(2, "Parent creating thread A\n");
	pid = thread_create(&addone, (void *)"A");	//Thread 1: Add 1 to x
	printf(2, "Parent creating thread B\n");
	pid = thread_create(&addone, (void *)"B");	//Thread 1: Add 1 to x
	thread_wait();			//Wait for thread
	thread_wait();
	printf(2, "Expected x = %d.  Actual x = %d\n", numloops*2, x);

	
	exit();

}

void* addone(void *arg)
{
	printf(2, "Thread %s will loop %d times.\n", (char *)arg, numloops);
	int i;
  
	for(i = 0; i < numloops; i++){
	  mutex_lock(&lock);
		x = x + 1;
		mutex_unlock(&lock);
		//printf(2, "Thread %s adds 1.  x = %d\n", (char *)arg, x);
	}
	
		exit();
}

