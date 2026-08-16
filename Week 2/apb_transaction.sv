`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 10:13:47 PM
// Design Name: 
// Module Name: apb_transaction
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

class apb_transaction;

    rand bit        write;
    rand bit [7:0]  addr;
    rand bit [31:0] data;

    bit [31:0] rdata;

    constraint addr_range {
        addr inside {[0:60]};
        addr[1:0] == 2'b00;
    }

    function void display(string name);

        $display("[%s] WRITE=%0d ADDR=%0h WDATA=%0h RDATA=%0h",
                 name, write, addr, data, rdata);

    endfunction

endclass
