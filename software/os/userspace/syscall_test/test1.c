#include <stdint.h>
#include <stdio.h>
#include "../syscall_lib/syscall.h"
#include <inout.h>
#include <stddef.h>

char buf[20];

int main(){
	int pid, fd;

	pid = fork();
	if(!pid){
		fd = open("/tty0", O_RDONLY);
		test_syscall("1 fd: %u\n", fd, 0,0);
		exit(0);
	}
	/* change dir */
	int val = chroot("/dev");
	test_syscall("chdir val: %u\n", val);
	pid = fork();
	if(!pid){
		fd = open("/tty0", O_RDONLY);
		test_syscall("2 fd: %u\n", fd, 0,0);
		for(int i = 320000; i; i++){
			int val = getpid();
		}
		exit(1);

	}
	uint8_t value;
	while((pid = wait(&value)) != -1){
		test_syscall("Proc %u Returned %u\n", pid, value, 0);
	}


	exit(2);
}
