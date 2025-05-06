ENTRY(start)

SECTIONS {
  . = 1M;

  .multiboot2_header : {
    KEEP(*(.multiboot2_header))
  }

  .text : {
    *(.text*)
  }

  .rodata : { *(.rodata*) }
  .data   : { *(.data*) }
  .bss    : {
    *(.bss*)
    *(COMMON)
  }
}
