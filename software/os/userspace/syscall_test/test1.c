#include <stdint.h>
#include <stdio.h>
#include "../syscall_lib/syscall.h"
#include <inout.h>

int main(){
	test_syscall("Parent Starting.\nPID: %u\nForking..", getpid(), 0, 0);
	uint16_t pid = fork();
	if(pid == 0){
		test_syscall("Child Running\nChild PID: %u\nChild's parent pid: %u\n", getpid(), getppid(), 0);
	} else {
		test_syscall("Parent Running\nParent's Child PID: %u\n", pid, 0, 0);
		int fd = open("/dev/tty0", 3);
		test_syscall("FD Opened: %u\n", fd, 0, 0);
		fd = open("/dev/serial0", 3);
		test_syscall("FD Opened: %u\n", fd, 0, 0);

	}

	while(1);
}
