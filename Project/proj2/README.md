# Project 2: RISC-V Neural Network Classifier

CS61C Fall 2020 - Project 2

## Overview

Implement a simple neural network (two-layer, fully connected) in RISC-V assembly to classify handwritten digits (MNIST). The network performs matrix operations, applies activation functions, and outputs a predicted digit.

## Structure

```
src/
  argmax.s       - Find index of max element (Part A)
  dot.s          - Dot product of two vectors (Part A)
  relu.s         - ReLU activation function (Part A)
  matmul.s       - Matrix multiplication (Part A)
  read_matrix.s  - Read matrix from binary file (Part B)
  write_matrix.s - Write matrix to binary file (Part B)
  classify.s     - Full classification pipeline (Part B)
  main.s         - Entry point (do not modify)
  utils.s        - Helper functions (do not modify)
unittests/
  unittests.py   - Unit tests for all functions
```

## What I implemented

- **Part A**: `argmax`, `dot`, `relu`, `matmul` - core math operations in RISC-V
- **Part B**: `read_matrix`, `write_matrix` - file I/O using ecalls; `classify` - end-to-end inference pipeline (WIP)
