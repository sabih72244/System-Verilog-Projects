`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 10:14:44 PM
// Design Name: 
// Module Name: apb_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

class apb_generator;

    mailbox #(apb_transaction) gen2drv;

    int num_transactions;

    function new(mailbox #(apb_transaction) gen2drv,
                 int num_transactions = 20);

        this.gen2drv = gen2drv;
        this.num_transactions = num_transactions;

    endfunction

    task run();

        apb_transaction tr;

        repeat(num_transactions) begin

            tr = new();

            if (!tr.randomize())
                $error("Randomization failed");

            gen2drv.put(tr);

            tr.display("GENERATOR");

        end

    endtask

endclass