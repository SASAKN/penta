#include <types.h>
#include <proto.h>

// Output a byte to the serial port
void outb(uint16_t port, uint8_t data) {
    __asm__ volatile("outb %0, %1" : : "a"(data), "Nd"(port));
}

// Input a byte from the serial port
uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

// Initalize the serial port
void serial_init() {
    outb(0x3F8 + 1, 0x00); // Disable all interrupts
    outb(0x3F8 + 3, 0x80); // Enable DLAB (set baud rate divisor)
    outb(0x3F8 + 0, 0x01); // Set divisor to 1 (lo byte) 115200 baud
    outb(0x3F8 + 1, 0x00); //                  (hi byte)
    outb(0x3F8 + 3, 0x03); // 8 bits, no parity, one stop bit
    outb(0x3F8 + 2, 0xC7); // Enable FIFO, clear them, with 14-byte threshold
    outb(0x3F8 + 4, 0x0B); // IRQs enabled, RTS/DSR set
}

// Read the value of the EBX register
uint32_t read_ebx() {
    uint32_t ebx_value;
    __asm__ volatile (
        "mov %%ebx, %0" 
        : "=r" (ebx_value)  
        :                    
        : "%ebx"             
    );

    return ebx_value;
}

// Check if the serial port is ready to send data
int serial_ready() {
    return inb(0x3F8 + 5) & 0x20;
}

// Output a character to the screen
void serial_putc(char c) {
    while (!serial_ready())
        ;
    outb(0x3F8, c);
}

// Output a string to the screen
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

// Input a character from the serial port
uint8_t serial_inputc() {
    while ((inb(0x3F8 + 5) & 1) == 0);              // LSRでデータがあるか判別
    return inb(0x3F8); // データを返す
}

// Input a string from the serial port
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

void uint32_to_str(uint32_t value, char *buffer) {
    // 10進数変換のために必要な最大桁数 + NULL終端
    char temp[10];
    int i = 0;

    // 値が0の場合の処理
    if (value == 0) {
        buffer[0] = '0';
        buffer[1] = '\0';
        return;
    }

    // 数字を下位桁から取り出してtempに格納
    while (value > 0) {
        temp[i++] = '0' + (value % 10);
        value /= 10;
    }

    // 逆順にしてbufferに格納
    int j = 0;
    while (i > 0) {
        buffer[j++] = temp[--i];
    }

    buffer[j] = '\0';
}