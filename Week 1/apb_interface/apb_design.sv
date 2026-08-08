`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 08:10:11 PM
// Design Name: 
// Module Name: apb_design
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
// ============================================================================
// File: apb_design.sv
// Type: Design Source (Synthesizable RTL)
// ============================================================================

// APB Interface Definition
interface apb_if #(parameter ADDR_WIDTH = 32, parameter DATA_WIDTH = 32) (
  input logic pclk,
  input logic presetn
);
  logic [ADDR_WIDTH-1:0] paddr;
  logic                  psel;
  logic                  penable;
  logic                  pwrite;
  logic [DATA_WIDTH-1:0] pwdata;
  logic                  pready;
  logic [DATA_WIDTH-1:0] prdata;
  logic                  pslverr;

  // Master Modport
  modport master (
    output paddr, psel, penable, pwrite, pwdata,
    input  pready, prdata, pslverr
  );

  // Slave Modport
  modport slave (
    input  paddr, psel, penable, pwrite, pwdata,
    output pready, prdata, pslverr
  );
endinterface

// APB Slave Module
module apb_memory_slave #(
  parameter ADDR_WIDTH = 32, 
  parameter DATA_WIDTH = 32
)(
  apb_if.slave apb,  // Connected using the slave modport
  input logic pclk,
  input logic presetn
);

  // Synthesizable memory array: 16 words of 32 bits
  logic [DATA_WIDTH-1:0] mem [0:15];
  logic [3:0] local_addr;
  
  // Extract word-aligned address (bits 5 to 2)
  assign local_addr = apb.paddr[5:2]; 

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      apb.pready  <= 1'b0;
      apb.prdata  <= '0;
      apb.pslverr <= 1'b0;
      // Initialize memory to zero
      for (int i = 0; i < 16; i++) begin
        mem[i] <= 32'h0;
      end
    end else begin
      // Default state
      apb.pready  <= 1'b0;
      apb.pslverr <= 1'b0;
      
      // SETUP Phase
      if (apb.psel && !apb.penable) begin
        apb.pready <= 1'b1; 
      end 
      // ACCESS Phase
      else if (apb.psel && apb.penable && apb.pready) begin
        if (apb.pwrite) begin
          mem[local_addr] <= apb.pwdata; // Write
        end else begin
          apb.prdata <= mem[local_addr]; // Read
        end
        apb.pready <= 1'b0; // End transaction
      end
    end
  end
endmodule