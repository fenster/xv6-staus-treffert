#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"  //might not need

int
main(){

	char buf[512];
	int val;

	printf(2, "Open file, no reads.\n");
	int fd = open("log", O_RDONLY);

	printf(2, "fd = %d\n", fd);


	val = check(fd, 1);
	printf(2, "Check at 1, returns %d.   Expected: 0\n", val);
	val = check(fd, 3);			//should return 0
	printf(2, "Check at 3, returns %d.   Expected: 0\n", val);

	printf(2, "Read from 1.\n");
	read(fd, buf, 1);		//put one block in the buffer

	val = check(fd, 1);			//should return 1
	printf(2, "Check at 1, returns %d.   Expected: 1\n", val);
	val = check(fd, 1);			//should return 0
	printf(2, "Check at 1, returns %d.   Expected: 0\n", val);

	printf(2, "Read from 1.\n");
	read(fd, buf, 1);		//put another block in buffer

	val = check(fd, 1);			//should return 1
	printf(2, "Check at 1, returns %d.   Expected: 1\n", val);
	val = check(fd, 1);			//should return 1
	printf(2, "Check at 1, returns %d.   Expected: 1\n", val);

	close(fd);

	exit();



}
