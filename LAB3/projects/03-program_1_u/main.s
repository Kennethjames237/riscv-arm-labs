# Add an optional .data section here.
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
# Loading base addresses
    la x1, N
    la x2, V
    la x3, gamma
    la x4, beta
    la x5, eps
    la x6, bn
    la x7, result

#------------------------------------------Calculation of mean (Unrolled x2)------------------------------------------------------------#
mean: 
    lw x9, 0(x1)        # N = 4
    li x8, 0            # counter i = 0
    fmv.w.x f2, x0      # sum = 0.0

loop_step_1:
    beq x8, x9, calculate_mean

    # Iteration i and i+1 loaded together
    flw f1, 0(x2)
    flw f11, 4(x2)

    # Accumulate both floats
    fadd.s f2, f2, f1
    fadd.s f2, f2, f11

    # i += 2, pointer += 8
    addi x8, x8, 2
    addi x2, x2, 8

    j loop_step_1

calculate_mean:
    la x10, four
    flw f6, 0(x10)
    fdiv.s f4, f2, f6    # u = sum(v) / N

#------------------------------------------Calculation of variance (Unrolled x2)--------------------------------------------------------#
variance:
    la x2, V
    li x8, 0            # counter i = 0
    fmv.w.x f5, x0      # var_sum = 0.0

loop_step_2:
    beq x8, x9, calculate_variance

    # Load pair (v[i], v[i+1])
    flw f1, 0(x2)
    flw f11, 4(x2)

    # Compute (v[i] - u)^2
    fsub.s f3, f1, f4
    fmul.s f3, f3, f3

    # Compute (v[i+1] - u)^2
    fsub.s f12, f11, f4
    fmul.s f12, f12, f12

    # Accumulate both squared differences
    fadd.s f5, f5, f3
    fadd.s f5, f5, f12

    # i += 2, pointer += 8
    addi x8, x8, 2
    addi x2, x2, 8
    j loop_step_2

calculate_variance:
    fdiv.s f5, f5, f6    # var = var_sum / N

#------------------------------------------Normalization (Unrolled x2)-------------------------------------------------------------------#
normalisation:
    flw f2, 0(x3)        # gamma
    flw f3, 0(x4)        # beta
    flw f7, 0(x5)        # eps

    # Denominator = sqrt(var + eps)
    fadd.s f7, f7, f5
    fsqrt.s f7, f7
    fsw f7, 0(x7)

    li x8, 0             # counter i = 0
    la x2, V

loop_step_3:
    beq x8, x9, End

    # Load pair (v[i], v[i+1])
    flw f1, 0(x2)
    flw f11, 4(x2)

    # Element i: (v[i] - u) / D * gamma + beta
    fsub.s f10, f1, f4
    fdiv.s f10, f10, f7
    fmul.s f10, f2, f10
    fadd.s f10, f10, f3
    fsw f10, 0(x6)

    # Element i+1: (v[i+1] - u) / D * gamma + beta
    fsub.s f13, f11, f4
    fdiv.s f13, f13, f7
    fmul.s f13, f2, f13
    fadd.s f13, f13, f3
    fsw f13, 4(x6)

    # Update pointers and counter (i += 2)
    addi x6, x6, 8
    addi x8, x8, 2
    addi x2, x2, 8
    j loop_step_3

#------------------------------------------End of Program--------------------------------------------------------------------------------

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
