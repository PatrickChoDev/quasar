`timescale 1ns / 1ps
`include "../include/include.vh"
`include "../rtl/q_add.sv"
`include "../rtl/q_mul.sv"
`include "../rtl/hadamard.sv"

module tb_con;
    // Testbench signals
    logic signed [`FIXED_WIDTH-1:0] in_real;
    logic signed [`FIXED_WIDTH-1:0] in_imag;
    logic signed [`FIXED_WIDTH-1:0] out_real;
    logic signed [`FIXED_WIDTH-1:0] out_imag;

    // Pre-computed expected constants
    logic signed [`FIXED_WIDTH-1:0] const_0_7071;
    logic signed [`FIXED_WIDTH-1:0] const_neg_0_7071;
    logic signed [`FIXED_WIDTH-1:0] const_1;
    logic signed [`FIXED_WIDTH-1:0] const_neg_1;

    // Assign constants at the module level
    initial begin
        /* verilator lint_off REALCVT */
        const_0_7071 = `FIXED_POINT_CONST_0_7071;
        /* verilator lint_off REALCVT */
        const_neg_0_7071 = `FIXED_POINT_CONST_0_7071_NEG;
        const_1 = `FIXED_POINT_CONST_1;
        const_neg_1 = `FIXED_POINT_CONST_1_NEG;
    end

    wire [`FIXED_WIDTH-1:0] out_real2;
    wire [`FIXED_WIDTH-1:0] out_imag2;

    // Instantiate the DUT
    hadamard dut (
        .in_real (in_real),
        .in_imag (in_imag),
        .out_real(out_real2),
        .out_imag(out_imag2)
    );

    hadamard dut2 (
        .in_real (out_real2),
        .in_imag (out_imag2),
        .out_real(out_real),
        .out_imag(out_imag)
    );

    // Test case counter for logging
    int test_count = 0;
    int pass_count = 0;

    // Test cases
    initial begin
        $display("========================================");
        $display("Starting hadamard testbench");
        $display("FIXED_WIDTH = %0d", `FIXED_WIDTH);
        $display("SCALE_FACTOR = %0d", `SCALE_FACTOR);
        $display("========================================");

        // Test case 1: |0⟩ input
        // Input: |0⟩ = [1, 0]
        // Expected: |0>
        test_count += 2;
        $display("\nTest Case %0d: |0⟩ input state", test_count);
        in_real = `SCALE_FACTOR;  // 1.0
        in_imag = 0;  // 0.0
        $display("  Input |0⟩ = [%.3f, %.3f]", real'(in_real) / `SCALE_FACTOR,
                 real'(in_imag) / `SCALE_FACTOR);
        #10;
        // For 2 Hadamard gates in series, H·H = I, so we expect the original |0⟩ state
        $display("  Result after 2 Hadamard gates = [%.8f, %.8f]", real'(out_real) / `SCALE_FACTOR,
                 real'(out_imag) / `SCALE_FACTOR);

        $display("  Expected (back to |0⟩) = [%.8f, %.8f]", real'(const_1) / `SCALE_FACTOR, 0.0);

        // Allow small tolerance due to fixed-point rounding
        pass_count += check_result_with_tolerance(
            "Double Hadamard |0⟩ (real part)", out_real, const_1, 2
        );
        pass_count += check_result_with_tolerance(
            "Double Hadamard |0⟩ (imag part)", out_imag, 0, 2
        );

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
        $dumpfile("tb_hadamard.vcd");
        $dumpvars(0, tb_hadamard);
        $dumpvars(0, hadamard);
        $dumpvars(0, q_add);
        $dumpvars(0, q_mul);
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
