.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    ble a1, x0, exit72
    ble a2, x0, exit72
    ble a4, x0, exit73
    ble a5, x0, exit73
    bne a2, a4, exit74

    # Prologue - save ra and s0-s8
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    # Save arguments to s registers (preserved across dot calls)
    mv s0, a0    # m0 pointer
    mv s1, a1    # m0_rows
    mv s2, a2    # m0_cols
    mv s3, a3    # m1 pointer
    mv s4, a4    # m1_rows
    mv s5, a5    # m1_cols
    mv s6, a6    # d pointer

    li s7, 0     # i = 0 (row index for m0)
outer_loop_start:
    bge s7, s1, outer_loop_end

    li s8, 0     # j = 0 (col index for m1)
inner_loop_start:
    bge s8, s5, inner_loop_end

    # a0 = m0 + i * m0_cols * 4 (start of row i in m0)
    mul t0, s7, s2
    slli t0, t0, 2
    add a0, s0, t0

    # a1 = m1 + j * 4 (start of col j in m1)
    slli t1, s8, 2
    add a1, s3, t1

    # a2 = m0_cols (dot product length)
    mv a2, s2

    # a3 = 1 (stride for m0 row: consecutive elements)
    li a3, 1

    # a4 = m1_cols (stride for m1 col: skip one full row)
    mv a4, s5

    # Call dot product
    jal ra, dot

    # Store result into d[i * m1_cols + j]
    mul t0, s7, s5
    add t0, t0, s8
    slli t0, t0, 2
    add t0, s6, t0
    sw a0, 0(t0)

    addi s8, s8, 1
    j inner_loop_start
inner_loop_end:
    addi s7, s7, 1
    j outer_loop_start
outer_loop_end:

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40

    ret

exit72:
    addi a1, x0, 72
    addi a0, x0, 17
    ecall

exit73:
    addi a1, x0, 73
    addi a0, x0, 17
    ecall

exit74:
    addi a1, x0, 74
    addi a0, x0, 17
    ecall