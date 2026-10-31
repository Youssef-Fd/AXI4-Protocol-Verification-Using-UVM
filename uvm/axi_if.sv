`ifndef AXI_IF_SV
  `define AXI_IF_SV
  
    `ifndef AXI_ADDR_WIDTH
	    `define AXI_ADDR_WIDTH 32
    `endif	

    `ifndef AXI_DATA_WIDTH
	    `define AXI_DATA_WIDTH 32
    `endif

    `ifndef AXI_STRB_WIDTH
	    `define AXI_STRB_WIDTH  (`AXI_DATA_WIDTH/8)
    `endif	
	
    interface axi_if(input logic clk);
	    
		  logic                       reset;  
        
      logic                       write_en; 
      logic                       done_writing;  
      logic                       write_err;       

      logic [`AXI_ADDR_WIDTH-1:0] WRITE_ADDR;  
	    logic [7:0]                 WRITE_BURST_LEN;

      // FIFO interface
      logic [`AXI_DATA_WIDTH-1:0] FIFO_RDATA;
      logic                       FIFO_EMPTY;
      logic                       FIFO_RD_EN;

      // AXI Write Address Channel
      logic [`AXI_ADDR_WIDTH-1:0] AWADDR;
      logic [7:0]                 AWLEN;
      logic [2:0]                 AWSIZE;
      logic [1:0]                 AWBURST;
      logic                       AWVALID;
      logic                       AWREADY;

      // AXI Write Data Channel
      logic [`AXI_DATA_WIDTH-1:0] WDATA;
      logic [`AXI_STRB_WIDTH-1:0] WSTRB;
      logic                       WLAST;
      logic                       WVALID;
      logic                       WREADY;

      // AXI Write Response Channel
      logic [1:0]                 BRESP;
      logic                       BVALID;
      logic                       BREADY;
      
      //READ channels
      logic                       read_en; 
      logic                       done_reading;  
      logic                       read_err;       

      logic [`AXI_ADDR_WIDTH-1:0] READ_ADDR;  
      logic [7:0]                 READ_BURST_LEN;

      // FIFO interface
      logic [`AXI_DATA_WIDTH-1:0] FIFO_WDATA; //OUTPUT
      logic                       FIFO_WR_EN; //OUTPUT
      logic                       FIFO_FULL;  //INPUT


      // AXI Read Address Channel
      logic [`AXI_ADDR_WIDTH-1:0] ARADDR;
      logic [7:0]                 ARLEN;
      logic [2:0]                 ARSIZE;
      logic [1:0]                 ARBURST;
      logic                       ARVALID;
      logic                       ARREADY;

      // AXI Read Data Channel
      logic [`AXI_DATA_WIDTH-1:0] RDATA;
      logic [1:0]                 RRESP;
      logic                       RLAST;
      logic                       RVALID;
      logic                       RREADY;


    // clocking driver_cb@(posedge clk);
       
    //   //WRITE ADDRESS BUS
    //   input WRITE_ADDR, WRITE_BURST_LEN, write_en, AWREADY;
    //   output done_writing, write_err, AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
      
    //   //FIFO READ INTERFACE
    //   input FIFO_EMPTY,FIFO_RDATA;
    //   output FIFO_RD_EN; 

    //   //WRITE DATA BUS
    //   input WREADY;
    //   output WDATA,WSTRB,WLAST,WVALID;
      
    //   //WRITE RESPONSE BUS
    //   input BRESP,BVALID;
    //   output BREADY;
      
    //   //FIFO WRITE INTERFACE
    //   input FIFO_FULL;
    //   output FIFO_WR_EN, FIFO_WDATA; 

    //   //READ ADDRESS BUS
    //   input  READ_ADDR, READ_BURST_LEN, read_en, ARREADY;
    //   output done_reading, read_err, ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
       
    //   //READ DATA BUS
    //   input RDATA,RRESP,RLAST,RVALID;
    //   output RREADY;

    // endclocking

    clocking driver_cb @(posedge clk);

      // Commands from the UVM driver to the masters
      output write_en, WRITE_ADDR, WRITE_BURST_LEN;
      output read_en,  READ_ADDR,  READ_BURST_LEN;

      // Everything else is observed only
      input done_writing, write_err, done_reading, read_err;
      input AWREADY, ARREADY, WREADY, BRESP, BVALID;
      input RDATA, RRESP, RLAST, RVALID;
      input FIFO_EMPTY, FIFO_FULL, FIFO_RDATA;
      
   endclocking

    modport driver_mp(clocking driver_cb,input clk,reset);

    clocking monitor_cb@(posedge clk);

      //default input #9;
       
      //WRITE ADDRESS BUS
      input write_en, AWREADY;
      input done_writing, write_err, AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;

      //WRITE DATA BUS
      input WREADY;
      input WDATA,WSTRB,WLAST,WVALID;
       
      //WRITE RESPONSE BUS
      input BRESP,BVALID;
      input BREADY;

      //READ ADDRESS BUS
      input read_en, ARREADY;
      input done_reading, read_err, ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
       
      //READ DATA BUS
      input RDATA, RRESP,RLAST,RVALID;
      input RREADY;

    endclocking

    modport monitor_mp(clocking monitor_cb,input clk,reset);

  endinterface


`endif
