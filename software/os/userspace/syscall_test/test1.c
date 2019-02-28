#include <stdint.h>
#include <stdio.h>
#include "../syscall_lib/syscall.h"
#include <inout.h>
#include <stddef.h>

char buf[20];

int main(){
	test_syscall("link success: %u\n", unlink("test.txt"), 0, 0);
	exit(0);
}
