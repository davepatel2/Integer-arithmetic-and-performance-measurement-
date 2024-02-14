.arch armv8-a
.global intmul


/* Include a register usage plan in this comment before the function
    *   ** or ** give each register a meaningful alias using the syntax:
    * arg0 .req x0
     // x0: First op
    // x1: Second op
    // x2:  result
    // x3: sign flag
    // x4: temp
    // x9: Carry 
    // x14: temp sum
    */
    
intmul:
    // Initialize 
    mov x2, xzr
    mov x3, xzr

    
    asr x4, x0, #63
    eor x3, x3, x4
    cmp x4, #0
    bne posop1  // Branch if x0 negative

    asr x4, x1, #63
    eor x3, x3, x4
    cmp x4, #0
    bne posop2   // Branch if x1 negative

    // Check if x1 zero
    cmp x1, #0
    beq done  // Skip mult

mult:
    and x4, x1, #1
    cmp x4, #0
    beq noadd  // Skip addition 

    // Addition w carry
    mov x14, x2
    mov x9, x0
addloop:
    eor x2, x14, x9
    and x9, x14, x9
    lsl x9, x9, #1
    cmp x9, #0
    mov x14, x2
    bne addloop  //loop addition

noadd:
    lsl x0, x0, #1
    lsr x1, x1, #1
    cmp x1, #0
    bne mult  // loop if x1 not 0

    
    cmp x3, #0
    beq done
    neg x2, x2

done:
    mov x0, x2
    ret

posop1:
    neg x0, x0
    b mult

posop2:
    neg x1, x1
    b mult


