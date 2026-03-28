#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    x = x << (31 - n);
    x = x >> 31;
    return x;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    unsigned shift = 1 << n;
    if(v == 0){
        shift = ~shift;
        *x = *x & shift;
    }
    else{
        *x = *x | shift;
    }
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    unsigned shift = 1 << n;
    *x = *x ^ shift;
}

