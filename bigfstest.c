#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main()
{
	//Old FS can support files of size: ~71,000 bytes
	
	struct stat *fstats;
	int i;
	int fd = open("BIGFSTEST", O_CREATE | O_RDWR);			//Open test file
	printf(2, "Opened test file\n");
	printf(2, "fd is %d\n", fd);

	for(i = 0; i <= 200000; i++)					//Add 200,000 bytes to a file
	{

		if( i % 10000 == 0)
		{
			fstat(fd, fstats);
			printf(2, "Test file size is %d bytes\n", fstats->size);
		}
		printf(fd, "f");
	}

	printf(2, "Test Passed\n");
	close(fd);
	exit();
}

