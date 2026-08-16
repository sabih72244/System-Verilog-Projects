`timescale 1ns/1ps

interface apb_if(input logic PCLK, input logic PRESETn);

    logic        PSEL;
    logic        PENABLE;
    logic        PWRITE;
    logic [7:0]  PADDR;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;
    logic        PREADY;
    logic        PSLVERR;

    modport master (
        input PCLK,
        input PRESETn,
        output PSEL,
        output PENABLE,
        output PWRITE,
        output PADDR,
        output PWDATA,
        input PRDATA,
        input PREADY,
        input PSLVERR
    );

    modport slave (
        input PCLK,
        input PRESETn,
        input PSEL,
        input PENABLE,
        input PWRITE,
        input PADDR,
        input PWDATA,
        output PRDATA,
        output PREADY,
        output PSLVERR
    );

endinterface