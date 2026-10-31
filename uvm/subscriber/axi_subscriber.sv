`ifndef AXI_COVERAGE_SV
  `define AXI_COVERAGE_SV

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_seq_item.sv"

    class axi_coverage extends uvm_subscriber #(axi_seq_item);

        `uvm_component_utils(axi_coverage)

        axi_seq_item trans;          
        bit          is_write;

        //------------------------------------------------------------------
        // WRITE coverage
        //------------------------------------------------------------------
        covergroup write_cg;
        option.per_instance = 1;
        option.name         = "write_cg";

        cp_awlen: coverpoint trans.AWLEN {
            bins single      = {0};
            bins short_burst = {[1:3]};
            bins med_burst   = {[4:15]};
            bins long_burst  = {[16:63]};
            bins max_burst   = {[64:255]};
        }

        cp_awsize: coverpoint trans.AWSIZE {
            bins byte_4 = {2};
            ignore_bins unsupported = {[0:1], [3:7]};
        }

        cp_awburst: coverpoint trans.AWBURST {
            bins incr = {2'b01};
            ignore_bins unsupported = {2'b00, 2'b10};
            illegal_bins reserved   = {2'b11};
        }

        cp_awaddr_align: coverpoint trans.AWADDR[1:0] {
            bins aligned   = {2'b00};
            bins unaligned = {[1:3]};
        }

        cp_awaddr_region: coverpoint trans.AWADDR[11:2] {
            bins low  = {[0:255]};
            bins high = {[256:1023]};
        }

        // Burst would cross a 4 KB boundary (illegal in AXI)
        cp_4k_cross: coverpoint ((trans.AWADDR[11:0] + ((trans.AWLEN + 1) << trans.AWSIZE)) > 13'h1000) {
            bins no_cross = {0};
            ignore_bins  cross_4k = {1};
        }
        
        cp_wdata: coverpoint trans.WDATA {
            bins zeros    = {32'h0000_0000};
            bins ones     = {32'hFFFF_FFFF};
            bins low_half = {[32'h0000_0001:32'h0000_FFFF]};
            bins others   = default;
        }

        cp_wstrb: coverpoint trans.WSTRB {
            bins full = {4'b1111};
            ignore_bins unsupported = {[4'b0000:4'b1110]};
        }

        cp_bresp: coverpoint trans.BRESP {
            bins okay = {2'b00};
            ignore_bins unsupported = {2'b01, 2'b10, 2'b11};
        }

        cx_len_x_size : cross cp_awlen, cp_awsize;
        cx_len_x_burst: cross cp_awlen, cp_awburst;
        cx_len_x_resp : cross cp_awlen, cp_bresp;
        endgroup

        //------------------------------------------------------------------
        // READ coverage
        //------------------------------------------------------------------
        covergroup read_cg;
        option.per_instance = 1;
        option.name         = "read_cg";

        cp_arlen: coverpoint trans.ARLEN {
            bins single      = {0};
            bins short_burst = {[1:3]};
            bins med_burst   = {[4:15]};
            bins long_burst  = {[16:63]};
            bins max_burst   = {[64:255]};
        }

        cp_arsize: coverpoint trans.ARSIZE {
            bins byte_1 = {0};
            bins byte_2 = {1};
            bins byte_4 = {2};
            ignore_bins wider = {[3:7]};
        }

        cp_arburst: coverpoint trans.ARBURST {
            bins fixed = {2'b00};
            bins incr  = {2'b01};
            bins wrap  = {2'b10};
            illegal_bins reserved = {2'b11};
        }

        cp_araddr_align: coverpoint trans.ARADDR[1:0] {
            bins aligned   = {2'b00};
            bins unaligned = {[1:3]};
        }

        cp_araddr_region: coverpoint trans.ARADDR[11:2] {
            bins low  = {[0:255]};
            bins high = {[256:1023]};
        }

        cp_4k_cross: coverpoint ((trans.ARADDR[11:0] + ((trans.ARLEN + 1) << trans.ARSIZE)) > 13'h1000) {
            bins no_cross = {0};
            bins cross_4k = {1};
        }

        cp_rdata: coverpoint trans.RDATA {
            bins zeros    = {32'h0000_0000};
            bins ones     = {32'hFFFF_FFFF};
            bins low_half = {[32'h0000_0001:32'h0000_FFFF]};
            bins others   = default;
        }

        cp_rresp: coverpoint trans.RRESP {
            bins okay = {2'b00};
            ignore_bins unsupported = {2'b01, 2'b10, 2'b11};
        }

        cx_len_x_size : cross cp_arlen, cp_arsize;
        cx_len_x_burst: cross cp_arlen, cp_arburst;
        cx_len_x_resp : cross cp_arlen, cp_rresp;
        endgroup

        //------------------------------------------------------------------
        function new(string name, uvm_component parent);
            super.new(name, parent);
            write_cg = new();
            read_cg  = new();
        endfunction

        // Called by the monitor's analysis port for every collected transaction
        function void write(axi_seq_item t);
            trans = t;
            // The monitor sets write_en=1 on write items, read items leave it 0
            is_write = t.write_en;

            if (is_write) 
                write_cg.sample();
            else          
                read_cg.sample();

        endfunction

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("COV", $sformatf("Write coverage = %0.2f%%", write_cg.get_coverage()), UVM_NONE)
            `uvm_info("COV", $sformatf("Read  coverage = %0.2f%%", read_cg.get_coverage()),  UVM_NONE)
        endfunction

    endclass

`endif
