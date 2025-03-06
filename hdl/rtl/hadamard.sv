`timescale 1ns/1ps
`include "../include/include.vh"

module hadamard (
  input  logic signed [`FIXED_WIDTH-1:0] in_real,
  input  logic signed [`FIXED_WIDTH-1:0] in_imag,
  output logic signed [`FIXED_WIDTH-1:0] out_real,
  output logic signed [`FIXED_WIDTH-1:0] out_imag
);

  // Intermediate signals
  logic signed [`FIXED_WIDTH-1:0] plus_real;
  logic signed [`FIXED_WIDTH-1:0] minus_real;
  
  // Initialize the scaling constant (exact value depends on fixed-point format)
  /* verilator lint_off REALCVT */
  localparam logic signed [`FIXED_WIDTH-1:0] INV_SQRT_2_const = `FIXED_POINT_CONST_0_7071;

  // Calculate the (|0⟩ + |1⟩) part: in_real + in_imag
  q_add add_real (
    .a(in_real),
    .b(in_imag),
    .result(plus_real)
  );
  
  // Calculate the (|0⟩ - |1⟩) part: in_real - in_imag
  // For subtraction, we negate the second input
  logic signed [`FIXED_WIDTH-1:0] neg_in_imag;
  assign neg_in_imag = -in_imag;  // Negate the imaginary part
  
  q_add sub_real (
    .a(in_real),
    .b(neg_in_imag),
    .result(minus_real)
  );
  
  // Scale the components by 1/√2
  logic signed [`FIXED_WIDTH-1:0] scaled_plus_real;
  logic signed [`FIXED_WIDTH-1:0] scaled_minus_real;
  
  q_mul scale_plus_real (
    .a(plus_real),
    .b(INV_SQRT_2_const),
    .result(scaled_plus_real)
  );
  
  q_mul scale_minus_real (
    .a(minus_real),
    .b(INV_SQRT_2_const),
    .result(scaled_minus_real)
  );
  
  // Assign the output
  assign out_real = scaled_plus_real;
  assign out_imag = scaled_minus_real;

endmodule
