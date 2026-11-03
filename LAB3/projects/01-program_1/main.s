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
    #laoding the address of all constants and result
    la x1, N
    la x2, V # don't forget that you change the location so you need to la every time you whant to loop
    la x3, gamma
    la x4, beta
    la x5, eps
    la x6, bn
    la x7, result
    
#------------------------------------------Calculation of mean----------------------------------------------------------------------------#
mean: 
    lw x9, 0(x1) # N == x9 == 4
    addi x8, x8, 0 # counter i
    fmv.w.x f2, x0 # remember that before using a register you need to put 0 and then use it correctly
    
loop_step_1:
    beq x8, x9, calculate_mean
    flw f1, 0(x2)
    fadd.s f2, f2, f1
    
    #i++
    addi x8, x8, 1
    addi x2, x2, 4
    
    
    j loop_step_1
    
calculate_mean:
    la x10, four
    flw f6, 0(x10)
    fdiv.s f4, f2, f6 # (u = sum(v)/N)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
#--------------------------------End of Calculation of the mean and the result is in f4 ------------------------------------------------#

variance:
    la x2, V
    li x8, 0 # counter i
    fmv.w.x f5, x0 # also 
loop_step_2:
    beq x8,x9, calculate_variance
    flw f1, 0(x2)
    fsub.s f2, f1, f4
    fmul.s f2, f2, f2 
    fadd.s f5, f5, f2
    
    addi x8, x8, 1
    addi x2, x2, 4
    j loop_step_2
    
calculate_variance:
   fdiv.s f5, f5, f6
   nop
   nop
   nop
   nop
   nop     
#--------------------------------End of Calculation of the varient and the result is in f5 ----------------------------------------------#

normalisation:
    flw f2, 0(x3) # gamma
    flw f3, 0(x4) #beta
    flw f7, 0(x5) # eps
    
    #calculating the denominator
    fadd.s f7, f7, f5 # var + eps
    fsqrt.s f7 , f7 # sqrt(var + eps)
    fsw f7, 0(x7) # f7 = sqrt(var + eps)
    
    li x8, 0 # counter i
    la x2, V
    
    
loop_step_3:
    beq x8,x9, End
    flw f1, 0(x2)
    
    fsub.s f10, f1, f4 # numerator
    fdiv.s f10, f10,f7
    nop
    nop
    nop
    nop
    nop
    nop
    nop 
    fmul.s f10, f2, f10
    fadd.s f10, f10, f3
    fsw f10, 0(x6)
    
    addi x6, x6, 4
    addi x8, x8, 1
    addi x2, x2, 4
    fmv.w.x f10, x0 # reput f10 to 0
    j loop_step_3
    
# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
