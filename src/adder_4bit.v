// ============================================================================
// 4-bit Adder Module
// ============================================================================
//
// WHAT THIS MODULE DOES:
// This module adds two 4-bit binary numbers together, similar to how you
// would add two numbers by hand, but in binary (base 2) instead of decimal.
//
// INPUTS:
//   a[3:0]  - First 4-bit number  (can represent values 0 to 15)
//   b[3:0]  - Second 4-bit number (can represent values 0 to 15)
//   cin     - Carry-in bit (useful when chaining multiple adders together)
//
// OUTPUTS:
//   sum[3:0] - The 4-bit result of a + b + cin
//   cout     - Carry-out bit (1 if the result exceeded 15, i.e., overflow)
//
// EXAMPLE:
//   If a = 0011 (3 in decimal) and b = 0010 (2 in decimal), cin = 0
//   Then sum = 0101 (5 in decimal) and cout = 0 (no overflow)
//
// ============================================================================

module adder_4bit (
    // ---- INPUT PORTS ----
    // [3:0] means this is a 4-bit wide signal (bits numbered 3, 2, 1, 0)
    // The leftmost bit [3] is the Most Significant Bit (MSB)
    // The rightmost bit [0] is the Least Significant Bit (LSB)
    input  [3:0] a,      // First 4-bit input (range: 0-15 in decimal)
    input  [3:0] b,      // Second 4-bit input (range: 0-15 in decimal)
    input        cin,    // Carry-in: single bit (no width specified = 1 bit)

    // ---- OUTPUT PORTS ----
    output [3:0] sum,    // 4-bit sum result
    output       cout    // Carry-out: indicates if result > 15 (overflow)
);

    // ========================================================================
    // THE ACTUAL LOGIC - This single line does all the work!
    // ========================================================================
    //
    // UNDERSTANDING THIS LINE:
    //   assign {cout, sum} = a + b + cin;
    //
    // Let's break it down:
    //
    // 1. "assign" - This creates COMBINATIONAL LOGIC (no clock needed)
    //    - The output continuously reflects the inputs
    //    - Whenever a, b, or cin changes, sum and cout update immediately
    //    - Think of it like a math formula that's always being calculated
    //
    // 2. "a + b + cin" - Simple addition
    //    - Verilog knows how to add binary numbers
    //    - Adding two 4-bit numbers can produce a 5-bit result (max: 15+15+1=31)
    //
    // 3. "{cout, sum}" - This is CONCATENATION
    //    - The curly braces {} join signals together
    //    - {cout, sum} creates a 5-bit value: {1-bit, 4-bits} = 5 bits
    //    - cout gets the MSB (bit 4), sum gets bits [3:0]
    //
    // EXAMPLE WALKTHROUGH:
    //   a = 1111 (15), b = 0001 (1), cin = 0
    //   a + b + cin = 15 + 1 + 0 = 16 (decimal)
    //   16 in binary = 10000 (5 bits!)
    //   So: cout = 1, sum = 0000
    //   The cout=1 tells us "overflow happened"
    //
    // ========================================================================

    assign {cout, sum} = a + b + cin;

    // ========================================================================
    // WHY THIS DESIGN IS "BEHAVIORAL"
    // ========================================================================
    //
    // This is called "behavioral" Verilog because we describe WHAT we want
    // (addition) rather than HOW to build it (individual gates).
    //
    // The synthesis tool (when targeting real hardware) will automatically
    // create the necessary AND, OR, XOR gates to implement addition.
    //
    // An alternative "structural" approach would instantiate individual
    // full-adder modules and connect them - that's more complex but gives
    // you more control over the exact circuit structure.
    //
    // ========================================================================

endmodule
