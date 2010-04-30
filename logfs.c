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

#define min(a, b) ((a) < (b) ? (a) : (b))

#define LOGGED_BLOCKS 10		//number of defined blocks in the log

#define CLEAR 0					//log is ready to be written to
#define LOGGING 1					//log is busy writing data
#define LOGGED 2				//log is complete, actual write to disk being performed


struct inode* log_ip;				//inode pointer to the logfile

struct transhead{
uint status;
uint currBlockIndex;
struct inode *ip;
uint offset;
uint size;
};


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
		buf[i] = "0";
	}

	//check if log exists, otherwise create it
	int lsize = BSIZE*(LOGGED_BLOCKS+1);
	ilock(ip);
	if(ip->size != lsize){
		writei(ip, buf, 0, lsize);
		cprintf("re-created log file");
	}
	iunlock(ip);

	struct transhead t;
	t.status = CLEAR;
	t.currBlockIndex = 0;
	t.offset = 0;
	t.size = 0;
	writei(ip, &t, 0, sizeof(struct transhead *));

	log_ip = ip;

	return;
}

/**Write data to the log, than call the real writei
 * ip = inode pointer of file to be written
 * src = buffer to be written
 * off = offset from beginning of file where we should start writing
 * n = size of buffer to be written
 */
int
log_writei(struct inode *ip, char *src, uint off, uint n)
{
  struct transhead t;
  t.status = LOGGING;
  t.ip = ip;
  t.offset = off;
  t.size = n;
  //if it's a huge write, SCREW LOGS (for now)!
  if(n > BSIZE*LOGGED_BLOCKS){
	  writei(ip, src, off, n);
  }
  writei(log_ip, &t, 0, sizeof(struct transhead *));		//write status
  writei(log_ip, *src, BSIZE, n);						//write data to log file

  //data is logged, now time for the write -- BOO YA!
  t.status = LOGGED;
  writei(log_ip, &t, 0, sizeof(struct transhead *));
  writei(ip, src, off, n);

  //writing to the log if finally done, god that took forever
  t.status = CLEAR;

  return;
}
