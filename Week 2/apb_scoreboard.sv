`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 10:18:13 PM
// Design Name: 
// Module Name: apb_scoreboard
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
class apb_scoreboard;

    mailbox #(apb_transaction) mon2scb;

    bit [31:0] model [0:15];

    int pass_count;
    int fail_count;

    function new(mailbox #(apb_transaction) mon2scb);

        this.mon2scb = mon2scb;

        pass_count = 0;
        fail_count = 0;

        for (int i = 0; i < 16; i++)
            model[i] = 32'b0;

    endfunction

    task run();

        apb_transaction tr;

        forever begin

            mon2scb.get(tr);

            if (tr.write) begin

                model[tr.addr[5:2]] = tr.data;

                $display("[SCOREBOARD] WRITE PASS: ADDR=%0h DATA=%0h",
                         tr.addr, tr.data);

                pass_count++;

            end
            else begin

                if (tr.rdata == model[tr.addr[5:2]]) begin

                    $display("[SCOREBOARD] READ PASS: ADDR=%0h DATA=%0h",
                             tr.addr, tr.rdata);

                    pass_count++;

                end
                else begin

                    $display("[SCOREBOARD] READ FAIL: ADDR=%0h EXPECTED=%0h ACTUAL=%0h",
                             tr.addr,
                             model[tr.addr[5:2]],
                             tr.rdata);

                    fail_count++;

                end

            end

        end

    endtask

endclass