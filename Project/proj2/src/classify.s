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

    addi sp, sp, -48
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

	# =====================================
    # LOAD MATRICES
    # =====================================






    # Load pretrained m0
    li a0, 8 # Malloc space for m0
    jal malloc
    mv t0, a0

    lw t0, 4(sp)
    lw a0, 4(t0) # argv[1]
    mv a1, t0 # rows
    addi a2, t0, 4 # columns
    jal read_matrix
    lw s0, 0(t0)
    lw s1, 4(t0)
    mv s2, a0


    # Load pretrained m1
    li a0, 8 # Malloc space for m1
    jal malloc
    mv t0, a0

    lw t0, 4(sp)
    lw a0, 8(t0) # argv[2]
    mv a1, t0 # rows
    addi a2, t0, 4 # columns
    jal read_matrix
    lw s3, 0(t0)
    lw s4, 4(t0)
    mv s5, a0


    # Load input matrix
    li a0, 8 # Malloc space for input
    jal malloc
    mv t0, a0

    lw t0, 4(sp)
    lw a0, 12(t0) # argv[3]
    mv a1, t0 # rows
    addi a2, t0, 4 # columns
    jal read_matrix
    lw s6, 0(t0)
    lw s7, 4(t0)
    mv s8, a0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    











    


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax




    # Print classification
    



    # Print newline afterwards for clarity




    ret

exit89:
    addi a1, x0, 89
    addi a0, x0, 17
    ecall