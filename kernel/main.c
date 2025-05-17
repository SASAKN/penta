#include <types.h>
#include <multiboot.h>
#include <proto.h>

void kernel_main(void) {

    serial_init();
    serial_puts("Hello, World!\n");

    // Initalize the serial port
    for (;;) {
        __asm__ volatile("hlt");
    }
}