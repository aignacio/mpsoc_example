/**
 * RISC-V bootup test
 * Author: Daniele Lacamera <root@danielinux.net>
 * Modified by: Anderson Ignacio <anderson@aignacio.com>
 *
 * MIT License
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
OUTPUT_ARCH( "riscv" )

ENTRY( _start_reset )

MEMORY
{
  IRAM(rxai!w) : ORIGIN = 0x80000000, LENGTH = 4K
  DRAM(wxa!ri) : ORIGIN = 0x90000000, LENGTH = 1K
}

_min_stack      = 0x100;

SECTIONS
{
    .text :
    {
        _start_text = .;
        KEEP(*(.init))
        . = ORIGIN(IRAM) + 0x100;
        _start_vector = .;
        KEEP(*(.isr_vector))
        *(.text*)
        _edata = .;
        *(.rodata*)
        *(.srodata*)
        . = ALIGN(4);
        _end_text = .;
    } > IRAM

    /* Start of LMA address of data/bss */
    _stored_data = .;

    /* VMA of data/bss/stack/heap should be the DRAM */
    .data : AT (_stored_data)
    {
        _start_data = .;
        *(.data*)
        _global_pointer = . + 0x400;
        *(.sdata*)
        . = ALIGN(4);
        _end_data = .;
    } > DRAM

    .bss :
    {
        _start_bss = .;
        *(.bss*)
        *(.sbss*)
        *(COMMON)
        . = ALIGN(4);
        _end_bss = .;
        _end = .;
    } > DRAM

}
PROVIDE(__global_pointer$ = _global_pointer);
PROVIDE(end = _end);
PROVIDE(_start_heap = _end);
PROVIDE(_end_stack  = ORIGIN(DRAM) + (LENGTH(DRAM) - _min_stack) );
