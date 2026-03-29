.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue

    addi t3, x0, 0 # counter

    # Error check: if length < 1, exit with code 78
    addi t0, x0, 1
    bge a1, t0, loop_start   # if a1 >= 1, proceed normally
    addi a1, x0, 78
    addi a0, x0, 17          # ecall 17 = exit2
    ecall

loop_start:
    bge t3, a1, loop_end # end array when counter reach last element

    slli t0, t3, 2
    add t1, t0, a0 # t1 = address of current array
    lw t0, 0(t1)

    blt t0, x0, loop_continue # Branch less than 0 

    addi t3, t3, 1
    j loop_start

loop_continue:
    sw x0, 0(t1)
    addi t3, t3, 1
    j loop_start

loop_end:


    # Epilogue

    
	ret
