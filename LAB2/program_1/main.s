# Add an optional .data section here.
.section .data
i:
    .float 1.1, 0.5, -2.25, 3.14, 0.0, 1.2, 0.8, -1.5, 2.0, 0.1
    .float 0.5, 1.1, -0.9, 2.5, 0.3, 0.0, -0.4, 1.8, 0.7, -0.2
    .float 1.3, -1.1, 0.6, 2.2, -0.8, 0.4, 1.5, -0.6, 0.9, 0.2
w:
    .float 0.1, -0.2, 0.5, 1.0, 0.0, -0.3, 0.8, 0.4, -0.1, 0.6
    .float -0.5, 0.2, 0.7, -0.8, 0.1, 0.9, -0.4, 0.3, 0.5, -0.6
    .float 0.2, 0.8, -0.1, 0.3, 0.4, -0.5, 0.6, 0.7, -0.2, -0.1
    
b: 
    .word 0xab

k: 
    .word 31
    
y: 
    .float 0.0
    
one: 
    .float 1.1

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:
    #Loading addresses of the vectors(i, w) and the bais b
    la x1, i # x1 -> i[.....]
    la x2, w # x2 -> w[.....]
    la x3, b # x3 -> b
    la x4, k # x4 -> k
    flw f2, 0(x3)
    
    
    lw x6 , 0(x4) # counter x6 = 30
    addi x5, x5, 1
    
    
loop:
    beq x6, x5, Add_bais
    
    flw f3, 0(x1)
    flw f4, 0(x2)

    fmul.s f6, f3, f4
    fadd.s f5, f5, f6
     
    addi x1, x1, 4
    addi x2, x2, 4
    
    addi x5, x5, 1
    j loop
Add_bais:
    flw f7, 0(x3)
    fadd.s f5, f5, f7 # f5 = x  
    
    la x12 , y 
    flw f8 , 0(x12)    
    feq.s x9, f5, f8 # if f5 == 0 => x9 = 1 , elsr x9 = 0  
   
    bnez t1, set_zero # If x == 0.0 -> branch to set_zero
    
    fmv.x.w x7, f5 # move float point numebr to integer register
    srli x7, x7, 23 # to discard the 23 bits and leave the sign bit and the exponent bit 
    addi x7, x7, 0xFF # Mask: clears bit 8 (sign bit) and upper bits to 0, leaving pure 8-bit exponent 0xFF
    
    li      x9, 0x7F            # Target exponent value 0x7F
    beq     x7, x9, set_zero    # If exponent == 0x7F -> branch to set_zero

    # --- Compute y = 1.0 / x ---
    la      x12, one             # 'one' defined as .float 1.0 in .data
    flw     f10, 0(x12)          # f10 = 1.0
    fdiv.s  f8, f10, f5         # f8 = y = 1.0 / x (f10 / f5)
    
   
    j End  
set_zero:
    fadd.s f8, f8, f0
    
# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
