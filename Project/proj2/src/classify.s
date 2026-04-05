.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, exit89

    addi sp, sp, -56
    sw ra, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw s2, 20(sp)
    sw s3, 24(sp)
    sw s4, 28(sp)
    sw s5, 32(sp)
    sw s6, 36(sp)
    sw s7, 40(sp)
    sw s8, 44(sp)
    sw s9, 48(sp)
    sw s10, 52(sp)

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    li a0, 8 # Malloc space for m0
    jal malloc
    mv s2, a0

    beq a0, x0, exit88

    lw t0, 4(sp)
    lw a0, 4(t0) # argv[1]
    mv a1, s2 # rows
    addi a2, s2, 4 # columns
    jal read_matrix
    lw s0, 0(s2)
    lw s1, 4(s2)
    mv s2, a0


    # Load pretrained m1
    li a0, 8 # Malloc space for m1
    jal malloc
    mv s5, a0

    beq a0, x0, exit88

    lw t0, 4(sp)
    lw a0, 8(t0) # argv[2]
    mv a1, s5 # rows
    addi a2, s5, 4 # columns
    jal read_matrix
    lw s3, 0(s5)
    lw s4, 4(s5)
    mv s5, a0


    # Load input matrix
    li a0, 8 # Malloc space for input
    jal malloc
    mv s8, a0

    beq a0, x0, exit88

    lw t0, 4(sp)
    lw a0, 12(t0) # argv[3]
    mv a1, s8 # rows
    addi a2, s8, 4 # columns
    jal read_matrix
    lw s6, 0(s8)
    lw s7, 4(s8)
    mv s8, a0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    mul t0, s0, s7
    slli a0, t0, 2
    jal malloc
    mv s9, a0

    beq a0, x0, exit88

    mv a0, s2
    mv a1, s0
    mv a2, s1
    mv a3, s8
    mv a4, s6
    mv a5, s7
    mv a6, s9

    jal matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)

    mv a0, s9
    mul t0, s0, s7
    mv a1, t0

    jal relu

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    mul t0, s3, s7
    slli a0, t0, 2
    jal malloc
    mv s10, a0

    beq a0, x0, exit88

    mv a0, s5
    mv a1, s3
    mv a2, s4
    mv a3, s9
    mv a4, s0
    mv a5, s7
    mv a6, s10

    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw t0, 4(sp)
    lw a0, 16(t0)
    mv a1, s10
    mv a2, s3
    mv a3, s7

    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s10
    mul a1, s3, s7

    jal argmax

    mv s9, a0

    # Print classification

    lw t0, 8(sp)
    bne t0, x0, skip_print
    
    mv a1, s9
    jal print_int

    # Print newline afterwards for clarity

    li a1, '\n'
    jal print_char

skip_print:
    mv a0, s9

    # Epilogue
    
    lw ra, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw s0, 12(sp)
    lw s1, 16(sp)
    lw s2, 20(sp)
    lw s3, 24(sp)
    lw s4, 28(sp)
    lw s5, 32(sp)
    lw s6, 36(sp)
    lw s7, 40(sp)
    lw s8, 44(sp)
    lw s9, 48(sp)
    lw s10, 52(sp)
    addi sp, sp, 56

    ret

exit89:
    addi a1, x0, 89
    addi a0, x0, 17
    ecall

exit88:
    addi a1, x0, 88
    addi a0, x0, 17
    ecall