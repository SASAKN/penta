#ifndef __PROTO_H
#define __PROTO_H

#include <types.h>

// This file defines the prototypes for the functions used in the kernel.

// serial.c
void outb(uint16_t port, uint8_t data);
uint8_t inb(uint16_t port);
void serial_init();
uint32_t read_ebx();
int serial_ready();
void serial_putc(char c);
void serial_puts(const char *s);
uint8_t serial_inputc();
void serial_inputs(char *buffer, uint64_t max_len);
void uint32_to_str(uint32_t value, char *buffer);

// main.c
void kernel_main(void *addr);

#endif