#include <stdint.h>
#include <stdio.h>
#include "../syscall_lib/syscall.h"
#include <inout.h>
#include <stddef.h>

char buf[20];

struct dirent entry;

int main(){
	/*test_syscall("Mkdir: %u\n", mkdir("test"));
	test_syscall("chdir: %u\n", chdir("test"));
	test_syscall("File creationg: %u\n", creat("test-file"));
	int fd = open("/test/test-file", O_WRONLY);
	test_syscall("File open: %u\n", fd);
	int res = write(fd, "hello, world\n", 14);
	test_syscall("write result: %u\n", res);
	//test_syscall("remove file result: %u\n", unlink("test-file"));
	//test_syscall("remove dir result: %u\n", rmdir("../test"));*/
	int fd = open("/test", O_RDWR);
	test_syscall("fd: %u\n", fd);
	read(fd, buf, 20);
	hexdump(buf, 20);
	test_syscall("Buffer: %s\n", (uint16_t) buf);

	/*while(readdir(fd, &entry) == 1){
		test_syscall("Inode: %u, Name: %s\n", (uint16_t)entry.inum, (uint16_t)entry.name);
	}*/
	exit(0);
}
