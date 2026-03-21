/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				Yueyang Zhong
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//Allocate space for new collor
	Color *c = malloc(sizeof(Color));

	//Read each RGB's color from 2D array to collor
	c->R = image->image[row][col].R;
	c->G = image->image[row][col].G;
	c->B = image->image[row][col].B;

	return c;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//Allocate image struc and copy the dimension of input image
	Image *n = malloc(sizeof(Image));
	n->rows = image->rows;
	n->cols = image->cols;

	n->image = malloc(image->rows * sizeof(Color *));
	for(int i = 0; i < image->rows; i++){
		n->image[i] = malloc(image->cols * sizeof(Color));
	}

	//Determine the last bit of B and assign correct value for RGB
	for(int i = 0; i < image->rows; i++){
		for(int j = 0; j < image->cols; j++){
			int lastBit = image->image[i][j].B & 1;
			if(lastBit == 0){
				n->image[i][j].R = 0;
				n->image[i][j].G = 0;
				n->image[i][j].B = 0;
			}
			else{
				n->image[i][j].R = 255;
				n->image[i][j].G = 255;
				n->image[i][j].B = 255;
			}
		}
	}

	return n;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	if(argc != 2){
		return -1;
	}

	int len = strlen(argv[1]);
	if(!(argv[1][len - 4] == '.' && argv[1][len - 3] == 'p' && argv[1][len - 2] == 'p' && argv[1][len - 1] == 'm')){
		return -1;
	}

	Image *img = readData(argv[1]);
	Image *newimg = steganography(img);
	writeData(newimg);
	freeImage(img);
	freeImage(newimg);

	return 0;
}
