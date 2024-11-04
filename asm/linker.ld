MEMORY
{
	FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 32K
	RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 4K
}

_stack_end = 0x20001000;

SECTIONS
{
	.text : {
		build/vtable.o (.text)
		*(.text)
	} > FLASH
}
