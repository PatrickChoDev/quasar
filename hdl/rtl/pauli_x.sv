`timescale 1ns / 1ps
`include "../include/include.vh"

module pauli_x (
    input  logic signed [`FIXED_WIDTH-1:0] in_real,
    input  logic signed [`FIXED_WIDTH-1:0] in_imag,
    output logic signed [`FIXED_WIDTH-1:0] out_real,
    output logic signed [`FIXED_WIDTH-1:0] out_imag
);
    // Pauli-X gate (NOT gate) flips |0⟩ to |1⟩ and |1⟩ to |0⟩
    // Matrix: [0 1; 1 0]

    always_comb begin
        // Flip the basis states
        out_real = in_imag;  // |1⟩ component becomes |0⟩ component
        out_imag = in_real;  // |0⟩ component becomes |1⟩ component
    end
endmodule
