/*
 * This file contains a stub implementation of the intadd function that uses
 *  the add instruction.  Use this to test your matrix multiplication code.
 *  Once your matrix code works replace this with your intadd from lab3.
 *  If your intadd is not working you can use the intadd implementation provided
 *  by the instructor.  If you profile / submit using this stub version
 *  of intadd you will get a 0 for the corresponding portion of lab4.
 */

    .arch armv8-a
    .global intadd

   /* Include a register usage plan in this comment before the function
    *   ** or ** give each register a meaningful alias using the syntax:
    * arg0 .req x0
    */

intadd:
       
    mov x3, x0
    mov x2, x0
addloop:
    eor x3, x2, x1
    and x2, x2, x1
    lsl x2, x2, #1
    mov x1, x3
    cbnz x2, addloop
    mov x0, x3
    ret
    

