/*
 * This file contains a stub implementation of the intmul function that uses
 *  the add instruction.  Use this to test your matrix multiplication code.
 *  Once your matrix code works replace this with your intmul from lab3.
 *  If your intmul is not working you can use the intmul implementation provided
 *  by the instructor.  If you profile / submit using this stub version
 *  of intmul you will get a 0 for the corresponding portion of lab4.
 */

    .arch armv8-a
    .global intmul

   /* Include a register usage plan in this comment before the function
    *   ** or ** give each register a meaningful alias using the syntax:
    * arg0 .req x0
    */

intmul:
    mul   w0, w0, w1
    ret
