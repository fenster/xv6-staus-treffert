#include "thread.h"

void* addone(void *arg);
void* addtwo(void *arg);
void* addfive(void *arg);
void printx(int x);

static volatile int x = 0;

int main()
{

	//Create 2 new threads. 
	thread_create(&addone, (void *)x);	//Thread 1: Add 1 to x
	thread_create(&addtwo, (void *)x);	//Thread 2: Add 2 to x
	thread_wait();			//Wait for thread
	thread_wait();			//Wait for thread
	printx(x);			//Print the value of x
	
	exit();

}

void* addone(void *arg)
{
	
	x = x + 1;
	exit();
}

void* addtwo(void *arg)
{
	x = x + 2;
	thread_create(&addfive, arg);
	thread_wait();
	exit();
}

void* addfive(void *arg)
{
	x = x + 5;
	exit();
}

void printx(int x)
{
	printf(2, "x = %d\n", x);
	return;
}

