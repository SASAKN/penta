#include <types.h>
#include <multiboot.h>
#include <proto.h>

// Assembly Functions
extern void check_compatibility_cpuid(void);
extern void check_compatibility_long_mode(void);
extern void set_up_page_tables(void);
extern void set_up_cr_registers(void);
extern void enable_long_mode(void);
extern void enable_paging(void);
extern void set_up_gdt(void);
extern void start_boot64(void);

// Bootpack is a boot initalization program inspired by haribote os
// This program is booted by the 32-bit bootloader.

void bootpack32(uint32_t addr) {

    // Initalize the serial port
    serial_init();
    serial_puts("Bootpack32 : Booting...\n");

    // Check for the kernel compatibility
    check_compatibility_cpuid();
    check_compatibility_long_mode();
    
    // Set up for long mode
    set_up_page_tables();
    set_up_cr_registers();
    enable_long_mode();
    enable_paging();

    // Set up the GDT and jump to long mode kernel
    set_up_gdt();
    start_boot64();

    return;
}