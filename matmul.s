////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C result matrix
//! @param A matrix A
//! @param B matrix B
//! @param hA height of matrix A
//! @param wA width of matrix A, height of matrix B
//! @param wB width of matrix B
//
// Note that while A, B, and C represent two-dimensional matrices,
// they have all been allocated linearly. This means that the elements
// in each row are sequential in memory, and that the first element
// of the second row immedialely follows the last element in the first
// row, etc.
//
// If you run out of registers you can store values on the stack to
// free up registers for other uses.
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA,
// unsigned int wA, unsigned int wB)
//{
// for (unsigned int i = 0; i < hA; ++i)
// for (unsigned int j = 0; j < wB; ++j) {
// int sum = 0;
// for (unsigned int k = 0; k < wA; ++k) {
// sum += A[i * wA + k] * B[k * wB + j];
// }
// C[i * wB + j] = sum;
// }
//}
///!x19 result matrix / C
//! x20 matrix A
//! x21 matrix B
//! x22 hA height of matrix A
//! x23 wA width of matrix A, height of matrix B
//! x24 wB width of matrix B
// x25 sum
// x10 i
// x11 j
// x12 k
//x26, val of A offset
// x27  val of B offset
// x28 val of C offset
//
// NOTE: This version should call the intadd and intmul functions
//
////////////////////////////////////////////////////////////////////////////////

.arch armv8-a
.global matmul
matmul:
stp x29, x30, [sp, -128]!
mov x29, sp
str x19, [sp, 16]
str x20, [sp, 24]
str x21, [sp, 32]
str x22, [sp, 40]
str x23, [sp, 48]
str x24, [sp, 56]
str x25, [sp, 64] //sum
str x26, [sp, 72] // val of A offset
str x27, [sp, 80] // val of B offset
str x28, [sp, 88] // val of C offset
// w10 is i
//w11 is j
//w12 is k


mov x19, x0 //C
mov x20, x1 //A
mov x21, x2 //B
mov w22, w3 //ha
mov w23, w4 //wa
mov w24, w5 //wb

	mov w10 , #0 // i = 0
firstloop:
	cmp w10, w22 // i <= Ha
	beq end
	mov w11, #0 //initialize j
innerloop:
//compare and initalize sum and k
	cmp w11, w24
	beq endinner
	mov w25, #0
	mov w12, #0
mult:

	cmp w12, w23
	beq endmult


	mov w0, w10 // set up params
	mov w1, w23
	bl intmul //call mult i*wa
	mov w26, w0 //put back into offset A

	mov w0, w26 //set up params for add
	mov w1, w12 // adds x10 + k
	bl intadd
	mov w26, w0 //A offset is in w26

//A offset is now calculates and in w26


	mov w0, w12 //set up params
	mov w1, w24 // k * wb
	bl intmul
	mov w27, w0 //mov result into w12

	mov w0, w27 // 12 holds k * wb
	mov w1, w11 // 11 is j
	bl intadd
	mov w27, w0//B offset in w27

// actually find val at offset
	mov w13, #2
	lsl w26, w26, w13
	lsl w27, w27, w13
	ldr w26, [x20, w26, sxtw]
	ldr w27, [x21, w27, sxtw]

//multiplies A[i * wA + k] * B[k * wB + j] puts it into 10
mov w0, w26
mov w1, w27
bl intmul
mov w26, w0

mov w0, w26
mov w1, w25
bl intadd
mov w25, w0



//increment k
mov w0, w12
mov w1, #1
bl intadd
mov w12, w0

b mult

endmult:
// do i even need to store k?
// multiples i * wb
mov w0, w10
mov w1, w24
bl intmul
mov w28, w0

// adds j
mov w0, w28
mov w1, w11
bl intadd
mov w12, w0

mov w13, #2
lsl w12, w12, w13
str w25, [x19, w12, sxtw]

mov w0, w11
mov w1, #1
bl intadd
mov w11, w0
b innerloop

endinner:
mov w0, w10
mov w1, #1
bl intadd
mov w10, w0
b firstloop

end:
ldr x19, [sp, 16]
ldr x20, [sp, 24]
ldr x21, [sp, 32]
ldr x22, [sp, 40]
ldr x23, [sp, 48]
ldr x24, [sp, 56]
ldr x25, [sp, 64]
ldr x26, [sp, 72] // i
ldr x27, [sp, 80] // j
ldr x28, [sp, 88] // k
ldp x29, x30, [sp], 128
