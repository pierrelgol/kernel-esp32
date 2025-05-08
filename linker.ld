ENTRY(call_start_cpu0)

MEMORY
{
  IRAM (rx) : ORIGIN = 0x40080000, LENGTH = 128K
  DRAM (rw) : ORIGIN = 0x3FFB0000, LENGTH = 128K
}

SECTIONS
{
  .literal : ALIGN(4)
  {
    *(.literal*)
  } > IRAM

  .text : ALIGN(4)
  {
    *(.text*)
    *(.rodata*)
  } > IRAM

  .data : ALIGN(4)
  {
    *(.data*)
  } > DRAM

  .bss (NOLOAD) : ALIGN(4)
  {
    *(.bss*)
    *(COMMON)
  } > DRAM
}
