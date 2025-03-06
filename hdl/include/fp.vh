`ifndef INCLUDE_MATH_VH
`define INCLUDE_MATH_VH

`define Q1_15  // 16-bit fixed-point format (-1.0 to +0.99997)
// `define Q1_31  // 32-bit fixed-point format (-1.0 to +0.9999999995)
// `define Q2_14  // 16-bit fixed-point format (-2.0 to +1.99994)
// `define Q2_30  // 32-bit fixed-point format (-2.0 to +1.999999999)

// Define bit-width and fraction width based on selected Q-notation
`ifdef Q2_30
    `define FIXED_WIDTH 32
    `define INT_BITS 2
    `define FRAC_BITS 30

`elsif Q2_14
    `define FIXED_WIDTH 16
    `define INT_BITS 2
    `define FRAC_BITS 14

`elsif Q1_31
    `define FIXED_WIDTH 32
    `define INT_BITS 1
    `define FRAC_BITS 31

`elsif Q1_15
    `define FIXED_WIDTH 16
    `define INT_BITS 1
    `define FRAC_BITS 15

`else
    `error "No valid Q format selected. Define one in include.vh"
`endif


`define FIXED_MIN -(1 << (`FIXED_WIDTH - 1))
`define FIXED_MAX ((1 << (`FIXED_WIDTH - 1)) - 1)
`define EXT_FIXED_MIN -(1 << (`FIXED_WIDTH))
`define EXT_FIXED_MAX ((1 << (`FIXED_WIDTH)) - 1)

// Useful Macros
`define SCALE_FACTOR (1 << `FRAC_BITS)
`define ROUNDING_VALUE (1 << (`FRAC_BITS - 1))


`define FIXED_TO_FLOAT(value) ((value) / `SCALE_FACTOR)
`define FLOAT_TO_FIXED(value) ((value) * `SCALE_FACTOR)

// Common fixed-point constants of 1/sqrt(2)
`define FIXED_POINT_CONST_0_7071 (`FLOAT_TO_FIXED(0.7071))

`endif // INCLUDE_MATH_VH