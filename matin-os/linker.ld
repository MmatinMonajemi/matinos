ENTRY(main)

SECTIONS
{
  . = 0x1000;

  .text ALIGN(4K) : {
    *(.multiboot)     /* برای bootloader مثل GRUB */
    *(.text)
    *(.text.*)
  }

  .rodata ALIGN(4K) : {
    *(.rodata)
    *(.rodata.*)
  }

  .data ALIGN(4K) : {
    *(.data)
    *(.data.*)
  }

  .bss ALIGN(4K) (NOLOAD) : {
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
