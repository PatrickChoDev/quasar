`timescale 1ns / 1ps
`include "../include/include.vh"

module pauli_y (
    input  logic signed [`FIXED_WIDTH-1:0] in_real,
    input  logic signed [`FIXED_WIDTH-1:0] in_imag,
    output logic signed [`FIXED_WIDTH-1:0] out_real,
    output logic signed [`FIXED_WIDTH-1:0] out_imag
);
    // Pauli-Y gate flips and introduces phase
    // Matrix: [0 -i; i 0]

    always_comb begin
        // Flip with phase change
        out_real = -in_imag;  // Flip |1⟩ to |0⟩ with negative phase
        out_imag = in_real;  // Flip |0⟩ to |1⟩ without phase change
    end
endmodule
