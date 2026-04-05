.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)

    # fopen
    lw a1, 4(sp)
    li a2, 1 # Write mode
    jal fopen
    addi t0, x0, -1
    beq a0, t0, exit2
    sw a0, 20(sp)

    # fwrite - rows
    lw a1, 20(sp)
    addi a2, sp, 12
    addi a3, x0, 1
    addi a4, x0, 4
    jal fwrite
    li t0, 1
    bne a0, t0, exit1

    # fwrite - cols
    lw a1, 20(sp)
    addi a2, sp, 16
    addi a3, x0, 1
    addi a4, x0, 4
    jal fwrite
    li t0, 1
    bne a0, t0, exit1

    # fwrite - matrix
    lw a1, 20(sp)
    lw a2, 8(sp)
    lw t0, 12(sp)
    lw t1, 16(sp)
    mul t0, t0, t1
    mv a3, t0
    addi a4, x0, 4
    jal fwrite
    lw t0, 12(sp)
    lw t1, 16(sp)
    mul t0, t0, t1
    bne a0, t0, exit1

    # fclose
    lw a1, 20(sp)
    jal fclose
    addi t0, x0, -1
    beq a0, t0, exit3

    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 24

    ret

exit1:
    addi a1, x0, 94
    addi a0, x0, 17          # ecall 17 = exit2
    ecall

exit2:
    addi a1, x0, 93
    addi a0, x0, 17          # ecall 17 = exit2
    ecall

exit3:
    addi a1, x0, 95
    addi a0, x0, 17          # ecall 17 = exit2
    ecall