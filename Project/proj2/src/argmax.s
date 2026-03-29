.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue

    add t0, x0, a1 
    addi t0, t0, -1 # t0 = Counter, Staring from the last number

    addi t1, x0, 0 # t1 = Current biggest biggest number

    add t3, x0, t0 # t3 = the index of current biggest number

    # Error check: if length < 1, exit with code 77
    addi t5, x0, 1
    bge a1, t5, loop_start   # if a1 >= 1, proceed normally
    addi a1, x0, 77
    addi a0, x0, 17          # ecall 17 = exit2
    ecall

loop_start:
    blt t0, x0, loop_end

    slli t2, t0, 2
    add t2, t2, a0
    lw t2, 0(t2) # Get the number of current element in array
    
    bge t2, t1, loop_continue

    addi t0, t0, -1
    j loop_start

loop_continue:
    add t1, x0, t2
    add t3, x0, t0

    addi t0, t0, -1
    j loop_start

loop_end:
    add a0, x0, t3

    # Epilogue


    ret
