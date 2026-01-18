// ============================================================================
// Testbench for 4-bit Adder
// ============================================================================
//
// WHAT IS A TESTBENCH?
// A testbench is Verilog code that tests your design. It's NOT synthesized
// into real hardware - it only runs in simulation. Think of it as a "test
// harness" that:
//   1. Creates fake input signals
//   2. Connects them to your design
//   3. Checks if the outputs are correct
//
// TESTBENCH vs DESIGN:
//   - Design modules have inputs and outputs (they connect to the real world)
//   - Testbench modules have NO ports (they're self-contained test programs)
//
// ============================================================================

module tb_adder_4bit;  // Note: No port list () - testbenches are self-contained

    // ========================================================================
    // STEP 1: Declare Test Signals
    // ========================================================================
    //
    // We need variables to hold our test inputs and capture outputs.
    //
    // "reg" vs "wire" - THIS IS IMPORTANT:
    //   - Use "reg" for signals YOU drive from an initial/always block
    //   - Use "wire" for signals driven BY another module
    //
    // Think of it this way:
    //   - reg = "I control this value" (like a variable you can assign to)
    //   - wire = "Something else controls this" (like reading an output)
    //
    // ========================================================================

    reg  [3:0] a, b;     // We drive these inputs, so they're "reg"
    reg        cin;      // We drive this too
    wire [3:0] sum;      // The adder drives this output, so it's "wire"
    wire       cout;     // The adder drives this too

    // ========================================================================
    // STEP 2: Instantiate the Design Under Test (DUT)
    // ========================================================================
    //
    // This creates an "instance" of our adder module and connects signals.
    //
    // SYNTAX EXPLANATION:
    //   adder_4bit uut ( ... );
    //   ^^^^^^^^^^      ^^^
    //   module name     instance name (we call it "uut" = Unit Under Test)
    //
    // PORT CONNECTIONS use "named association":
    //   .a(a)  means "connect the module's port 'a' to our signal 'a'"
    //   .sum(sum) means "connect the module's port 'sum' to our signal 'sum'"
    //
    // The dot-name is the PORT on the module.
    // The name in parentheses is OUR signal.
    // They don't have to match, but it's clearer when they do!
    //
    // ========================================================================

    adder_4bit uut (
        .a(a),           // Connect module port 'a' to our signal 'a'
        .b(b),           // Connect module port 'b' to our signal 'b'
        .cin(cin),       // Connect module port 'cin' to our signal 'cin'
        .sum(sum),       // Connect module port 'sum' to our signal 'sum'
        .cout(cout)      // Connect module port 'cout' to our signal 'cout'
    );

    // ========================================================================
    // STEP 3: The Test Sequence
    // ========================================================================
    //
    // "initial" blocks run ONCE at the start of simulation.
    // They execute sequentially, like a program.
    //
    // This is simulation-only! Real hardware doesn't have "initial" blocks
    // that run code - it's just for testing.
    //
    // ========================================================================

    initial begin
        // ====================================================================
        // Enable Waveform Dumping
        // ====================================================================
        // These commands create a VCD (Value Change Dump) file that records
        // how all signals change over time. EPWave reads this file.
        //
        // $dumpfile("dump.vcd") - Name of the output file
        // $dumpvars(0, tb_adder_4bit) - Record ALL signals in this module
        //   The "0" means "record all levels of hierarchy"
        // ====================================================================

        $dumpfile("dump.vcd");
        $dumpvars(0, tb_adder_4bit);

        // ====================================================================
        // TEST CASE 1: Simple Addition (3 + 2 = 5)
        // ====================================================================
        // This tests basic functionality with small numbers.
        // Expected: sum = 5 (0101), cout = 0 (no overflow)
        // ====================================================================

        $display("\n========== STARTING TESTS ==========\n");

        a = 4'b0011;  // 4'b means "4-bit binary". 0011 = 3 in decimal
        b = 4'b0010;  // 0010 = 2 in decimal
        cin = 0;      // No carry-in

        #10;  // Wait 10 time units for signals to propagate
              // The # symbol means "delay" - crucial for simulation timing!

        // $display is like printf in C - prints to the console
        // %d = decimal format, %b = binary format
        $display("Test 1: Simple Addition");
        $display("  Inputs:  a = %d (%b), b = %d (%b), cin = %b", a, a, b, b, cin);
        $display("  Outputs: sum = %d (%b), cout = %b", sum, sum, cout);
        $display("  Expected: 3 + 2 = 5, no overflow");
        $display("");

        // ====================================================================
        // TEST CASE 2: Overflow Detection (15 + 1 = 16)
        // ====================================================================
        // This tests what happens when the result exceeds 15.
        // 16 requires 5 bits (10000), but sum is only 4 bits!
        // Expected: sum = 0 (0000), cout = 1 (overflow!)
        // ====================================================================

        a = 4'b1111;  // 1111 = 15 in decimal (maximum 4-bit value)
        b = 4'b0001;  // 0001 = 1 in decimal
        cin = 0;

        #10;  // Wait for the adder to compute

        $display("Test 2: Overflow Detection");
        $display("  Inputs:  a = %d (%b), b = %d (%b), cin = %b", a, a, b, b, cin);
        $display("  Outputs: sum = %d (%b), cout = %b", sum, sum, cout);
        $display("  Expected: 15 + 1 = 16, but sum shows 0 with cout=1 (OVERFLOW!)");
        $display("  Note: cout=1 means the true result is sum + 16 = %d", sum + 16);
        $display("");

        // ====================================================================
        // TEST CASE 3: Using Carry-In (7 + 8 + 1 = 16)
        // ====================================================================
        // This tests the carry-in functionality.
        // Carry-in is useful when chaining adders for larger numbers.
        // Expected: sum = 0, cout = 1
        // ====================================================================

        a = 4'b0111;  // 0111 = 7 in decimal
        b = 4'b1000;  // 1000 = 8 in decimal
        cin = 1;      // Carry-in = 1 (adds one more to the result)

        #10;

        $display("Test 3: Using Carry-In");
        $display("  Inputs:  a = %d (%b), b = %d (%b), cin = %b", a, a, b, b, cin);
        $display("  Outputs: sum = %d (%b), cout = %b", sum, sum, cout);
        $display("  Expected: 7 + 8 + 1 = 16 -> sum=0, cout=1");
        $display("");

        // ====================================================================
        // TEST CASE 4: Zero Addition (0 + 0 = 0)
        // ====================================================================
        // Edge case: verify the adder handles zeros correctly.
        // Expected: sum = 0, cout = 0
        // ====================================================================

        a = 4'b0000;
        b = 4'b0000;
        cin = 0;

        #10;

        $display("Test 4: Zero Addition");
        $display("  Inputs:  a = %d (%b), b = %d (%b), cin = %b", a, a, b, b, cin);
        $display("  Outputs: sum = %d (%b), cout = %b", sum, sum, cout);
        $display("  Expected: 0 + 0 = 0, no overflow");
        $display("");

        // ====================================================================
        // TEST CASE 5: Maximum Without Overflow (8 + 7 = 15)
        // ====================================================================
        // Tests the largest result that fits in 4 bits.
        // Expected: sum = 15 (1111), cout = 0
        // ====================================================================

        a = 4'b1000;  // 8
        b = 4'b0111;  // 7
        cin = 0;

        #10;

        $display("Test 5: Maximum Without Overflow");
        $display("  Inputs:  a = %d (%b), b = %d (%b), cin = %b", a, a, b, b, cin);
        $display("  Outputs: sum = %d (%b), cout = %b", sum, sum, cout);
        $display("  Expected: 8 + 7 = 15 (fits in 4 bits), no overflow");
        $display("");

        // ====================================================================
        // End Simulation
        // ====================================================================
        // $finish tells the simulator to stop.
        // Without this, some simulators run forever!
        // ====================================================================

        $display("========== ALL TESTS COMPLETED ==========\n");
        $finish;
    end

endmodule

// ============================================================================
// WHAT TO OBSERVE IN THE WAVEFORM VIEWER (EPWave)
// ============================================================================
//
// When you open EPWave after running the simulation, look for:
//
// 1. SIGNAL TIMING
//    - Notice how 'a', 'b', and 'cin' change every 10 time units
//    - 'sum' and 'cout' change IMMEDIATELY after inputs change
//    - This shows combinational logic has no delay (in simulation)
//
// 2. BINARY VALUES
//    - Click on signals to see their binary/decimal values
//    - Watch how sum[3:0] changes with each test case
//
// 3. OVERFLOW INDICATOR
//    - Watch 'cout' - it goes HIGH (1) during tests 2 and 3
//    - This visually shows when overflow occurs
//
// 4. SIGNAL HIERARCHY
//    - Expand tb_adder_4bit to see all signals
//    - Expand uut (the adder instance) to see its internal view
//
// ============================================================================
