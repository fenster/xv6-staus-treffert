#include "thread.h"

void* addone(void *arg);
void* addtwo(void *arg);
void* addfive(void *arg);
void printx(int x);

static volatile int x = 0;

int main()
{
	//Create 2 new threads. 
	int pid;
	printf(2, "Parent creating thread A\n");
	pid = thread_create(&addone, (void *)"A");	//Thread 1: Add 1 to x
	thread_wait();			//Wait for thread
	printf(2, "Parent creating thread B\n");
	pid = thread_create(&addone, (void *)"B");	//Thread 1: Add 1 to x
	printf(2, "Parent creating thread C\n");
	pid = thread_create(&addtwo, (void *)"C");	//Thread 2: Add 2 to x
	thread_wait();			//Wait for thread
	thread_wait();
	printx(x);			//Print the value of x
	
	exit();

}

void* addone(void *arg)
{
	x = x + 1;
	printf(2, "Thread %s adds 1.  x = %d\n", (char *)arg, x);
	exit();
}

void* addtwo(void *arg)
{
	x = x + 2;
	printf(2, "Thread %s adds 2.  x = %d\n", (char *)arg, x);
	printf(2, "Thread %s creating thread D\n", (char *)arg);
	thread_create(&addfive, (void *)"D");
	thread_wait();
	exit();
}

void* addfive(void *arg)
{
	int t = tick();
	x = x + t;
	printf(2, "Thread %s adds %d.  x = %d\n", (char *)arg, t, x);
	exit();
}

void printx(int x)
{
	printf(2, "x = %d\n", x);
	return;
}

