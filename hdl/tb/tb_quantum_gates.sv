`timescale 1ns / 1ps
`include "../include/include.vh"
`include "../rtl/pauli_x.sv"
`include "../rtl/pauli_y.sv"
`include "../rtl/pauli_z.sv"
`include "../rtl/phase_gate.sv"

module tb_quantum_gates;
    // Testbench signals
    logic signed [`FIXED_WIDTH-1:0] in_real;
    logic signed [`FIXED_WIDTH-1:0] in_imag;

    // Outputs for each gate
    logic signed [`FIXED_WIDTH-1:0] out_real_x, out_imag_x;
    logic signed [`FIXED_WIDTH-1:0] out_real_y, out_imag_y;
    logic signed [`FIXED_WIDTH-1:0] out_real_z, out_imag_z;
    logic signed [`FIXED_WIDTH-1:0] out_real_s, out_imag_s;

    // Pre-computed constants
    logic signed [`FIXED_WIDTH-1:0] const_0;
    logic signed [`FIXED_WIDTH-1:0] const_1;
    logic signed [`FIXED_WIDTH-1:0] const_neg_1;

    // Assign constants
    initial begin
        const_0 = 0;
        const_1 = `FIXED_POINT_CONST_1;
        const_neg_1 = `FIXED_POINT_CONST_1_NEG;
    end

    // Instantiate the DUTs
    pauli_x x_gate (
        .in_real (in_real),
        .in_imag (in_imag),
        .out_real(out_real_x),
        .out_imag(out_imag_x)
    );

    pauli_y y_gate (
        .in_real (in_real),
        .in_imag (in_imag),
        .out_real(out_real_y),
        .out_imag(out_imag_y)
    );

    pauli_z z_gate (
        .in_real (in_real),
        .in_imag (in_imag),
        .out_real(out_real_z),
        .out_imag(out_imag_z)
    );

    phase_gate s_gate (
        .in_real (in_real),
        .in_imag (in_imag),
        .out_real(out_real_s),
        .out_imag(out_imag_s)
    );

    // Test case counter for logging
    int test_count = 0;
    int pass_count = 0;

    // Test cases
    initial begin
        $display("========================================");
        $display("Starting Quantum Gates Testbench");
        $display("Testing Pauli-X, Pauli-Y, Pauli-Z, and Phase Gates");
        $display("FIXED_WIDTH = %0d", `FIXED_WIDTH);
        $display("SCALE_FACTOR = %0d", `SCALE_FACTOR);
        $display("========================================");

        // Test case 1: |0⟩ input state
        // Expected:
        // X|0⟩ = |1⟩ = [0,1]
        // Y|0⟩ = i|1⟩ = [0,1]
        // Z|0⟩ = |0⟩ = [1,0]
        // S|0⟩ = |0⟩ = [1,0]
        test_count += 8;  // 2 outputs per gate, 4 gates
        $display("\nTest Case 1: |0⟩ input state");
        in_real = const_1;  // 1.0 (|0⟩ component)
        in_imag = const_0;  // 0.0 (|1⟩ component)
        $display("  Input |0⟩ = [%.8f, %.8f]", real'(in_real) / `SCALE_FACTOR,
                 real'(in_imag) / `SCALE_FACTOR);
        #10;

        $display("  Pauli-X result = [%.8f, %.8f]", real'(out_real_x) / `SCALE_FACTOR,
                 real'(out_imag_x) / `SCALE_FACTOR);
        $display("  Pauli-Y result = [%.8f, %.8f]", real'(out_real_y) / `SCALE_FACTOR,
                 real'(out_imag_y) / `SCALE_FACTOR);
        $display("  Pauli-Z result = [%.8f, %.8f]", real'(out_real_z) / `SCALE_FACTOR,
                 real'(out_imag_z) / `SCALE_FACTOR);
        $display("  Phase-S result = [%.8f, %.8f]", real'(out_real_s) / `SCALE_FACTOR,
                 real'(out_imag_s) / `SCALE_FACTOR);

        // Check X gate: |0⟩ -> |1⟩ [0,1]
        pass_count += check_result_with_tolerance("Pauli-X |0⟩ - real", out_real_x, const_0, 2);
        pass_count += check_result_with_tolerance("Pauli-X |0⟩ - imag", out_imag_x, const_1, 2);

        // Check Y gate: |0⟩ -> i|1⟩ [0,1]
        pass_count += check_result_with_tolerance("Pauli-Y |0⟩ - real", out_real_y, const_0, 2);
        pass_count += check_result_with_tolerance("Pauli-Y |0⟩ - imag", out_imag_y, const_1, 2);

        // Check Z gate: |0⟩ -> |0⟩ [1,0]
        pass_count += check_result_with_tolerance("Pauli-Z |0⟩ - real", out_real_z, const_1, 2);
        pass_count += check_result_with_tolerance("Pauli-Z |0⟩ - imag", out_imag_z, const_0, 2);

        // Check S gate: |0⟩ -> |0⟩ [1,0]
        pass_count += check_result_with_tolerance("Phase-S |0⟩ - real", out_real_s, const_1, 2);
        pass_count += check_result_with_tolerance("Phase-S |0⟩ - imag", out_imag_s, const_0, 2);

        // Test case 2: |1⟩ input state
        // Expected:
        // X|1⟩ = |0⟩ = [1,0]
        // Y|1⟩ = -i|0⟩ = [0,-1]
        // Z|1⟩ = -|1⟩ = [0,-1]
        // S|1⟩ = i|1⟩ = [0,1]
        test_count += 8;
        $display("\nTest Case 2: |1⟩ input state");
        in_real = const_0;  // 0.0 (|0⟩ component)
        in_imag = const_1;  // 1.0 (|1⟩ component)
        $display("  Input |1⟩ = [%.3f, %.3f]", real'(in_real) / `SCALE_FACTOR,
                 real'(in_imag) / `SCALE_FACTOR);
        #10;

        $display("  Pauli-X result = [%.8f, %.8f]", real'(out_real_x) / `SCALE_FACTOR,
                 real'(out_imag_x) / `SCALE_FACTOR);
        $display("  Pauli-Y result = [%.8f, %.8f]", real'(out_real_y) / `SCALE_FACTOR,
                 real'(out_imag_y) / `SCALE_FACTOR);
        $display("  Pauli-Z result = [%.8f, %.8f]", real'(out_real_z) / `SCALE_FACTOR,
                 real'(out_imag_z) / `SCALE_FACTOR);
        $display("  Phase-S result = [%.8f, %.8f]", real'(out_real_s) / `SCALE_FACTOR,
                 real'(out_imag_s) / `SCALE_FACTOR);

        // Check X gate: |1⟩ -> |0⟩ [1,0]
        pass_count += check_result_with_tolerance("Pauli-X |1⟩ - real", out_real_x, const_1, 2);
        pass_count += check_result_with_tolerance("Pauli-X |1⟩ - imag", out_imag_x, const_0, 2);

        // Check Y gate: |1⟩ -> -i|0⟩ [0,-1]
        pass_count += check_result_with_tolerance(
            "Pauli-Y |1⟩ - real", out_real_y, const_neg_1, 2
        );
        pass_count += check_result_with_tolerance("Pauli-Y |1⟩ - imag", out_imag_y, const_0, 2);

        // Check Z gate: |1⟩ -> -|1⟩ [0,-1]
        pass_count += check_result_with_tolerance("Pauli-Z |1⟩ - real", out_real_z, const_0, 2);
        pass_count += check_result_with_tolerance(
            "Pauli-Z |1⟩ - imag", out_imag_z, const_neg_1, 2
        );

        // Check S gate: |1⟩ -> i|1⟩ [0,1] (this needs fixing, should be [0,i] which is complex)
        pass_count += check_result_with_tolerance("Phase-S |1⟩ - real", out_real_s, const_0, 2);
        pass_count += check_result_with_tolerance("Phase-S |1⟩ - imag", out_imag_s, const_1, 2);

        // Summary of results
        $display("\n========================================");
        $display("Test Summary: %0d tests, %0d passed, %0d failed", test_count, pass_count,
                 (test_count - pass_count));
        $display("========================================");

        $display("\nTestbench completed");
        $finish;
    end

    // Generate waveform file
    initial begin
        $dumpfile("tb_quantum_gates.vcd");
        $dumpvars(0, tb_quantum_gates);
        $dumpvars(0, pauli_x);
        $dumpvars(0, pauli_y);
        $dumpvars(0, pauli_z);
        $dumpvars(0, phase_gate);
        $dumplimit(1048576);
    end

    // Check function with tolerance for fixed-point arithmetic
    function int check_result_with_tolerance;
        input string test_name;
        input [`FIXED_WIDTH-1:0] actual;
        input [`FIXED_WIDTH-1:0] expected;
        input [`FIXED_WIDTH-1:0] tolerance;
        logic signed [`FIXED_WIDTH-1:0] diff;
        begin
            diff = actual - expected;
            if (diff < 0) diff = -diff;

            if (diff <= tolerance) begin
                $display("  Result: PASS - '%s' test successful", test_name);
                return 1;
            end else begin
                $display("  Result: FAIL - '%s' test failed", test_name);
                $display("    Expected: 0x%h (%.6f)", expected, real'(expected) / `SCALE_FACTOR);
                $display("    Actual:   0x%h (%.6f)", actual, real'(actual) / `SCALE_FACTOR);
                $display("    Diff:     %0d (tolerance: %0d)", diff, tolerance);
                return 0;
            end
        end
    endfunction

endmodule
