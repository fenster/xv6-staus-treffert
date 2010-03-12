#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"  //might not need

int
main(){

	char buf[512];
	int val;

	printf(2, "Open file, no reads.\n");
	int fd = open("README", O_RDONLY);

	printf(2, "fd = %d\n", fd);


	val = check(fd, 128);
	printf(2, "Check at 128, returns %d.   Expected: 0\n", val);
	val = check(fd, 700);			//should return 0
	printf(2, "Check at 700, returns %d.   Expected: 0\n", val);

	printf(2, "Read from 128.\n");
	read(fd, buf, 128);		//put one block in the buffer

	val = check(fd, 128);			//should return 1
	printf(2, "Check at 128, returns %d.   Expected: 1\n", val);
	val = check(fd, 700);			//should return 0
	printf(2, "Check at 700, returns %d.   Expected: 0\n", val);

	printf(2, "Read from 638.\n");
	read(fd, buf, 510);		//put another block in buffer

	val = check(fd, 128);			//should return 1
	printf(2, "Check at 128, returns %d.   Expected: 1\n", val);
	val = check(fd, 700);			//should return 1
	printf(2, "Check at 700, returns %d.   Expected: 1\n", val);

	close(fd);

	exit();



}
