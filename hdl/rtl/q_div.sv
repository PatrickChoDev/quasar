`timescale 1ns/1ps
`include "../include/include.vh"

module q_div (
    input signed [`FIXED_WIDTH-1:0] a,
    input signed [`FIXED_WIDTH-1:0] b,
    output signed [`FIXED_WIDTH-1:0] result
);
    wire signed [`FIXED_WIDTH*2-1:0] numerator;  // Extended bit-width for precision
    wire signed [`FIXED_WIDTH-1:0] quotient;
    
    // Scale numerator to maintain precision
    assign numerator = a <<< `FRAC_BITS;  // Multiply by 2^n to keep fraction bits

    // Perform division (handling divide by zero)
    assign quotient = (b == 0) ? ((a >= 0) ? {1'b0, {(`FIXED_WIDTH-1){1'b1}}} : {1'b1, {(`FIXED_WIDTH-1){1'b0}}}) : (numerator / b);
    
    // Apply Saturation
    if (quotient > `EXT_FIXED_MAX)
      result = `FIXED_MAX;
    else if (quotient < `EXT_FIXED_MIN)
      result = `FIXED_MIN;
    else
      result = quotient[`FIXED_WIDTH-1:0];
endmodule