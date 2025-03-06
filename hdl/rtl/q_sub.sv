`timescale 1ns/1ps
`include "../include/include.vh"

module q_sub(
  input  logic signed [`FIXED_WIDTH-1:0] a,
  input  logic signed [`FIXED_WIDTH-1:0] b,
  output logic signed [`FIXED_WIDTH-1:0] result
);

  // Use extended width for intermediate calculation
  logic signed [(2*`FIXED_WIDTH)-1:0] tmp;
  
  always_comb begin
    // Sign-extend a and b to 2*`FIXED_WIDTH bits and compute the difference
    tmp = {{`FIXED_WIDTH{a[`FIXED_WIDTH-1]}}, a} - {{`FIXED_WIDTH{b[`FIXED_WIDTH-1]}}, b};

    if (tmp > `EXT_FIXED_MAX)
      result = `FIXED_MAX;
    else if (tmp < `EXT_FIXED_MIN)
      result = `FIXED_MIN;
    else
      result = tmp[`FIXED_WIDTH-1:0];
  end
endmodule
