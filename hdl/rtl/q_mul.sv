`timescale 1ns/1ps
`include "../include/include.vh"

module q_mul (
  input  logic signed [`FIXED_WIDTH-1:0] a,
  input  logic signed [`FIXED_WIDTH-1:0] b,
  output logic signed [`FIXED_WIDTH-1:0] result
);
  
  // Use extended width for intermediate calculation
  logic signed [(2*`FIXED_WIDTH)-1:0] tmp;
  logic signed [(2*`FIXED_WIDTH)-1:0] tmp_adj;
  logic signed [`FIXED_WIDTH-1:0] result_raw;
  
  always_comb begin
    // Sign-extend a and b to 2*`FIXED_WIDTH bits and compute the product
    tmp = {{`FIXED_WIDTH{a[`FIXED_WIDTH-1]}}, a} * {{`FIXED_WIDTH{b[`FIXED_WIDTH-1]}}, b};
    // Add rounding value for fixed-point multiplication
    tmp_adj = tmp + `ROUNDING_VALUE;
    tmp_adj = (tmp_adj >>> `FRAC_BITS);
    // Arithmetic right shift to obtain the scaled result
    result_raw = tmp_adj[`FIXED_WIDTH-1:0];
    // Saturate the result to prevent overflow
    if (result_raw > `FIXED_MAX)
      result = `FIXED_MAX;
    else if (result_raw < `FIXED_MIN)
      result = `FIXED_MIN;
    else
      result = result_raw;
  end
endmodule
