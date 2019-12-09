#include <lib/kstdio_layer.h>
#include <kernel/kernel.h>
#include <panic.h>
#include <kernel/panic.h>
#include "dev/dev.h"

int main(){
    kernel_init();
    printf("Kernel Booted\t\t\t[ \x1b[92mOK\x1b[39m ]\n\n");
    printf("Welcome to \x1b[96mSCP OS v0.0.1\x1b[39m\n\n");
    printf("Author: Edward Wawrzynek\n");
    printf("The programs distributed with SCP are free software and are liscensed under the GPL-3\n");
    printf("https://github.com/edwardwawrzynek/scp\n");

    printf("Starting /etc/init\t\t");
    kernel_start_init("/etc/init", 1);
    printf("[FAIL]\n/etc/init not found\n");
    panic(PANIC_NO_INIT_FILE);
}
