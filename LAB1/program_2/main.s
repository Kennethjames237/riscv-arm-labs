# Add an optional .data section here.
.section .data
v1: .byte 2, 6, -3, 11, 9, 18, -13, 16, 5, 1
v2: .byte 4, 2, -13, 3, 9, 9, 7, 16, 4, 7
v3: .space 10
flag1: .byte 0
flag2: .byte 0
flag3: .byte 0 
# The text section contains the instructions that the CPU runs.
.section .text
# Make _start visible as the point where the program begins.
.globl _start
_start:
Main:
    #loading address and put pointer register to the first element
    la x1, v1
    lb x2, 0(x1) # use x1 --> v1 (displace)
    
    la x3, v2
    lb x4, 0(x3) # use x3 --> v2 (displace)
    
    la x5, v3 # x5 has the address of v3 . x5 --> v3
    
    jal x9, Compare_and_add_in_v3 # using register x9. as the return address ra = x9
    
    j End
    
         
      

Compare_and_add_in_v3:
    addi x6, x0, 0 # i increment for v1 to do v1[i] 
    addi x8, x0, 0 # j increment for v2 ro do v2[j]
    addi x10, x0, 0 # k increment for v2 ro do v3[k]
    addi x7, x0, 9 # size of v1 and v2
    addi x11, x0, 10 # helper to put the upper limit so if it exits 10 it finishes => in v1 if we are on v[10] that does not exist=> FINISH
     outerloop:
     beq x6, x11, Finish # if i == 10 bcs [0.....9] (size) v1 is finish. To know if we are on the last element in v1
     
     add x12, x1, x6 # compute the displacement in v1
     lb x2, 0(x12) # laod byte to register x2
     
     add x13, x3, x8 # compute the displacement in v2
     lb x4, 0(x13) # laod byte to register x4
     
     beq x2, x4, put_in_v3 #IF v1[i] == v2[j] --> v3[k] = v1[i]
     #ELSE
     beq x8,x7, set_v2_and_v1 #check if we are on the last element on v2
     addi x8, x8, 1 # j++ (i just increament v2 and continue the seach in the outerloop)
     j outerloop # after increamenting go and start checking another value maintaining v1 ---> v2[0.....9]
     
set_v2_and_v1:
    addi x8, x0, 0 # reset the displacement to the first element in v2
    addi x6, x6, 1 # i++
    j outerloop # after increamenting go and start checking another value in v1 ---> v2[0.....9]
      
put_in_v3:
    add x14, x5, x10
    sb x2, 0(x14) # in memory v3[k] = x2 --> where x2 = v[i]
    addi x10, x10, 1 # k++
    addi x8, x0, 0 # so i found an occurance in v2 i start back the pointer to the 1 element to restart a new check for the next v1 elem
    addi x6, x6, 1 # i++ move to the next elem in v1
    j outerloop
    
    
Finish:
      #checking flages
      #load the address of the 3 flages 
      la x12, flag1
      la x13, flag2
      la x14, flag3
      
      seqz x15, x10 # check if the counter is equal to 0 then if yes set the value in reg x15
      sb x15, 0(x12) # store the value of flag1 in memeory
      
      bne x10, x0, check_flag2
      j Exit # this is because if v3 is empty no need proceeding to flags just terminate
      
check_flag2:
     addi x16, x0, 0 #index i of v3 -> v3[i]
     addi x17, x0, 1 # index i+1 of v3 -> v3[i+1]
loop_in_v3:
        
        
        add x19, x16, x5
        lb x6, 0(x19)
        
        add x20, x17, x5
        lb x18, 0(x20)
        
        beq x17,x10,conclude_ascending
        bge x6,x18, check_flag3 # if the values are in decending order check flag 3
        
        
        #if we are not on the last element in v3 lets increament the 2 positiona
        addi x16, x16, 1 
        addi x17, x17, 1
        
        j loop_in_v3
        
conclude_ascending:
    li x15, 1
    sb x15, 0(x13) #store the value of flag2
    j Exit
 
      check_flag3:
    li x15, 0 
    sb x15, 0(x13) #store the value of flag2 = 0 because it is not in asending order
    
     #reset registers to iterate in v3
     addi x16, x0, 0 #index i of v3 -> v3[i]
     addi x17, x0, 1 # index i+1 of v3 -> v3[i+1]
     
     #load values
     add x19, x16, x5
     lb x6, 0(x19)
      
     #load values  
     add x20, x17, x5
     lb x18, 0(x20)
     
     beq x17,x10,conclude_desending
     
     bge x18, x6, non_of_the_cases # here if v[i+1] is greater than v[i] No case match
       
        
        #if we are not on the last element in v3 lets increament the 2 positiona
        addi x16, x16, 1 
        addi x17, x17, 1
        
        j loop_in_v3 
conclude_desending:
    bge x6, x18, finally
finally:
    li x15, 1
    sb x15, 0(x14) #store the value of flag2
    j Exit
                            
non_of_the_cases:
    li x15, 0
    sb x15, 0(x14) #store the value of flag2
    j Exit            
Exit:            
      jr x9
      
# The End block stops the program and returns control to the simulator.
End:
    li a0, 0
    li a7, 93
    ecall
