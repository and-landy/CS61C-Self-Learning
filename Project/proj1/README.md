# Project 1: Game of Life

CS61C Fall 2020 - Project 1

## Overview

This project implements Conway's Game of Life and a steganography decoder in C, working with PPM image files.

## Files

- `imageloader.c` - PPM image loading and manipulation
- `gameoflife.c` - Game of Life simulation with configurable rules
- `steganography.c` - Decode hidden messages from images using LSB steganography
- `frames.csh` - Script to generate animation frames

## What I implemented

- **Image Loader**: Read/write PPM images, create and free Image structs
- **Game of Life**: Evaluate cells using bitwise rule encoding, supporting arbitrary totalistic rules with wrap-around grid
- **Steganography**: Extract hidden images by reading the LSB of each color channel
