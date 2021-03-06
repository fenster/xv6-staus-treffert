#include "x86.h"


struct mutex_t{
		uint flag;
};

struct node{
		int pid;
		struct mutex_t *lock;
		struct node *next;
};

struct cond_t{
		int size;
		struct node *head;	
};

int thread_create(void*(*start_routine)(void *), void *arg);
void thread_wait();
void mutex_lock(struct mutex_t *m);
void mutex_unlock(struct mutex_t *m);
void mutex_init(struct mutex_t *m);
void cond_wait(struct cond_t *c, struct mutex_t *m);
void cond_signal(struct cond_t *c);
void cond_init(struct cond_t *c);

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

void cond_wait(struct cond_t *c, struct mutex_t *m){
	//create a new node for this waiting thread
	struct node *n = malloc(sizeof(struct node));
	n->pid = getpid();
	n->lock = m;
	//if no threads are waiting yet, make this the head	
	if(c->head == 0){
		c->head = n;		
		c->size = c->size + 1;
	}else{				//else traverse list and find the next available spot
		struct node *temp = c->head;
		if(temp->next == 0){
			temp->next = n;
			c->size = c->size + 1;
		}else{
			temp = temp->next;
		}
	}
	
	mutex_unlock(m);
	sleep_lock();
}

void cond_signal(struct cond_t *c){
	//grab the first node from the head
	struct node *n;
	if(c->head == 0){
		return;
	}else{
		n = c->head; //grab the current head
		c->head = n->next;        //set the new head
	}

	//wake a thread
	c->size = c->size - 1;
	//mutex_lock(n->lock);
	wake_lock(n->pid);
}

void cond_init(struct cond_t *c){
		c->size = 0;
		c->head = 0;
}
