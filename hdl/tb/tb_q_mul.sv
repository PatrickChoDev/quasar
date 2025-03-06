`timescale 1ns/1ps
`include "../include/include.vh"
`include "../rtl/q_mul.sv"

module tb_q_mul;
  // Testbench signals
  logic signed [`FIXED_WIDTH-1:0] a;
  logic signed [`FIXED_WIDTH-1:0] b;
  logic signed [`FIXED_WIDTH-1:0] result;
  
  // Instantiate the DUT
  q_mul dut (
    .a(a),
    .b(b),
    .result(result)
  );
  
  // Test case counter for logging
  int test_count = 0;
  int pass_count = 0;
  
  // Test cases
  initial begin
    $display("========================================");
    $display("Starting q_mul testbench");
    $display("FIXED_WIDTH = %0d", `FIXED_WIDTH);
    $display("SCALE_FACTOR = %0d", `SCALE_FACTOR);
    $display("========================================");
    
    // Test case 1: Simple multiplication
    test_count++;
    $display("\nTest Case %0d: Simple multiplication", test_count);
    a = (`SCALE_FACTOR/2);       // 0.5
    b = (`SCALE_FACTOR/4);       // 0.25
    $display("  Input a = %0d (%.3f)", a, real'(a) / `SCALE_FACTOR);
    $display("  Input b = %0d (%.3f)", b, real'(b) / `SCALE_FACTOR);
    #10;
    $display("  Result = %0d (%.3f)", result, real'(result) / `SCALE_FACTOR);
    $display("  Expected = %0d (%.3f)", `SCALE_FACTOR/8, real'(`SCALE_FACTOR/8) / `SCALE_FACTOR);
    pass_count += check_result("Simple multiplication", result, (`SCALE_FACTOR/8)); // 0.125
    
    // Test case 2: Multiplication with negative number
    test_count++;
    $display("\nTest Case %0d: Multiplication with negative number", test_count);
    a = (`SCALE_FACTOR/2);       // 0.5
    b = -(`SCALE_FACTOR/4);      // -0.25
    $display("  Input a = %0d (%.3f)", a, real'(a) / `SCALE_FACTOR);
    $display("  Input b = %0d (%.3f)", b, real'(b) / `SCALE_FACTOR);
    #10;
    $display("  Result = %0d (%.3f)", result, real'(result) / `SCALE_FACTOR);
    $display("  Expected = %0d (%.3f)", -(`SCALE_FACTOR/8), real'(-(`SCALE_FACTOR/8)) / `SCALE_FACTOR);
    pass_count += check_result("Multiplication with negative number", result, -(`SCALE_FACTOR/8));   // -0.125
    
    // Test case 3: Two negative numbers
    test_count++;
    $display("\nTest Case %0d: Two negative numbers", test_count);
    a = -(`SCALE_FACTOR/2);      // -0.5
    b = -(`SCALE_FACTOR/4);      // -0.25
    $display("  Input a = %0d (%.3f)", a, real'(a) / `SCALE_FACTOR);
    $display("  Input b = %0d (%.3f)", b, real'(b) / `SCALE_FACTOR);
    #10;
    $display("  Result = %0d (%.3f)", result, real'(result) / `SCALE_FACTOR);
    $display("  Expected = %0d (%.3f)", (`SCALE_FACTOR/8), real'(`SCALE_FACTOR/8) / `SCALE_FACTOR);
    pass_count += check_result("Two negative numbers", result, (`SCALE_FACTOR/8)); // 0.125
    
    // Test case 4: Positive overflow
    test_count++;
    $display("\nTest Case %0d: Positive overflow", test_count);
    a = (8*`SCALE_FACTOR/10);    // 0.8
    b = (8*`SCALE_FACTOR/10);    // 0.8
    $display("  Input a = %0d (%.3f)", a, real'(a) / `SCALE_FACTOR);
    $display("  Input b = %0d (%.3f)", b, real'(b) / `SCALE_FACTOR);
    #10;
    $display("  Result = %0d (%.3f)", result, real'(result) / `SCALE_FACTOR);
    $display("  Expected = %0d (%.3f)", (64*`SCALE_FACTOR)/100, real'((64*`SCALE_FACTOR)/100) / `SCALE_FACTOR);
    pass_count += check_result("Multiplication close to 1.0", result, (64*`SCALE_FACTOR)/100); // 0.64
    
    // Test case 5: Negative overflow
    test_count++;
    $display("\nTest Case %0d: Negative overflow", test_count);
    a = (9*`SCALE_FACTOR/10);    // 0.9
    b = -(9*`SCALE_FACTOR/10);   // -0.9
    $display("  Input a = %0d (%.3f)", a, real'(a) / `SCALE_FACTOR);
    $display("  Input b = %0d (%.3f)", b, real'(b) / `SCALE_FACTOR);
    #10;
    $display("  Result = %0d (%.3f)", result, real'(result) / `SCALE_FACTOR);
    $display("  Expected = %0d (%.3f)", -(81*`SCALE_FACTOR)/100, real'(-(81*`SCALE_FACTOR)/100) / `SCALE_FACTOR);
    pass_count += check_result("Negative overflow", result, -(81*`SCALE_FACTOR)/100); // -0.81

    // Test case 6: Multiplying 1 and -1
    test_count++;
    $display("\nTest Case %0d: 1 * (-1)", test_count);
    a = `SCALE_FACTOR;        // 1.0
    b = -`SCALE_FACTOR;       // -1.0
    $display("  Input a = %0d (%.3f)", a, real'(a) / `SCALE_FACTOR);
    $display("  Input b = %0d (%.3f)", b, real'(b) / `SCALE_FACTOR);
    #10;
    $display("  Result = %0d (%.3f)", result, real'(result) / `SCALE_FACTOR);
    $display("  Expected = %0d (%.3f)", -`SCALE_FACTOR, real'(-`SCALE_FACTOR) / `SCALE_FACTOR);
    pass_count += check_result("1 * (-1)", result, -`SCALE_FACTOR); // expected -1
    
    // Summary of results
    $display("\n========================================");
    $display("Test Summary: %0d tests, %0d passed, %0d failed", 
             test_count, pass_count, (test_count - pass_count));
    $display("========================================");
    
    $display("\nTestbench completed");
    $finish;
  end
  
  // Generate waveform file     
  initial begin
    $dumpfile("tb_q_mul.vcd");
    $dumpvars(0, tb_q_mul);
  end
  
  // Enhanced check task that returns 1 for pass, 0 for fail
  function int check_result;
    input string test_name;
    input [`FIXED_WIDTH-1:0] actual;
    input [`FIXED_WIDTH-1:0] expected;
    begin
      if (actual == expected) begin
        $display("  Result: PASS - '%s' test successful", test_name);
        return 1;
      end else begin
        $display("  Result: FAIL - '%s' test failed", test_name);
        $display("    Expected: 0x%h (%0d)", expected, expected);
        $display("    Actual:   0x%h (%0d)", actual, actual);
        return 0;
      end
    end
  endfunction

endmodule
