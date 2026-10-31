// Code your testbench here

`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_if.sv"
`include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_seq_item.sv"
`include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_subscriber.sv"
`include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_test.sv"
`include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_write_master.sv"
`include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_read_master.sv"
`include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_slave_memory.sv"
`include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/FIFO.sv"


module testbench();

  //clock signal
  reg clk;

  initial clk = 0;

  //--------------------------------------------------------------
  // Interface instances
  //--------------------------------------------------------------
  axi_if  vif(clk);

  //clock generator
  always #5 clk = ~clk;
  
  
  initial begin
    vif.reset = 1;
    repeat (4) @(posedge clk);
    vif.reset = 0;
  end
 
  axi_write_master #(
    .ADDR_WIDTH(32),
    .DATA_WIDTH(32),
    .STRB_WIDTH(`AXI_STRB_WIDTH)
  )dut_write(
    .clk     (clk),
    .rst     (vif.reset),
	
	  .write_en   (vif.write_en),
    .done       (vif.done_writing),
    .write_err  (vif.write_err),
    .ADDR       (vif.WRITE_ADDR),
    .BURST_LEN  (vif.WRITE_BURST_LEN),
 
    .FIFO_RDATA (vif.FIFO_RDATA),
    .FIFO_EMPTY (vif.FIFO_EMPTY),
    .FIFO_RD_EN (vif.FIFO_RD_EN),
	
	  .AWADDR (vif.AWADDR),
    .AWLEN  (vif.AWLEN),
    .AWSIZE (vif.AWSIZE),
    .AWBURST(vif.AWBURST),
    .AWVALID(vif.AWVALID),
    .AWREADY(vif.AWREADY),

    .WDATA (vif.WDATA),
    .WSTRB (vif.WSTRB),
    .WLAST (vif.WLAST),
    .WVALID(vif.WVALID),
    .WREADY(vif.WREADY),

    .BRESP (vif.BRESP),
    .BVALID(vif.BVALID),
    .BREADY(vif.BREADY)
  );


  axi_read_master #(
    .ADDR_WIDTH(`AXI_ADDR_WIDTH),
    .DATA_WIDTH(`AXI_DATA_WIDTH),
    .STRB_WIDTH(`AXI_STRB_WIDTH)
  )dut_read(
    .clk        (clk),
    .rst        (vif.reset),

    .read_en    (vif.read_en),
    .done       (vif.done_reading),
    .read_err   (vif.read_err),
    .ADDR       (vif.READ_ADDR),
    .BURST_LEN  (vif.READ_BURST_LEN),

    .FIFO_WDATA (vif.FIFO_WDATA),
    .FIFO_WR_EN (vif.FIFO_WR_EN),
    .FIFO_FULL  (vif.FIFO_FULL),

    .ARADDR     (vif.ARADDR),
    .ARLEN      (vif.ARLEN),
    .ARSIZE     (vif.ARSIZE),
    .ARBURST    (vif.ARBURST),
    .ARVALID    (vif.ARVALID),
    .ARREADY    (vif.ARREADY),

    .RDATA      (vif.RDATA),
    .RRESP      (vif.RRESP),
    .RLAST      (vif.RLAST),
    .RVALID     (vif.RVALID),
    .RREADY     (vif.RREADY)
  );
  
  axi_slave_memory #(
    .ADDR_WIDTH(32),
    .DATA_WIDTH(32),
    .MEM_DEPTH(1024)
  ) slave (
    .clk     (clk),
    .rst     (vif.reset),
    
    // Read Address Channel
    .ARADDR  (vif.ARADDR),
    .ARLEN   (vif.ARLEN),
    .ARSIZE  (vif.ARSIZE),
    .ARBURST (vif.ARBURST),
    .ARVALID (vif.ARVALID),
    .ARREADY (vif.ARREADY),

    // Read Data Channel
    .RDATA   (vif.RDATA),
    .RRESP   (vif.RRESP),
    .RLAST   (vif.RLAST),
    .RVALID  (vif.RVALID),
    .RREADY  (vif.RREADY),

    // Write Address Channel
    .AWADDR  (vif.AWADDR),
    .AWLEN   (vif.AWLEN),
    .AWSIZE  (vif.AWSIZE),
    .AWBURST (vif.AWBURST),
    .AWVALID (vif.AWVALID),
    .AWREADY (vif.AWREADY),

    // Write Data Channel
    .WDATA   (vif.WDATA),
    .WSTRB   (vif.WSTRB),
    .WLAST   (vif.WLAST),
    .WVALID  (vif.WVALID),
    .WREADY  (vif.WREADY),

    // Write Response Channel
    .BRESP   (vif.BRESP),
    .BVALID  (vif.BVALID),
    .BREADY  (vif.BREADY)
  );
  
  logic [`AXI_DATA_WIDTH-1:0] pre_wdata;
  logic                       pre_wr_en;
  logic                       use_pre;   // 1 = testbench preload, 0 = read master

  wire [`AXI_DATA_WIDTH-1:0] fifo_wdata_mux = use_pre ? pre_wdata : vif.FIFO_WDATA;
  wire                       fifo_wr_en_mux = use_pre ? pre_wr_en : vif.FIFO_WR_EN;

  fifo #(
    .WIDTH(32),
    .DEPTH(256)
  ) u_fifo (
    .clk     (vif.clk),
    .rst     (vif.reset),
    .wdata   (fifo_wdata_mux),   // was vif.FIFO_WDATA
    .wr_en   (fifo_wr_en_mux),   // was vif.FIFO_WR_EN
    .full_o  (vif.FIFO_FULL),
    .rdata   (vif.FIFO_RDATA),
    .rd_en   (vif.FIFO_RD_EN),
    .empty_o (vif.FIFO_EMPTY)
  );

  task automatic fifo_write(input logic [`AXI_DATA_WIDTH-1:0] data);
    @(negedge clk);
    pre_wdata = data;
    pre_wr_en = 1'b1;
    @(negedge clk);
    pre_wr_en = 1'b0;
  endtask

  initial begin
    use_pre   = 1'b1;
    pre_wr_en = 1'b0;
    pre_wdata = '0;

    // Wait for reset to release, otherwise the FIFO ignores these writes
    @(negedge vif.reset);

    fifo_write(32'h0000_00FF);
    fifo_write(32'h0000_0001);
    fifo_write(32'h0000_0002);
    fifo_write(32'h0000_0003);
    fifo_write(32'h0000_0004);
    fifo_write(32'h0000_0005);
    fifo_write(32'h0000_0006);
    fifo_write(32'h0000_0007);
    fifo_write(32'h0000_0008);
    fifo_write(32'h0000_0009);
    fifo_write(32'h0000_000A);
    fifo_write(32'h0000_000B);
    fifo_write(32'h0000_000C);
    fifo_write(32'h0000_000D);
    fifo_write(32'h0000_000E);
    fifo_write(32'h0000_000F);

    use_pre = 1'b0;   // hand the FIFO back to the read master
  end

  initial begin

    $dumpfile("dump.vcd");
    $dumpvars;

    uvm_config_db#(virtual axi_if)::set(null, "*agent*", "vif", vif);
    uvm_config_db#(virtual axi_if)::set(null, "test_case_2.env.agent*", "vif", vif);

    run_test("test_case_2");

  end



endmodule
