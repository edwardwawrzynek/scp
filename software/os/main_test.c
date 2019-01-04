#include <lib/kstdio_layer.h>
#include <lib/kmalloc.h>

int main(){
    kstdio_set_output_dev(1);

    printf("Testing\nNumber: %i, Hex: %x\nChar: %c\nString: %s\n", -2, 0xffa, 'H', "Hello, World!");

    int * var = kmalloc(0x100);
    printf("Addr 0: %x\n", var);
    kfree(var);
    var = kmalloc(0x50);
    printf("Addr 1: %x\n", var);
    var = kmalloc(0x50);
    printf("Addr 3: %x\n", var);

    while(1){
        putchar(getchar());
    };
}