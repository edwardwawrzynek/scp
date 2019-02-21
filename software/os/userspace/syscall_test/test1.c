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
	}


	while(1){
		if(pid){
			test_syscall("A", 0, 0, 0);
			for(int i = 0; i < 10000; i++){
				for(int q = 0; q < 100; q++);
			}

		} else {
			test_syscall("B", 0, 0, 0);
			for(int i = 0; i < 27000; i++){
				for(int q = 0; q < 100; q++);
			}
		}
	}
}
