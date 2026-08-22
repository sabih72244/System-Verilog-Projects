module alu_tb;

    logic [7:0] A;
    logic [7:0] B;
    logic [2:0] opcode;

    logic [7:0] Y;
    logic       carry;

    logic [7:0] expected_Y;
    logic       expected_carry;


    //==================================================
    // DUT
    //==================================================

    alu dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .Y(Y),
        .carry(carry)
    );


    //==================================================
    // Transaction Class
    //==================================================

    class alu_transaction;

        rand bit [7:0] A;
        rand bit [7:0] B;
        rand bit [2:0] opcode;

        // Only valid operations
        constraint valid_opcode {
            opcode inside {
                3'b000,
                3'b001,
                3'b010,
                3'b011,
                3'b100
            };
        }

    endclass


    alu_transaction trans;


    //==================================================
    // Manual Coverage Variables
    //==================================================

    integer op_count [0:4];

    integer A_zero_count;
    integer A_low_count;
    integer A_mid_count;
    integer A_high_count;
    integer A_max_count;

    integer B_zero_count;
    integer B_low_count;
    integer B_mid_count;
    integer B_high_count;
    integer B_max_count;

    integer zero_result_count;
    integer nonzero_result_count;

    integer carry_count;
    integer no_carry_count;


    //==================================================
    // Coverage Counters
    //==================================================

    task update_coverage();

        // Opcode coverage
        case(opcode)

            3'b000: op_count[0] = op_count[0] + 1;
            3'b001: op_count[1] = op_count[1] + 1;
            3'b010: op_count[2] = op_count[2] + 1;
            3'b011: op_count[3] = op_count[3] + 1;
            3'b100: op_count[4] = op_count[4] + 1;

        endcase


        // A coverage
        if (A == 0)
            A_zero_count = A_zero_count + 1;

        else if (A <= 63)
            A_low_count = A_low_count + 1;

        else if (A <= 191)
            A_mid_count = A_mid_count + 1;

        else if (A <= 254)
            A_high_count = A_high_count + 1;

        else
            A_max_count = A_max_count + 1;


        // B coverage
        if (B == 0)
            B_zero_count = B_zero_count + 1;

        else if (B <= 63)
            B_low_count = B_low_count + 1;

        else if (B <= 191)
            B_mid_count = B_mid_count + 1;

        else if (B <= 254)
            B_high_count = B_high_count + 1;

        else
            B_max_count = B_max_count + 1;


        // Result coverage
        if (Y == 0)
            zero_result_count = zero_result_count + 1;
        else
            nonzero_result_count = nonzero_result_count + 1;


        // Carry coverage
        if (carry)
            carry_count = carry_count + 1;
        else
            no_carry_count = no_carry_count + 1;

    endtask


    //==================================================
    // Expected Result
    //==================================================

    task calculate_expected();

        expected_Y     = 8'h00;
        expected_carry = 1'b0;

        case(opcode)

            // ADD
            3'b000: begin
                {expected_carry, expected_Y} = A + B;
            end

            // SUB
            3'b001: begin
                expected_Y = A - B;
                expected_carry = (A < B);
            end

            // AND
            3'b010: begin
                expected_Y = A & B;
            end

            // OR
            3'b011: begin
                expected_Y = A | B;
            end

            // XOR
            3'b100: begin
                expected_Y = A ^ B;
            end

            default: begin
                expected_Y = 8'h00;
                expected_carry = 1'b0;
            end

        endcase

    endtask


    //==================================================
    // Initialize Counters
    //==================================================

    initial begin

        op_count[0] = 0;
        op_count[1] = 0;
        op_count[2] = 0;
        op_count[3] = 0;
        op_count[4] = 0;

        A_zero_count = 0;
        A_low_count  = 0;
        A_mid_count  = 0;
        A_high_count = 0;
        A_max_count  = 0;

        B_zero_count = 0;
        B_low_count  = 0;
        B_mid_count  = 0;
        B_high_count = 0;
        B_max_count  = 0;

        zero_result_count    = 0;
        nonzero_result_count = 0;

        carry_count    = 0;
        no_carry_count = 0;

    end


    //==================================================
    // Main Test
    //==================================================

    initial begin

        trans = new();

        $display("==========================================");
        $display("     ALU CONSTRAINED RANDOM TEST");
        $display("==========================================");


        repeat(1000) begin

            // Generate random transaction
            if (!trans.randomize()) begin

                $display("Randomization FAILED");
                $finish;

            end


            // Apply random values
            A      = trans.A;
            B      = trans.B;
            opcode = trans.opcode;

            #10;


            // Calculate expected result
            calculate_expected();


            // Update manual coverage
            update_coverage();


            //==================================================
            // Self Checking
            //==================================================

            if ((Y !== expected_Y) ||
                (carry !== expected_carry)) begin

                $display("------------------------------------------");
                $display("ERROR!");

                $display("A             = %0d", A);
                $display("B             = %0d", B);
                $display("Opcode        = %03b", opcode);

                $display("Expected Y    = %0d", expected_Y);
                $display("Actual Y      = %0d", Y);

                $display("Expected Carry = %b", expected_carry);
                $display("Actual Carry   = %b", carry);

            end

        end


        //==================================================
        // Coverage Report
        //==================================================

        $display("");
        $display("==========================================");
        $display("          ALU COVERAGE REPORT");
        $display("==========================================");


        // Opcode
        $display("");
        $display("OPCODE COVERAGE:");

        $display("ADD : %0d hits", op_count[0]);
        $display("SUB : %0d hits", op_count[1]);
        $display("AND : %0d hits", op_count[2]);
        $display("OR  : %0d hits", op_count[3]);
        $display("XOR : %0d hits", op_count[4]);


        // A
        $display("");
        $display("OPERAND A COVERAGE:");

        $display("ZERO : %0d", A_zero_count);
        $display("LOW  : %0d", A_low_count);
        $display("MID  : %0d", A_mid_count);
        $display("HIGH : %0d", A_high_count);
        $display("MAX  : %0d", A_max_count);


        // B
        $display("");
        $display("OPERAND B COVERAGE:");

        $display("ZERO : %0d", B_zero_count);
        $display("LOW  : %0d", B_low_count);
        $display("MID  : %0d", B_mid_count);
        $display("HIGH : %0d", B_high_count);
        $display("MAX  : %0d", B_max_count);


        // Result
        $display("");
        $display("RESULT COVERAGE:");

        $display("ZERO RESULT     : %0d",
                 zero_result_count);

        $display("NON-ZERO RESULT : %0d",
                 nonzero_result_count);


        // Carry
        $display("");
        $display("CARRY COVERAGE:");

        $display("CARRY    : %0d",
                 carry_count);

        $display("NO CARRY : %0d",
                 no_carry_count);


        //==================================================
        // Untested Scenario Analysis
        //==================================================

        $display("");
        $display("==========================================");
        $display("       UNTESTED SCENARIO ANALYSIS");
        $display("==========================================");


        if (op_count[0] == 0)
            $display("WARNING: ADD operation untested.");

        if (op_count[1] == 0)
            $display("WARNING: SUB operation untested.");

        if (op_count[2] == 0)
            $display("WARNING: AND operation untested.");

        if (op_count[3] == 0)
            $display("WARNING: OR operation untested.");

        if (op_count[4] == 0)
            $display("WARNING: XOR operation untested.");


        if (A_zero_count == 0)
            $display("WARNING: A = 0 untested.");

        if (A_max_count == 0)
            $display("WARNING: A = 255 untested.");


        if (B_zero_count == 0)
            $display("WARNING: B = 0 untested.");

        if (B_max_count == 0)
            $display("WARNING: B = 255 untested.");


        if (zero_result_count == 0)
            $display("WARNING: Zero result untested.");

        if (carry_count == 0)
            $display("WARNING: Carry/Borrow untested.");


        $display("==========================================");

        $finish;

    end

endmodule