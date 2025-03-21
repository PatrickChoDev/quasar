`timescale 1ns / 1ps
`include "../include/include.vh"

module q_cnot (
    // Control qubit
    input logic signed [`FIXED_WIDTH-1:0] control_real_0,
    input logic signed [`FIXED_WIDTH-1:0] control_imag_0,
    input logic signed [`FIXED_WIDTH-1:0] control_real_1,
    input logic signed [`FIXED_WIDTH-1:0] control_imag_1,

    // Target qubit
    input logic signed [`FIXED_WIDTH-1:0] target_real_0,
    input logic signed [`FIXED_WIDTH-1:0] target_imag_0,
    input logic signed [`FIXED_WIDTH-1:0] target_real_1,
    input logic signed [`FIXED_WIDTH-1:0] target_imag_1,

    // Output state
    // |00⟩ component
    output logic signed [`FIXED_WIDTH-1:0] out_real_00,
    output logic signed [`FIXED_WIDTH-1:0] out_imag_00,
    // |01⟩ component
    output logic signed [`FIXED_WIDTH-1:0] out_real_01,
    output logic signed [`FIXED_WIDTH-1:0] out_imag_01,
    // |10⟩ component
    output logic signed [`FIXED_WIDTH-1:0] out_real_10,
    output logic signed [`FIXED_WIDTH-1:0] out_imag_10,
    // |11⟩ component
    output logic signed [`FIXED_WIDTH-1:0] out_real_11,
    output logic signed [`FIXED_WIDTH-1:0] out_imag_11
);

    // For |00⟩: No change
    // |00⟩ = control_0 * target_0
    logic signed [`FIXED_WIDTH-1:0] real_00_part1, imag_00_part1;
    logic signed [`FIXED_WIDTH-1:0] real_00_part2, imag_00_part2;

    // For |01⟩: No change
    // |01⟩ = control_0 * target_1
    logic signed [`FIXED_WIDTH-1:0] real_01_part1, imag_01_part1;
    logic signed [`FIXED_WIDTH-1:0] real_01_part2, imag_01_part2;

    // For |10⟩ and |11⟩: Swap the target bits when control is |1⟩
    // |10⟩ = control_1 * target_1 (flipped from target_0)
    logic signed [`FIXED_WIDTH-1:0] real_10_part1, imag_10_part1;
    logic signed [`FIXED_WIDTH-1:0] real_10_part2, imag_10_part2;

    // |11⟩ = control_1 * target_0 (flipped from target_1)
    logic signed [`FIXED_WIDTH-1:0] real_11_part1, imag_11_part1;
    logic signed [`FIXED_WIDTH-1:0] real_11_part2, imag_11_part2;

    // Complex multiplication for |00⟩ = control_0 * target_0
    // (a+bi) * (c+di) = (ac-bd) + (ad+bc)i
    q_mul mul_real_00_1 (
        .a(control_real_0),
        .b(target_real_0),
        .result(real_00_part1)
    );
    q_mul mul_real_00_2 (
        .a(control_imag_0),
        .b(target_imag_0),
        .result(real_00_part2)
    );
    q_mul mul_imag_00_1 (
        .a(control_real_0),
        .b(target_imag_0),
        .result(imag_00_part1)
    );
    q_mul mul_imag_00_2 (
        .a(control_imag_0),
        .b(target_real_0),
        .result(imag_00_part2)
    );

    q_add add_real_00 (
        .a(real_00_part1),
        .b(-real_00_part2),
        .result(out_real_00)
    );
    q_add add_imag_00 (
        .a(imag_00_part1),
        .b(imag_00_part2),
        .result(out_imag_00)
    );

    // Complex multiplication for |01⟩ = control_0 * target_1
    q_mul mul_real_01_1 (
        .a(control_real_0),
        .b(target_real_1),
        .result(real_01_part1)
    );
    q_mul mul_real_01_2 (
        .a(control_imag_0),
        .b(target_imag_1),
        .result(real_01_part2)
    );
    q_mul mul_imag_01_1 (
        .a(control_real_0),
        .b(target_imag_1),
        .result(imag_01_part1)
    );
    q_mul mul_imag_01_2 (
        .a(control_imag_0),
        .b(target_real_1),
        .result(imag_01_part2)
    );

    q_add add_real_01 (
        .a(real_01_part1),
        .b(-real_01_part2),
        .result(out_real_01)
    );
    q_add add_imag_01 (
        .a(imag_01_part1),
        .b(imag_01_part2),
        .result(out_imag_01)
    );

    // Complex multiplication for |10⟩ = control_1 * target_1 (bit flip on target)
    q_mul mul_real_10_1 (
        .a(control_real_1),
        .b(target_real_1),
        .result(real_10_part1)
    );
    q_mul mul_real_10_2 (
        .a(control_imag_1),
        .b(target_imag_1),
        .result(real_10_part2)
    );
    q_mul mul_imag_10_1 (
        .a(control_real_1),
        .b(target_imag_1),
        .result(imag_10_part1)
    );
    q_mul mul_imag_10_2 (
        .a(control_imag_1),
        .b(target_real_1),
        .result(imag_10_part2)
    );

    q_add add_real_10 (
        .a(real_10_part1),
        .b(-real_10_part2),
        .result(out_real_10)
    );
    q_add add_imag_10 (
        .a(imag_10_part1),
        .b(imag_10_part2),
        .result(out_imag_10)
    );

    // Complex multiplication for |11⟩ = control_1 * target_0 (bit flip on target)
    q_mul mul_real_11_1 (
        .a(control_real_1),
        .b(target_real_0),
        .result(real_11_part1)
    );
    q_mul mul_real_11_2 (
        .a(control_imag_1),
        .b(target_imag_0),
        .result(real_11_part2)
    );
    q_mul mul_imag_11_1 (
        .a(control_real_1),
        .b(target_imag_0),
        .result(imag_11_part1)
    );
    q_mul mul_imag_11_2 (
        .a(control_imag_1),
        .b(target_real_0),
        .result(imag_11_part2)
    );

    q_add add_real_11 (
        .a(real_11_part1),
        .b(-real_11_part2),
        .result(out_real_11)
    );
    q_add add_imag_11 (
        .a(imag_11_part1),
        .b(imag_11_part2),
        .result(out_imag_11)
    );

endmodule
