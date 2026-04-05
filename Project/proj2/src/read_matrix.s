.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -36
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw s0, 32(sp)

    #fopen
    lw a1, 4(sp)
    li a2, 0
    jal fopen
    addi t0, x0, -1
    beq a0, t0, exit1
    sw a0, 20(sp)

    #read row value
    lw a1, 20(sp)
    addi a2, sp, 24
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, exit3
    lw t0, 24(sp)
    lw t1, 8(sp)
    sw t0, 0(t1)

    #read col value
    lw a1, 20(sp)
    addi a2, sp, 28
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, exit3
    lw t0, 28(sp)
    lw t1, 12(sp)
    sw t0, 0(t1)

    #malloc
    lw t0, 24(sp)
    lw t1, 28(sp)
    mul t0, t0, t1
    slli a0, t0, 2
    mv s0, a0
    jal malloc
    addi t0, x0, 0
    beq a0, t0, exit2
    sw a0, 16(sp) #the pointer to the allocated heap memory

    #read matrix
    lw a1, 20(sp)
    lw a2, 16(sp)
    mv a3, s0
    jal fread
    bne a0, s0, exit3

    #fclose
    lw a1, 20(sp)
    jal fclose
    li t0, 0
    bne a0, t0, exit4

    # Epilogue
    lw s0, 32(sp)
    lw a0, 16(sp)
    lw ra, 0(sp)
    addi sp, sp, 36

    ret


exit1:
    addi a1, x0, 90
    addi a0, x0, 17          # ecall 17 = exit2
    ecall

exit2:
    addi a1, x0, 88
    addi a0, x0, 17          # ecall 17 = exit2
    ecall

exit3:
    addi a1, x0, 91
    addi a0, x0, 17          # ecall 17 = exit2
    ecall

exit4:
    addi a1, x0, 92
    addi a0, x0, 17          # ecall 17 = exit2
    ecall