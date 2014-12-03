/*
 * OK02: a basic blinker
 */
 .section .init
.globl _start
_start:

/*
 * Select the GPIO and put it in output mode. 0x20200000 is the address
 * of the GPIO controller. Note that this differs from the addressing
 * used in the SoC Peripherals documentation, where the GPIO controller
 * has the address 0x7E200000.
 *
 * The next two instructions set the contents of register 1 to 1<<18.
 *
 * Finally, the contents of register 1 are stored in the address
 * pointed contained in register 0 with an offset of 4, which readies
 * the 16th GPIO register (which controls the OK/ACT LED) for output.
 */
ldr r0,=0x20200000 /* Note that registers are 32-bit */
mov r1,#1
lsl r1,#18
str r1,[r0,#4]

/*
 * and they blinked forever and ever
 */
loop$:

/*
 * main screen turn off. The LED is an active-low pin, so it needs to
 * be "turned off", or set low, to activate the LED. An offset of 40
 * turns the pin off, while an offset of 28 turns it on.
 */
mov r1,#1
lsl r1,#16
str r1,[r0,#40]

/*
 * hang out for a bit because #yolo. This is a delay hardcoded based
 * on the fact that all RPis are basically the same.
 */
mov r2,#0x3F0000
wait1$:
sub r2,#1
cmp r2,#0
bne wait1$

/*
 * main screen turn on. Similar to turning the pin on, except with an
 * offset of 28.
 */
mov r1,#1
lsl r1,#16
str r1,[r0,#28]

/*
 * delay again.
 */
mov r2,#0x3F0000
wait2$:
sub r2,#1
cmp r2,#0
bne wait2$

/*
 * rinse and repeat
 */
b loop$

