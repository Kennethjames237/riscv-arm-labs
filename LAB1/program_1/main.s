# Add an optional .data section here.
.section .data

T0: .word 0x0BADC0DE
# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:

Main:
    # Initialize Fibonacci variables
    li x1, 0        # x1 = a = first Fibonacci number (0)
    li x2, 1        # x2 = b = second Fibonacci number (1) 
    li x3, 21       # x3 = count = number of terms to generate
    li x4, 0        # x4 = i = loop counter
    
    # Loop to generate and print remaining 20 numbers
    addi x4, x4, 1  # i = 1 (start from second iteration)
    
    fib_loop:

    beq x4, x3, End # if i == count, exit loop
        
    # Calculate next Fibonacci number
    add x5, x1, x2  # x5 = next = a + b
    
    # Update variables for next iteration
    mv x1, x2       # a = b (previous second becomes first)
    mv x2, x5       # b = next (calculated next becomes second)
    # Increment counter and continue loop
    addi x4, x4, 1  # i++
    j fib_loop      # Jump back to loop start

# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
