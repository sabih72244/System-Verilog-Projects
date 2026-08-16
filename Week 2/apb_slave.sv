`timescale 1ns/1ps

module apb_slave(
    input  logic        PCLK,
    input  logic        PRESETn,

    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic        PWRITE,
    input  logic [7:0]  PADDR,
    input  logic [31:0] PWDATA,

    output logic [31:0] PRDATA,
    output logic        PREADY,
    output logic        PSLVERR
);

    logic [31:0] mem [0:15];

    assign PREADY  = 1'b1;
    assign PSLVERR = 1'b0;

    always_ff @(posedge PCLK or negedge PRESETn) begin

        if (!PRESETn) begin

            PRDATA <= 32'b0;

            for (int i = 0; i < 16; i = i + 1)
                mem[i] <= 32'b0;

        end
        else begin

            if (PSEL && PENABLE) begin

                if (PWRITE) begin
                    mem[PADDR[5:2]] <= PWDATA;
                end

                else begin
                    PRDATA <= mem[PADDR[5:2]];
                end

            end

        end

    end

endmodule