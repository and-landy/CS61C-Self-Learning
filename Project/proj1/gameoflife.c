/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				Yueyang Zhong
**
**
** DATE:        2026-3-13
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	Color *c = malloc(sizeof(Color));

	int isAlive, neighbors, bitIndex, nextState;

	//Red
	isAlive = (image->image[row][col].R == 255) ? 1 : 0;

	neighbors = 0;
	for(int i = -1; i <= 1; i++){
		for(int j = -1; j <= 1; j++){
			if(i == 0 && j == 0) continue;
			int h = (row + i + image->rows) % image->rows;
			int w = (col + j + image->cols) % image->cols;
			if(image->image[h][w].R == 255){
				neighbors++;
			}
		}
	}

	bitIndex = 9 * isAlive + neighbors;
	nextState = (rule >> bitIndex) & 1;
	c->R = nextState ? 255 : 0;

	//Green
	isAlive = (image->image[row][col].G == 255) ? 1 : 0;

	neighbors = 0;
	for(int i = -1; i <= 1; i++){
		for(int j = -1; j <= 1; j++){
			if(i == 0 && j == 0) continue;
			int h = (row + i + image->rows) % image->rows;
			int w = (col + j + image->cols) % image->cols;
			if(image->image[h][w].G == 255){
				neighbors++;
			}
		}
	}

	bitIndex = 9 * isAlive + neighbors;
	nextState = (rule >> bitIndex) & 1;
	c->G = nextState ? 255 : 0;

	//Blue
	isAlive = (image->image[row][col].B == 255) ? 1 : 0;

	neighbors = 0;
	for(int i = -1; i <= 1; i++){
		for(int j = -1; j <= 1; j++){
			if(i == 0 && j == 0) continue;
			int h = (row + i + image->rows) % image->rows;
			int w = (col + j + image->cols) % image->cols;
			if(image->image[h][w].B == 255){
				neighbors++;
			}
		}
	}

	bitIndex = 9 * isAlive + neighbors;
	nextState = (rule >> bitIndex) & 1;
	c->B = nextState ? 255 : 0;

	return c;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//Allocate image struc and copy the dimension of input image
	Image *n = malloc(sizeof(Image));
	n->rows = image->rows;
	n->cols = image->cols;

	n->image = malloc(image->rows * sizeof(Color *));
	for(int i = 0; i < image->rows; i++){
		n->image[i] = malloc(image->cols * sizeof(Color));
	}

	//Determine the color of each cell one by one
	for(int i = 0; i < image->rows; i++){
		for(int j = 0; j < image->cols; j++){
			Color *c = evaluateOneCell(image, i, j, rule);
			n->image[i][j] = *c;
			free(c);
		}
	}

	return n;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	if(argc != 3){
		printf("usage: ./gameOfLife filename rule\n");
        printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
        printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");

		return 0;
	}

	uint32_t rule = (uint32_t)strtoul(argv[2], NULL, 16);

	Image *img = readData(argv[1]);
	Image *newimg = life(img, rule);
	writeData(newimg);
	freeImage(img);
	freeImage(newimg);

	return 0;
}
