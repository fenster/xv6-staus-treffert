#include "types.h"
#include "user.h"


int thread_create(void*(*start_routine)(void *), void *arg){
	
	//Allocate stack using process heap
	int stack = malloc(1024);

	//create new thread
	int pid = fork_thread((int)stack, (int)start_routine, (int)arg);
			
	
			
	return pid;
}

void thread_wait(){
	
	int pid;
	while(pid = wait_thread() != -1);
	return;
}
