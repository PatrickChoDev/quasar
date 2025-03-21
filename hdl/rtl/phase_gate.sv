`timescale 1ns / 1ps
`include "../include/include.vh"

module phase_gate (
    input  logic signed [`FIXED_WIDTH-1:0] in_real,
    input  logic signed [`FIXED_WIDTH-1:0] in_imag,
    output logic signed [`FIXED_WIDTH-1:0] out_real,
    output logic signed [`FIXED_WIDTH-1:0] out_imag
);
    // Phase gate (S gate) applies 90-degree phase shift to |1⟩
    // Matrix: [1 0; 0 i]
    // For input state a|0⟩ + b|1⟩, the output is a|0⟩ + (bi)|1⟩
    // Since i represents 90-degree rotation, b becomes -b + 0i (real part)
    // and b*i becomes 0 + bi (imaginary part)

    always_comb begin
        out_real = in_real;
        out_imag = in_imag;
    end
endmodule
