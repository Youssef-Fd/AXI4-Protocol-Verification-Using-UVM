`ifndef AXI_SEQ_ITEM_SV
  `define AXI_SEQ_ITEM_SV

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `ifndef AXI_ADDR_WIDTH
        `define AXI_ADDR_WIDTH 32
    `endif	

    `ifndef AXI_DATA_WIDTH
        `define AXI_DATA_WIDTH 32
    `endif

    `ifndef AXI_STRB_WIDTH
        `define AXI_STRB_WIDTH  (`AXI_DATA_WIDTH/8)
    `endif

    class axi_seq_item extends uvm_sequence_item;
        
        rand bit                       reset;

        rand bit                       write_en; 
        bit                            done_writing;  
        bit                            write_err;       
    
        rand bit [`AXI_ADDR_WIDTH-1:0] WRITE_ADDR;  
        rand bit [7:0]                 WRITE_BURST_LEN;

        //FIFO Read interface
        rand bit [`AXI_DATA_WIDTH-1:0] FIFO_RDATA;
        rand bit                       FIFO_EMPTY;
        bit                            FIFO_RD_EN;

        // AXI Write Address Channel
        bit [`AXI_ADDR_WIDTH-1:0]      AWADDR;
        bit [7:0]                      AWLEN;
        bit [2:0]                      AWSIZE;
        bit [1:0]                      AWBURST;
        bit                            AWVALID;
        rand bit                       AWREADY;

        // AXI Write Data Channel
        bit [`AXI_DATA_WIDTH-1:0]      WDATA;
        bit [`AXI_STRB_WIDTH-1:0]      WSTRB;
        bit                            WLAST;
        bit                            WVALID;
        rand bit                       WREADY;

        // AXI Write Response Channel
        rand bit [1:0]                 BRESP;
        rand bit                       BVALID;
        bit                            BREADY;

        rand bit                       read_en; 
        bit                            done_reading;  
        bit                            read_err;       
    
        rand bit [`AXI_ADDR_WIDTH-1:0] READ_ADDR;  
        rand bit [7:0]                 READ_BURST_LEN;

        // FIFO Write interface
        rand bit                       FIFO_FULL;
        bit [`AXI_DATA_WIDTH-1:0]      FIFO_WDATA;
        bit                            FIFO_WR_EN;

        // AXI Read Address Channel
        bit [`AXI_ADDR_WIDTH-1:0]      ARADDR;
        bit [7:0]                      ARLEN;
        bit [2:0]                      ARSIZE;
        bit [1:0]                      ARBURST;
        bit                            ARVALID;
        rand bit                       ARREADY;

        // AXI Read Data Channel
        rand bit [`AXI_DATA_WIDTH-1:0] RDATA;
        rand bit [`AXI_STRB_WIDTH-1:0] RSTRB;
        rand bit [1:0]                 RRESP;
        rand bit                       RLAST;
        rand bit                       RVALID;
        bit                            RREADY;

        constraint c_mode { write_en || read_en; }

        constraint c_wlen {
            WRITE_BURST_LEN dist {
                1        := 15,
                [2:4]    :/ 20,
                [5:16]   :/ 25,
                [17:64]  :/ 25,
                [65:255] :/ 15
            };
        }
        constraint c_rlen {
            READ_BURST_LEN dist {
                1        := 15,
                [2:4]    :/ 20,
                [5:16]   :/ 25,
                [17:64]  :/ 25,
                [65:255] :/ 15
            };
        }

        constraint c_waddr {
            WRITE_ADDR < 4096;
            WRITE_ADDR[1:0]  dist {2'b00 := 50, [1:3] :/ 50};
            WRITE_ADDR[11:2] dist {[0:255] :/ 50, [256:1023] :/ 50};
            (32'(WRITE_ADDR[11:0]) + (32'(WRITE_BURST_LEN) << 2)) <= 4096;
        }
        constraint c_raddr {
            READ_ADDR < 4096;
            READ_ADDR[1:0]  dist {2'b00 := 50, [1:3] :/ 50};
            READ_ADDR[11:2] dist {[0:255] :/ 50, [256:1023] :/ 50};
            (32'(READ_ADDR[11:0]) + (32'(READ_BURST_LEN) << 2)) <= 4096;
        }


        `uvm_object_utils_begin(axi_seq_item)
   
            `uvm_field_int(reset,UVM_ALL_ON)

            `uvm_field_int(WRITE_ADDR,UVM_ALL_ON)
            `uvm_field_int(WRITE_BURST_LEN,UVM_ALL_ON)

            `uvm_field_int(READ_ADDR,UVM_ALL_ON)
            `uvm_field_int(READ_BURST_LEN,UVM_ALL_ON)

            //WRITE ADDRESS BUS
            `uvm_field_int(AWADDR,UVM_ALL_ON)
            `uvm_field_int(AWLEN,UVM_ALL_ON)
            `uvm_field_int(AWSIZE,UVM_ALL_ON)
            `uvm_field_int(AWBURST,UVM_ALL_ON)
            `uvm_field_int(AWVALID,UVM_ALL_ON)
            `uvm_field_int(AWREADY,UVM_ALL_ON)

            //WRITE DATA BUS
            `uvm_field_int(WDATA,UVM_ALL_ON)
            `uvm_field_int(WSTRB,UVM_ALL_ON)
            `uvm_field_int(WLAST,UVM_ALL_ON)
            `uvm_field_int(WVALID,UVM_ALL_ON)
            `uvm_field_int(WREADY,UVM_ALL_ON)

            //WRITE RESPONSE BUS
            `uvm_field_int(BRESP,UVM_ALL_ON)
            `uvm_field_int(BVALID,UVM_ALL_ON)
            `uvm_field_int(BREADY,UVM_ALL_ON)

            //READ ADDRESS BUS
            `uvm_field_int(ARADDR,UVM_ALL_ON)
            `uvm_field_int(ARLEN,UVM_ALL_ON)
            `uvm_field_int(ARSIZE,UVM_ALL_ON)
            `uvm_field_int(ARBURST,UVM_ALL_ON)
            `uvm_field_int(ARVALID,UVM_ALL_ON)
            `uvm_field_int(ARREADY,UVM_ALL_ON)

            //READ DATA BUS
            `uvm_field_int(RDATA,UVM_ALL_ON)
            `uvm_field_int(RRESP,UVM_ALL_ON)
            `uvm_field_int(RLAST,UVM_ALL_ON)
            `uvm_field_int(RVALID,UVM_ALL_ON)
            `uvm_field_int(RREADY,UVM_ALL_ON)
        
        `uvm_object_utils_end

        function new(string name = "axi_seq_item");
            super.new(name);
        endfunction

    endclass
    
`endif
