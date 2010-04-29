/*
 * logfs.c
 *
 *	Main journaling file -- creates log, writes to log, reads from log on boot.
 *  Created on: Apr 28, 2010
 */
#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "buf.h"
#include "fs.h"
#include "fsvar.h"
#include "file.h"
#include "fcntl.h"
#include "dev.h"

#define LOGGED_BLOCKS 10

/**Checks if log exists, if it does not, create one*/
void log_initialize(){

	struct inode *ip;
	//get inode for the log file
	char *path = "/log";
	/*
	if(ip = namei(path) == 0){
		panic("cannot get inode for log file");
	}
	*/
	ip = namei(path);

	cprintf("ip->inum is %d\n", ip->inum);

	//create buffer as large as the block size
	char buf[BSIZE];
	int i;
	for(i = 0; i < BSIZE; i++){
		buf[i] = 0;
	}

	//check if log exists, otherwise create it
	int lsize = BSIZE*LOGGED_BLOCKS;
	ilock(ip);
	if(ip->size != lsize){
		writei(ip, buf, 0, lsize);
	}
	iunlock(ip);

	return;

}

