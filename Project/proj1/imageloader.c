/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				Yueyang Zhong
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename)
{
	FILE *fp = fopen(filename, "r");

	// Read the PPM header: format (P3), width, height, and max color value
	char format[3];
	int width, height, maxval;
	fscanf(fp, "%s", format);
	fscanf(fp, "%d %d", &width, &height);
	fscanf(fp, "%d", &maxval);

	// Allocate the Image struct and set dimensions
	Image *img = malloc(sizeof(Image));
	img -> rows = height;
	img -> cols = width;

	// Allocate a 2D array of Color pixels (array of row pointers, each pointing to an array of Colors)
	img->image = malloc(height * sizeof(Color *));
	for(int i = 0; i < height; i++){
		img->image[i] = malloc(width * sizeof(Color));
	}

	// Read each pixel's RGB values from the file into the 2D array
	for(int i = 0; i < height; i++){
		for(int j = 0; j < width; j++){
			int r, g, b;
			fscanf(fp, "%d %d %d", &r, &g, &b);
			img->image[i][j].R = r;
			img->image[i][j].G = g;
			img->image[i][j].B = b;
		}
	}

	fclose(fp);
	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	printf("P3\n");
	printf("%d %d\n", image->cols, image->rows);
	printf("255\n");

	for(int i = 0; i < image->rows; i++){
		for(int j = 0; j < image->cols; j++){
			printf("%3d ", image->image[i][j].R);
			printf("%3d ", image->image[i][j].G);
			printf("%3d", image->image[i][j].B);
			if(j != image->cols - 1){
				printf("   ");
			}
		}
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image)
{
	for(int i = 0; i < image->rows; i++){
		free(image->image[i]);
	}

	free(image->image);

	free(image);
}