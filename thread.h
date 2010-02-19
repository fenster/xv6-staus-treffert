#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "umalloc.c"

int thread_create(void*(*start_routine)(void *), void *arg){
	
	//Allocate stack using process heap
	void * stack = malloc(KSTACKSIZE);

	//create new thread
	if(fork_thread(stack) == 0){
		//if we are in the child, call to routine
		start_routine(arg);				
	}
	
	return 0;
}

void thread_wait(){

	wait();

	return;
}
