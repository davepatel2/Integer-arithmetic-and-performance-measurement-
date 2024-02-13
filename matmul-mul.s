////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A, height of matrix B
//! @param wB         width of matrix B
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
///!x19         result matrix / C
//! x20         matrix A 
//! x21         matrix B
//! x22 hA      height of matrix A
//! x23 wA      width of matrix A, height of matrix B
//! x24 wB      width of matrix B
//	x6 			i
//` x7 			j
//	x9 			k
// x10 			val of A offset
// x11 			val of B offset
// x12			val of C offset
//	x25			sum
//  NOTE: This version should use the MUL/MLA and ADD instructions
//
////////////////////////////////////////////////////////////////////////////////

	.arch armv8-a
	.global matmul
matmul:
	stp x29, x30, [sp, -80]!
    mov x29, sp
    str x19, [sp, 16]
    str x20, [sp, 24]
    str x21, [sp, 32]
	str x22, [sp, 40] 
	str x23, [sp, 48]
	str x24, [sp, 56]
	str x25, [sp, 64]

	mov x19, x0 //C
	mov x20, x1 //A
	mov x21, x2 //B 
	mov w22, w3 //ha
	mov w23, w4	//wa
	mov w24, w5 //wb
	

	mov w6, #0 // i = 0
firstloop:
	cmp w6, w22 // i <= ha
    beq end
	mov w7, #0 // j = 0
innerloop:
	cmp w7, w24
	beq endinner
	mov w25, #0 //sum = 0
	mov w9, #0 // k = 0
mult: 
	cmp x9, x23 //for loop condition
	beq endmult

	mov w10, #0
	mov w11 ,#0
	//calc offset in w10 and w11 temp registers to hold the calc values
	mul w10, w6, w23	//i * wa
	add w10, w10, w9	// x10 + k

	mul w11, w9, w24 // k * wb
	add w11, w11, w7 //x11 + j

	//actually find the val at offset
	mov w13, #2
	lsl w10, w10, w13
	lsl w11, w11, w13
	ldr w10, [x20, w10, sxtw]

	ldr w11, [x21, w11, sxtw]

	//multiply A[i * wA + k] * B[k * wB + j]
	mul w10, w10, w11

	//add it to sum
	//ldr w25, [sp, 64]
	add w25, w25, w10
	//str w25, [sp, 64]
	
	add w9, w9, #1
    b mult


endmult: 
	//calc new offset for C C[i * wB + j] = sum;
	mov w12, #0
	mul w12, w6, w24	//i * wb
	add w12, w12, w7	// x12 + j
	mov w13, #2
	lsl w12, w12, w13
	str w25, [x19, w12, sxtw]	//store sum

	//increment j
	add w7, w7, #1
    b innerloop 

endinner:
	add w6, w6, #1
    b firstloop 
end:
	ldr x19, [sp, 16]
    ldr x20, [sp, 24]  
    ldr x21, [sp, 32]
	ldr x22, [sp, 40]
    ldr x23, [sp, 48]  
    ldr x24, [sp, 56]
	ldr x25, [sp, 64]
    ldp x29, x30, [sp], 80
    ret
