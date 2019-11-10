#include <lib/kstdio_layer.h>
#include <kernel/kernel.h>
#include <panic.h>
#include <kernel/panic.h>

int main(){
    printf("Booting Kernel\n");
    kernel_init();
    printf("Kernel Booted\t\t\t[ OK ]\n\n");
    printf("####   ###   ###      ##   ####\n");
    printf("#     #     #  #     #  #  #   \n");
    printf("####  #     ###   #  #  #  ####\n");
    printf("   #  #     #        #  #     #\n");
    printf("####   ###  #         ##   ####\n\n");
    printf("Welcome to SCP OS v0.0.1\n");
    printf("Author: Edward Wawrzynek\n");
    printf("The programs distributed with SCP are free software and are liscensed under the GPL-3\n");
    printf("https://github.com/edwardwawrzynek/scp\n");

    printf("Starting /etc/init\t\t");
    kernel_start_init("/etc/init", 1);
    printf("[FAIL]\n/etc/init not found\n");
    panic(PANIC_NO_INIT_FILE);
}
