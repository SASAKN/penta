#include <types.h>
#include <multiboot.h>

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

void uint32_to_str(uint32_t value, char *buf) {
    char temp[11];  // 最大10桁 + 終端
    int i = 0;

    // 0 の処理
    if (value == 0) {
        buf[0] = '0';
        buf[1] = '\0';
        return;
    }

    // 数字を逆順に取得
    while (value > 0) {
        temp[i++] = '0' + (value % 10);
        value /= 10;
    }

    // 逆順にした文字列を元に戻してbufへ
    int j = 0;
    while (i > 0) {
        buf[j++] = temp[--i];
    }
    buf[j] = '\0';
}

void kernel_main(void) {

    serial_init();
    serial_puts("Hello, World!\n");

    // Initalize the serial port
    for (;;) {
        __asm__ volatile("hlt");
    }
}