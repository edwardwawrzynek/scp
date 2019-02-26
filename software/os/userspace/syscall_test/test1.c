#include <stdint.h>
#include <stdio.h>
#include "../syscall_lib/syscall.h"
#include <inout.h>
#include <stddef.h>

char buf[20];

int main(){
	for(int i = 0; i < 10; i++){
		int pid = fork();
		if(pid == 0){
			execv("test2", NULL);
		}
		for(int p=1;p;p++){
			for(int j=0;j<7;j++);
		}
	}

	while(1);
}
