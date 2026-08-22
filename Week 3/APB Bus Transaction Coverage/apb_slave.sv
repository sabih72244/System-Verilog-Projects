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

    logic [31:0] mem [0:255];

    integer i;

    always_ff @(posedge PCLK or negedge PRESETn) begin

        if (!PRESETn) begin

            PRDATA  <= 32'h00000000;
            PREADY  <= 1'b0;
            PSLVERR <= 1'b0;

            for (i = 0; i < 256; i = i + 1)
                mem[i] <= 32'h00000000;

        end
        else begin

            PREADY  <= 1'b0;
            PSLVERR <= 1'b0;

            // APB ACCESS phase
            if (PSEL && PENABLE) begin

                PREADY <= 1'b1;

                if (PWRITE) begin

                    mem[PADDR] <= PWDATA;

                end
                else begin

                    PRDATA <= mem[PADDR];

                end

            end

        end

    end

endmodule