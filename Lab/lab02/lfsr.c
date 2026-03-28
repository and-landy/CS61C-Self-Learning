#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    unsigned a0 = 1 & *reg;
    unsigned a2 = 1 & (*reg >> 2);
    unsigned a3 = 1 & (*reg >> 3);
    unsigned a5 = 1 & (*reg >> 5);

    unsigned r = a0 ^ a2;
    r = r ^ a3;
    r = r ^ a5;

    *reg = *reg >> 1;

    unsigned shift = 1 << 15;
    if(r == 0){
        shift = ~shift;
        *reg = *reg & shift;
    }
    else{
        *reg = *reg | shift;
    }
}

