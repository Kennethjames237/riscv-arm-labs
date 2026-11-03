# Add an optional .data section here.
.section .data
# ---------- Batch of N = 4 fixed values ----------
N:      .word 4
V:      .float 0.62, -0.35, 1.18, 1.07
# ---------- Batch normalization ----------
gamma:  .float 1.0
beta:   .float 0.0
eps:    .float 0.001
bn:     .space 16       # N normalized floats
result: .space 4        # sqrt(variance + eps)
four: .float 4.0

# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

# Load base addresses
    la x1, N
    la x2, V
    la x3, gamma
    la x4, beta
    la x5, eps
    la x6, bn
    la x7, result

#------------------------------------------Calculation of mean (Re-scheduled)-----------------------------------------------------------#
mean: 
    lw x9, 0(x1)        # N = 4
    li x8, 0            # counter i = 0
    fmv.w.x f2, x0      # sum = 0.0

loop_step_1:
    beq x8, x9, calculate_mean
    flw f1, 0(x2)
    
    # Interleave pointer and counter updates during load delay
    addi x8, x8, 1
    addi x2, x2, 4
    
    fadd.s f2, f2, f1
    j loop_step_1

calculate_mean:
    la x10, four
    flw f6, 0(x10)
    fdiv.s f4, f2, f6    # u = sum(v) / N

#------------------------------------------Calculation of variance (Re-scheduled)-------------------------------------------------------#
variance:
    la x2, V
    li x8, 0            # counter i = 0
    fmv.w.x f5, x0      # var_sum = 0.0

loop_step_2:
    beq x8, x9, calculate_variance
    flw f1, 0(x2)
    
    # Compute difference
    fsub.s f2, f1, f4
    
    # Interleave pointer/counter increments while waiting for fsub.s (latency 4)
    addi x8, x8, 1
    addi x2, x2, 4
    
    # f2 is now ready for fmul.s
    fmul.s f2, f2, f2
    
    # fadd.s waits for fmul.s (latency 6); no stalls remaining when interleaved
    fadd.s f5, f5, f2
    j loop_step_2

calculate_variance:
    fdiv.s f5, f5, f6    # var = var_sum / N

#------------------------------------------Normalization (Re-scheduled)------------------------------------------------------------------#
normalisation:
    flw f2, 0(x3)        # gamma
    flw f3, 0(x4)        # beta
    flw f7, 0(x5)        # eps

    # Calculate Denominator = sqrt(var + eps)
    fadd.s f7, f7, f5
    fsqrt.s f7, f7
    fsw f7, 0(x7)

    li x8, 0             # counter i = 0
    la x2, V

loop_step_3:
    beq x8, x9, End
    flw f1, 0(x2)
    
    # Compute numerator: (v_i - mean)
    fsub.s f10, f1, f4
    
    # Divide by denominator f7
    fdiv.s f10, f10, f7
    
    # Interleave pointer and counter updates while waiting for fdiv.s to complete
    addi x6, x6, 4
    addi x8, x8, 1
    addi x2, x2, 4
    
    # Multiply by gamma and add beta
    fmul.s f10, f2, f10
    fadd.s f10, f10, f3
    fsw f10, -4(x6)
    
    j loop_step_3

#------------------------------------------End of Program--------------------------------------------------------------------------------#

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
