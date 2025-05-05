#include <types.h>

// デバイスのポートに，データを出力する
void outb(uint16_t port, uint8_t data) {
    __asm__ volatile("outb %0, %1" : : "a"(data), "Nd"(port));
}

// デバイスのポートから，データを入力する
uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

// シリアルを初期化する．
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
    while (!serial_ready())
        ;
    outb(0x3F8, c);
}

void serial_puts(const char *s) {
    while (*s)
    {
        if (*s == '\0')
        {
            break;
        }
        serial_putc(*s);
        s++;
    }
}

uint8_t serial_inputc() {
    while ((inb(0x3F8 + 5) & 1) == 0);              // LSRでデータがあるか判別
    return inb(0x3F8); // データを返す
}

void serial_inputs(char *buffer, uint64_t max_len) {
    uint64_t i = 0;
    while (i < max_len - 1) {
        char c = serial_inputc();
        serial_putc(c); // Echo the character back

        if (c == '\r' || c == '\n') { 
            break;
        }

        buffer[i] = c;
        i++;
    }
    buffer[i] = '\0'; // Null終端
}

void kernel_main(void)
{

    // Initalize the serial port
    serial_init();
    for (;;)
    {
        __asm__ volatile("hlt");
    }
}