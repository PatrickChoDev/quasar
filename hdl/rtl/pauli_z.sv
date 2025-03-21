`timescale 1ns / 1ps
`include "../include/include.vh"

module pauli_z (
    input  logic signed [`FIXED_WIDTH-1:0] in_real,
    input  logic signed [`FIXED_WIDTH-1:0] in_imag,
    output logic signed [`FIXED_WIDTH-1:0] out_real,
    output logic signed [`FIXED_WIDTH-1:0] out_imag
);
    // Pauli-Z gate applies phase flip to |1⟩
    // Matrix: [1 0; 0 -1]

    always_comb begin
        out_real = in_real;  // |0⟩ component unchanged
        out_imag = -in_imag;  // |1⟩ component flipped in phase
    end
endmodule
