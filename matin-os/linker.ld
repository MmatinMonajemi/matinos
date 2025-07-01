ENTRY(_start)

SECTIONS
{
  . = 0x1000;

  .text ALIGN(4096) : {
    *(.multiboot)     /* برای bootloader مثل GRUB */
    *(.text)
    *(.text.*)
  }

  .rodata ALIGN(4096) : {
    *(.rodata)
    *(.rodata.*)
  }

  .data ALIGN(4096) : {
    *(.data)
    *(.data.*)
  }

  .bss ALIGN(4096) (NOLOAD) : {
    _bss_start = .;
    *(.bss)
    *(.bss.*)
    *(COMMON)
    _bss_end = .;
  }

  /DISCARD/ : {
    *(.note*)
    *(.comment)
  }
}
