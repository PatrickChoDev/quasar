`timescale 1ns / 1ps
`include "../include/include.vh"
`include "../rtl/q_add.sv"
`include "../rtl/q_mul.sv"
`include "../rtl/cnot.sv"

module tb_cnot;
    // Testbench signals - inputs
    logic signed [`FIXED_WIDTH-1:0] control_real_0;
    logic signed [`FIXED_WIDTH-1:0] control_imag_0;
    logic signed [`FIXED_WIDTH-1:0] control_real_1;
    logic signed [`FIXED_WIDTH-1:0] control_imag_1;
    logic signed [`FIXED_WIDTH-1:0] target_real_0;
    logic signed [`FIXED_WIDTH-1:0] target_imag_0;
    logic signed [`FIXED_WIDTH-1:0] target_real_1;
    logic signed [`FIXED_WIDTH-1:0] target_imag_1;

    // Outputs
    logic signed [`FIXED_WIDTH-1:0] out_real_00;
    logic signed [`FIXED_WIDTH-1:0] out_imag_00;
    logic signed [`FIXED_WIDTH-1:0] out_real_01;
    logic signed [`FIXED_WIDTH-1:0] out_imag_01;
    logic signed [`FIXED_WIDTH-1:0] out_real_10;
    logic signed [`FIXED_WIDTH-1:0] out_imag_10;
    logic signed [`FIXED_WIDTH-1:0] out_real_11;
    logic signed [`FIXED_WIDTH-1:0] out_imag_11;

    // Pre-computed constants
    logic signed [`FIXED_WIDTH-1:0] const_0;
    logic signed [`FIXED_WIDTH-1:0] const_1;

    // Assign constants at the module level
    initial begin
        const_0 = 0;
        const_1 = `FIXED_POINT_CONST_1;
    end

    // Instantiate the DUT
    cnot dut (
        .control_real_0(control_real_0),
        .control_imag_0(control_imag_0),
        .control_real_1(control_real_1),
        .control_imag_1(control_imag_1),
        .target_real_0(target_real_0),
        .target_imag_0(target_imag_0),
        .target_real_1(target_real_1),
        .target_imag_1(target_imag_1),
        .out_real_00(out_real_00),
        .out_imag_00(out_imag_00),
        .out_real_01(out_real_01),
        .out_imag_01(out_imag_01),
        .out_real_10(out_real_10),
        .out_imag_10(out_imag_10),
        .out_real_11(out_real_11),
        .out_imag_11(out_imag_11)
    );

    // Test case counter for logging
    int test_count = 0;
    int pass_count = 0;

    // Test cases
    initial begin
        $display("========================================");
        $display("Starting CNOT gate testbench");
        $display("FIXED_WIDTH = %0d", `FIXED_WIDTH);
        $display("SCALE_FACTOR = %0d", `SCALE_FACTOR);
        $display("========================================");

        // Test case 1: |00⟩ input state
        // CNOT |00⟩ = |00⟩
        test_count += 8;  // Checking all 8 outputs
        $display("\nTest Case 1: |00⟩ input state");

        // Control qubit in |0⟩ state
        control_real_0 = const_1;  // |0⟩ = 1
        control_imag_0 = const_0;  // |0⟩ = 0
        control_real_1 = const_0;  // |1⟩ = 0
        control_imag_1 = const_0;  // |1⟩ = 0

        // Target qubit in |0⟩ state
        target_real_0  = const_1;  // |0⟩ = 1
        target_imag_0  = const_0;  // |0⟩ = 0
        target_real_1  = const_0;  // |1⟩ = 0
        target_imag_1  = const_0;  // |1⟩ = 0

        $display("  Control = |0⟩, Target = |0⟩");
        #10;

        // Check results: only |00⟩ should be 1, all others 0
        $display("  Result for |00⟩ = [%.8f, %.8f]", real'(out_real_00) / `SCALE_FACTOR,
                 real'(out_imag_00) / `SCALE_FACTOR);

        $display("  Result for |01⟩ = [%.8f, %.8f]", real'(out_real_01) / `SCALE_FACTOR,
                 real'(out_imag_01) / `SCALE_FACTOR);

        $display("  Result for |10⟩ = [%.8f, %.8f]", real'(out_real_10) / `SCALE_FACTOR,
                 real'(out_imag_10) / `SCALE_FACTOR);

        $display("  Result for |11⟩ = [%.8f, %.8f]", real'(out_real_11) / `SCALE_FACTOR,
                 real'(out_imag_11) / `SCALE_FACTOR);

        pass_count += check_result_with_tolerance("CNOT |00⟩ - real_00", out_real_00, const_1, 2);
        pass_count += check_result_with_tolerance("CNOT |00⟩ - imag_00", out_imag_00, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |00⟩ - real_01", out_real_01, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |00⟩ - imag_01", out_imag_01, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |00⟩ - real_10", out_real_10, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |00⟩ - imag_10", out_imag_10, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |00⟩ - real_11", out_real_11, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |00⟩ - imag_11", out_imag_11, const_0, 2);

        // Test case 2: |01⟩ input state
        // CNOT |01⟩ = |01⟩
        test_count += 8;
        $display("\nTest Case 2: |01⟩ input state");

        // Control qubit in |0⟩ state
        control_real_0 = const_1;  // |0⟩ = 1
        control_imag_0 = const_0;
        control_real_1 = const_0;  // |1⟩ = 0
        control_imag_1 = const_0;

        // Target qubit in |1⟩ state
        target_real_0  = const_0;  // |0⟩ = 0
        target_imag_0  = const_0;
        target_real_1  = const_1;  // |1⟩ = 1
        target_imag_1  = const_0;

        $display("  Control = |0⟩, Target = |1⟩");
        #10;

        // Check results: only |01⟩ should be 1, all others 0
        $display("  Result for |00⟩ = [%.8f, %.8f]", real'(out_real_00) / `SCALE_FACTOR,
                 real'(out_imag_00) / `SCALE_FACTOR);

        $display("  Result for |01⟩ = [%.8f, %.8f]", real'(out_real_01) / `SCALE_FACTOR,
                 real'(out_imag_01) / `SCALE_FACTOR);

        $display("  Result for |10⟩ = [%.8f, %.8f]", real'(out_real_10) / `SCALE_FACTOR,
                 real'(out_imag_10) / `SCALE_FACTOR);

        $display("  Result for |11⟩ = [%.8f, %.8f]", real'(out_real_11) / `SCALE_FACTOR,
                 real'(out_imag_11) / `SCALE_FACTOR);

        pass_count += check_result_with_tolerance("CNOT |01⟩ - real_00", out_real_00, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |01⟩ - imag_00", out_imag_00, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |01⟩ - real_01", out_real_01, const_1, 2);
        pass_count += check_result_with_tolerance("CNOT |01⟩ - imag_01", out_imag_01, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |01⟩ - real_10", out_real_10, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |01⟩ - imag_10", out_imag_10, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |01⟩ - real_11", out_real_11, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |01⟩ - imag_11", out_imag_11, const_0, 2);

        // Test case 3: |10⟩ input state
        // CNOT |10⟩ = |11⟩ (flips target bit when control is 1)
        test_count += 8;
        $display("\nTest Case 3: |10⟩ input state");

        // Control qubit in |1⟩ state
        control_real_0 = const_0;  // |0⟩ = 0
        control_imag_0 = const_0;
        control_real_1 = const_1;  // |1⟩ = 1
        control_imag_1 = const_0;

        // Target qubit in |0⟩ state
        target_real_0  = const_1;  // |0⟩ = 1
        target_imag_0  = const_0;
        target_real_1  = const_0;  // |1⟩ = 0
        target_imag_1  = const_0;

        $display("  Control = |1⟩, Target = |0⟩");
        #10;

        // Check results: only |11⟩ should be 1, all others 0
        $display("  Result for |00⟩ = [%.8f, %.8f]", real'(out_real_00) / `SCALE_FACTOR,
                 real'(out_imag_00) / `SCALE_FACTOR);

        $display("  Result for |01⟩ = [%.8f, %.8f]", real'(out_real_01) / `SCALE_FACTOR,
                 real'(out_imag_01) / `SCALE_FACTOR);

        $display("  Result for |10⟩ = [%.8f, %.8f]", real'(out_real_10) / `SCALE_FACTOR,
                 real'(out_imag_10) / `SCALE_FACTOR);

        $display("  Result for |11⟩ = [%.8f, %.8f]", real'(out_real_11) / `SCALE_FACTOR,
                 real'(out_imag_11) / `SCALE_FACTOR);

        pass_count += check_result_with_tolerance("CNOT |10⟩ - real_00", out_real_00, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |10⟩ - imag_00", out_imag_00, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |10⟩ - real_01", out_real_01, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |10⟩ - imag_01", out_imag_01, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |10⟩ - real_10", out_real_10, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |10⟩ - imag_10", out_imag_10, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |10⟩ - real_11", out_real_11, const_1, 2);
        pass_count += check_result_with_tolerance("CNOT |10⟩ - imag_11", out_imag_11, const_0, 2);

        // Test case 4: |11⟩ input state
        // CNOT |11⟩ = |10⟩ (flips target bit when control is 1)
        test_count += 8;
        $display("\nTest Case 4: |11⟩ input state");

        // Control qubit in |1⟩ state
        control_real_0 = const_0;  // |0⟩ = 0
        control_imag_0 = const_0;
        control_real_1 = const_1;  // |1⟩ = 1
        control_imag_1 = const_0;

        // Target qubit in |1⟩ state
        target_real_0  = const_0;  // |0⟩ = 0
        target_imag_0  = const_0;
        target_real_1  = const_1;  // |1⟩ = 1
        target_imag_1  = const_0;

        $display("  Control = |1⟩, Target = |1⟩");
        #10;

        // Check results: only |10⟩ should be 1, all others 0
        $display("  Result for |00⟩ = [%.8f, %.8f]", real'(out_real_00) / `SCALE_FACTOR,
                 real'(out_imag_00) / `SCALE_FACTOR);

        $display("  Result for |01⟩ = [%.8f, %.8f]", real'(out_real_01) / `SCALE_FACTOR,
                 real'(out_imag_01) / `SCALE_FACTOR);

        $display("  Result for |10⟩ = [%.8f, %.8f]", real'(out_real_10) / `SCALE_FACTOR,
                 real'(out_imag_10) / `SCALE_FACTOR);

        $display("  Result for |11⟩ = [%.8f, %.8f]", real'(out_real_11) / `SCALE_FACTOR,
                 real'(out_imag_11) / `SCALE_FACTOR);

        pass_count += check_result_with_tolerance("CNOT |11⟩ - real_00", out_real_00, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |11⟩ - imag_00", out_imag_00, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |11⟩ - real_01", out_real_01, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |11⟩ - imag_01", out_imag_01, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |11⟩ - real_10", out_real_10, const_1, 2);
        pass_count += check_result_with_tolerance("CNOT |11⟩ - imag_10", out_imag_10, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |11⟩ - real_11", out_real_11, const_0, 2);
        pass_count += check_result_with_tolerance("CNOT |11⟩ - imag_11", out_imag_11, const_0, 2);

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
        $dumpfile("tb_cnot.vcd");
        $dumpvars(0, tb_cnot);
        $dumpvars(0, q_cnot);
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
