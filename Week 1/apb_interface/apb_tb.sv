`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 08:11:31 PM
// Design Name: 
// Module Name: apb_tb
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
// File: apb_tb.sv
// Type: Simulation Source (Testbench)
// ============================================================================

class apb_driver;
  // Virtual interface handle for the testbench to drive the physical signals
  virtual apb_if vif;

  function new(virtual apb_if vif);
    this.vif = vif;
  endfunction

  // Write Task
  task write(logic [31:0] addr, logic [31:0] data);
    @(posedge vif.pclk);
    vif.paddr   <= addr;
    vif.pwrite  <= 1'b1;
    vif.psel    <= 1'b1;
    vif.pwdata  <= data;
    vif.penable <= 1'b0;

    @(posedge vif.pclk);
    vif.penable <= 1'b1;

    wait(vif.pready); // Wait for slave response
    
    @(posedge vif.pclk);
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
    $display("[%0t] [Master] Wrote Data: 0x%08h to Addr: 0x%08h", $time, data, addr);
  endtask

  // Read Task
  task read(logic [31:0] addr, output logic [31:0] data);
    @(posedge vif.pclk);
    vif.paddr   <= addr;
    vif.pwrite  <= 1'b0;
    vif.psel    <= 1'b1;
    vif.penable <= 1'b0;

    @(posedge vif.pclk);
    vif.penable <= 1'b1;

    wait(vif.pready); // Wait for slave response
    data = vif.prdata;

    @(posedge vif.pclk);
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
    $display("[%0t] [Master] Read  Data: 0x%08h from Addr: 0x%08h", $time, data, addr);
  endtask

  // Main Test Sequence
  task run();
    logic [31:0] read_data;
    
    vif.psel    <= 0;
    vif.penable <= 0;
    vif.pwrite  <= 0;
    vif.paddr   <= 0;
    vif.pwdata  <= 0;

    wait(vif.presetn === 1'b1);
    @(posedge vif.pclk);
    $display("\n[%0t] [Test] System Out of Reset. Starting Sequence...", $time);

    // Perform word-aligned accesses (multiples of 4)
    write(32'h0000_0000, 32'hAABBCCDD);
    write(32'h0000_0004, 32'h11223344);
    write(32'h0000_0008, 32'h55667788);
    
    read(32'h0000_0000, read_data);
    read(32'h0000_0004, read_data);
    read(32'h0000_0008, read_data);

    $display("[%0t] [Test] Simulation Complete.\n", $time);
  endtask
endclass

module tb_top;
  logic pclk;
  logic presetn;

  // 100MHz Clock Generator
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  // Reset Generator
  initial begin
    presetn = 0;
    #25;
    presetn = 1;
  end

  // Instantiate Interface
  apb_if intf(.pclk(pclk), .presetn(presetn));

  // Instantiate Synthesizable Slave
  apb_memory_slave slave_inst(
    .apb(intf.slave),
    .pclk(pclk),
    .presetn(presetn)
  );

  // Run Test
  initial begin
    apb_driver drv = new(intf);
    drv.run();
    #50 $finish;
  end
endmodule