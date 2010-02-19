#include "thread.h"
#include "user.h"

int main()
{
	int x = 0;

	//Create 2 new threads. 
	x = thread_create(addone, x);	//Thread 1: Add 1 to x
	x = thread_create(addtwo, x);	//Thread 2: Add 2 to x
	thread_wait();			//Wait for thread
	thread_wait();			//Wait for thread
	printx();			//Print the value of x

}

int addone(int x)
{
	x = x + 1;
	return x;
}

int addtwo(int x)
{
	x = x + 2;
}

void printx(int x)
{
	printf(2, "x = %d\n", x);
}
