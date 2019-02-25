#include <stdint.h>
#include <stdio.h>
#include "../syscall_lib/syscall.h"
#include <inout.h>

char buf[20];

int main(){
	//test_syscall("Parent Starting.\nPID: %u\nForking..", getpid(), 0, 0);
	uint16_t pid = fork();
	if(pid == 0){
		//test_syscall("Child Running\nChild PID: %u\nChild's parent pid: %u\n", getpid(), getppid(), 0);
	} else {
		//test_syscall("Parent Running\nParent's Child PID: %u\n", pid, 0, 0);
		int fd = creat("test.txt");
		test_syscall("FD: %u\n", fd, 0,0);
		write(fd, "hello, world! This is a test. What fun. this is cool.", 54);
		close(fd);
	}

	while(1);
}
