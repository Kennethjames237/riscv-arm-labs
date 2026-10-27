# Add an optional .data section here.
# program_1: one step of a (simplified) AdaGrad optimizer
.section .data
# ---------- AdaGrad update of N = 8 weights ----------
N:      .word 8
lr:     .float 0.1                       # learning rate
g:      .float 0.5, -1.0, 0.25, 2.0, -0.5, 1.5, -0.25, 1.0    # gradients
h:      .float 1.0, 2.0, 0.5, 1.0, 4.0, 1.0, 0.25, 2.0        # accumulated g^2
w:      .float 0.3, -0.7, 1.2, 0.05, -0.4, 0.9, -1.1, 0.6     # weights
# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

        la   t0, g                      # t0 -> g[i]
        la   t1, h                      # t1 -> h[i]
        la   t2, w                      # t2 -> w[i]
        la   t3, lr
        flw  f0, 0(t3)                  # f0 = lr
        la   t4, N
        lw   t5, 0(t4)                  # t5 = N (loop counter)
        #-----------#
loop:   flw  f1, 0(t0)                  # f1 = g[i]
        flw  f2, 0(t1)                  # f2 = h[i]
        fmul.s f3, f1, f1               # f3 = g[i]^2
        fadd.s f2, f2, f3               # h[i] = h[i] + g[i]^2
        fsw  f2, 0(t1)
        
        #-----------------------#
        fmul.s f3, f0, f1               # f3 = lr * g[i]
        fdiv.s f3, f3, f2               # f3 = lr * g[i] / h[i].  
        flw  f4, 0(t2)                  # f4 = w[i]
        fsub.s f4, f4, f3               # w[i] = w[i] - lr * g[i] / h[i]
        fsw  f4, 0(t2)
        
        #---increments-----#
        addi t0, t0, 4
        addi t1, t1, 4
        addi t2, t2, 4
        addi t5, t5, -1                 # one iteration less
        bne  t5, zero, loop

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
