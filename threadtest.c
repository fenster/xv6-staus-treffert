#include "thread.h"

void* addone();
void* addtwo();
void printx(int x);

int x = 0;

int main()
{

	//Create 2 new threads. 
	printf(2, "here\n");
	x = thread_create(addone, 0);	//Thread 1: Add 1 to x
	printf(2, "here1\n");
	x = thread_create(addtwo, 0);	//Thread 2: Add 2 to x
	printf(2, "here2\n");
	thread_wait();			//Wait for thread
	printf(2, "here3\n");
	thread_wait();			//Wait for thread
	printx(x);			//Print the value of x
	
	exit();

}

void* addone()
{
	x = x + 1;
	printf(2, "ADD ONE EXIT\n");
	exit();
}

void* addtwo()
{
	x = x + 2;
	printf(2, "ADD TWO EXIT\n");
	exit();
}

void printx(int x)
{
	printf(2, "x = %d\n", x);
	return;
}

