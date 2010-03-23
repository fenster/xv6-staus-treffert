#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main()
{
	//Old FS can support files of size: ~71,000 bytes
	
	int i;
	int fd = open("BIGFSTEST", O_CREATE);			//Open test file
	printf(2, "Opened test file\n");
	for(i = 0; i <= 2000000; i++)					//Add 200,000 bytes to a file
	{
		printf(fd, "F");
		if( i % 100000 == 0)
		{
			printf(2, "Added %d bytes to the test file\n", i);
		}
	}
	printf(2, "Test Passed\n");
	close(fd);
	exit();
}

