# Add an optional .data section here.
.section .data
N:      .word 100

# Constants
three:  .word 3
zero_i: .word 0

v1: .float 1.0, 2.0, 3.0, 4.0, 5.0
    .float 6.0, 7.0, 8.0, 9.0, 10.0
    .float 11.0, 12.0, 13.0, 14.0, 15.0
    .float 16.0, 17.0, 18.0, 19.0, 20.0
    .float 21.0, 22.0, 23.0, 24.0, 25.0
    .float 26.0, 27.0, 28.0, 29.0, 30.0
    .float 31.0, 32.0, 33.0, 34.0, 35.0
    .float 36.0, 37.0, 38.0, 39.0, 40.0
    .float 41.0, 42.0, 43.0, 44.0, 45.0
    .float 46.0, 47.0, 48.0, 49.0, 50.0
    .float 51.0, 52.0, 53.0, 54.0, 55.0
    .float 56.0, 57.0, 58.0, 59.0, 60.0
    .float 61.0, 62.0, 63.0, 64.0, 65.0
    .float 66.0, 67.0, 68.0, 69.0, 70.0
    .float 71.0, 72.0, 73.0, 74.0, 75.0
    .float 76.0, 77.0, 78.0, 79.0, 80.0
    .float 81.0, 82.0, 83.0, 84.0, 85.0
    .float 86.0, 87.0, 88.0, 89.0, 90.0
    .float 91.0, 92.0, 93.0, 94.0, 95.0
    .float 96.0, 97.0, 98.0, 99.0, 100.0

v2: .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0
    .float 2.0, 2.0, 2.0, 2.0, 2.0


v3: .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0
    .float 1.0, 1.0, 1.0, 1.0, 1.0

# Output vectors
v4: .space 400
v5: .space 400
# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:
# Load base addresses into registers
    la t0, v1          # Address of v1
    la t1, v2          # Address of v2
    la t2, v3          # Address of v3
    la t3, v4          # Address of v4
    la t4, v5          # Address of v5

    li x1, 0           # Loop index i = 0
    lw x2, N           # Loop limit = 100
    li x3, 3           # Constant 3 for i / 3 logic

loop:
    # 1. Compute v4[i] = (v1[i] / v2[i]) + v3[i]
    flw f1, 0(t0)      # Load v1[i]
    flw f2, 0(t1)      # Load v2[i]
    flw f3, 0(t2)      # Load v3[i]

    fdiv.s f4, f1, f2  # f4 = v1[i] / v2[i]
    fadd.s f4, f4, f3  # f4 = v4[i]
    fsw f4, 0(t3)      # Store to v4[i]

    # 2. Compute branch index: temp = int(i / 3)
    div x3, x1, x2     # x3 = i / 3

    # 3. Branch conditions for v5[i]
    beqz x3, case_0    # If (i / 3) == 0 -> case_0
    li t5, 1
   
    beq x3, t5, case_1 # If (i / 3) == 1 -> case_1

case_2:                # Else -> v5[i] = v4[i] + v3[i]
    fadd.s f5, f4, f3
    j store_v5

case_0:                # v5[i] = v4[i] * v3[i]
    fmul.s f5, f4, f3
    j store_v5

case_1:                # v5[i] = v4[i] / v3[i]
    fdiv.s f5, f4, f3

store_v5:
    fsw f5, 0(t4)      # Store to v5[i]

    # Update pointers and index i
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, 4
    addi t3, t3, 4
    addi t4, t4, 4
    addi x1, x1, 1     # i++
    bne x1, x2, loop    # Exit loop if i == 100
    

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
