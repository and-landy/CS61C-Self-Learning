.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue

    addi t0, x0, 0 # t0 = counter
    addi t3, x0, 0 # t3 = sum

    # Error check: if length < 1, exit with code 75
    addi t5, x0, 1
    blt a2, t5, error1   # if a1 >= 1, proceed normally
    blt a3, t5, error2
    blt a4, t5, error2
    j loop_start

error1:
    addi a1, x0, 75
    addi a0, x0, 17          # ecall 17 = exit2
    ecall

error2:
    addi a1, x0, 76
    addi a0, x0, 17          # ecall 17 = exit2
    ecall


loop_start:
    bge t0, a2, loop_end # Quit loop in the end of array

    mul t1, t0, a3
    slli t1, t1, 2
    add t1, t1, a0
    lw t1 0(t1) # Value of current elment in array v0

    mul t2, t0, a4
    slli t2, t2, 2
    add t2, t2, a1
    lw t2, 0(t2) # Value of current elment in array v1

    mul t4, t1, t2
    add t3, t3, t4 # add product to sum

    addi t0, t0, 1
    j loop_start

loop_end:
    add a0, x0, t3

    # Epilogue

    
    ret
