`timescale 1ns/1ps

`include "apb_transaction.sv"
`include "apb_generator.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_scoreboard.sv"
`include "apb_environment.sv"

module tb;

    logic PCLK;
    logic PRESETn;

    apb_if apb(PCLK, PRESETn);

    apb_slave dut (
        .PCLK    (PCLK),
        .PRESETn (PRESETn),
        .PSEL    (apb.PSEL),
        .PENABLE (apb.PENABLE),
        .PWRITE  (apb.PWRITE),
        .PADDR   (apb.PADDR),
        .PWDATA  (apb.PWDATA),
        .PRDATA  (apb.PRDATA),
        .PREADY  (apb.PREADY),
        .PSLVERR (apb.PSLVERR)
    );

    apb_environment env;

    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

    initial begin

        PRESETn = 0;

        apb.PSEL    = 0;
        apb.PENABLE = 0;
        apb.PWRITE  = 0;
        apb.PADDR   = 0;
        apb.PWDATA  = 0;

        repeat(2)
            @(posedge PCLK);

        PRESETn = 1;

        // WRITE 1
        @(posedge PCLK);
        apb.PSEL    <= 1;
        apb.PENABLE <= 0;
        apb.PWRITE  <= 1;
        apb.PADDR   <= 8'h00;
        apb.PWDATA  <= 32'h000000A5;

        @(posedge PCLK);
        apb.PENABLE <= 1;

        @(posedge PCLK);
        apb.PSEL    <= 0;
        apb.PENABLE <= 0;

        // WRITE 2
        @(posedge PCLK);
        apb.PSEL    <= 1;
        apb.PENABLE <= 0;
        apb.PWRITE  <= 1;
        apb.PADDR   <= 8'h08;
        apb.PWDATA  <= 32'h0000005A;

        @(posedge PCLK);
        apb.PENABLE <= 1;

        @(posedge PCLK);
        apb.PSEL    <= 0;
        apb.PENABLE <= 0;

        // READ 1
        @(posedge PCLK);
        apb.PSEL    <= 1;
        apb.PENABLE <= 0;
        apb.PWRITE  <= 0;
        apb.PADDR   <= 8'h00;

        @(posedge PCLK);
        apb.PENABLE <= 1;

        @(posedge PCLK);
        apb.PSEL    <= 0;
        apb.PENABLE <= 0;

        // READ 2
        @(posedge PCLK);
        apb.PSEL    <= 1;
        apb.PENABLE <= 0;
        apb.PWRITE  <= 0;
        apb.PADDR   <= 8'h08;

        @(posedge PCLK);
        apb.PENABLE <= 1;

        @(posedge PCLK);
        apb.PSEL    <= 0;
        apb.PENABLE <= 0;

        #50;

        $finish;

    end

endmodule