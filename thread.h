#include "types.h"
#include "stat.h"
#include "user.h"
#include "x86.h"

struct mutex_t{
		uint flag;
};

int thread_create(void*(*start_routine)(void *), void *arg);
void thread_wait();
void mutex_lock(struct mutex_t *m);
void mutex_unlock(struct mutex_t *m);
void mutex_init(struct mutex_t *m);

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

void mutex_lock(struct mutex_t *m){
		while(xchg(&m->flag, 1) == 1);
}

void mutex_unlock(struct mutex_t *m){
		xchg(&m->flag, 0);
}

void mutex_init(struct mutex_t *m){
		xchg(&m->flag, 0);
}
