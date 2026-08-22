module alu(
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic [2:0] opcode,
    output logic [7:0] Y,
    output logic       carry
);
    always_comb begin
        Y     = 8'h00;
        carry = 1'b0;
        case (opcode)
            3'b000: begin      
                {carry, Y} = A + B;
            end
            3'b001: begin     
                Y = A - B;
                carry = (A < B);   
            end
            3'b010: begin       
                Y = A & B;
            end
            3'b011: begin       
                Y = A | B;
            end
            3'b100: begin      
                Y = A ^ B;
            end
            default: begin
                Y     = 8'h00;
                carry = 1'b0;
            end
        endcase
    end
endmodule