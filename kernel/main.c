// 8bitと16bit整数を明示的に定義
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;

static void outb(u16 port, u8 value) {
    __asm__ volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}

static u8 inb(u16 port) {
    u8 ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

void serial_init() {
    outb(0x3F8 + 1, 0x00); // Disable all interrupts
    outb(0x3F8 + 3, 0x80); // Enable DLAB (set baud rate divisor)
    outb(0x3F8 + 0, 0x01); // Set divisor to 1 (lo byte) 115200 baud
    outb(0x3F8 + 1, 0x00); //                  (hi byte)
    outb(0x3F8 + 3, 0x03); // 8 bits, no parity, one stop bit
    outb(0x3F8 + 2, 0xC7); // Enable FIFO, clear them, with 14-byte threshold
    outb(0x3F8 + 4, 0x0B); // IRQs enabled, RTS/DSR set
}


int serial_ready() {
    return inb(0x3F8 + 5) & 0x20;
}

void serial_putc(char c) {
    while (!serial_ready());
    outb(0x3F8, c);
}

void serial_puts(const char* s) {
    while (*s) {
        if (*s == '\0') {
            break;
        }
        serial_putc(*s);
        s++;
    }
}

void kernel_main() {
    serial_init();
    serial_puts("Hello, world!\n");
    for (;;) __asm__ volatile ("hlt");
}
