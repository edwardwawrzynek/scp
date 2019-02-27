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
		while(1);
	}
	/* change dir */
	int val = chroot("/dev");
	test_syscall("chdir val: %u\n", val);
	pid = fork();
	if(pid){
		fd = open("/tty0", O_RDONLY);
		test_syscall("2 fd: %u\n", fd, 0,0);
		while(1);

	}


	while(1);
}
