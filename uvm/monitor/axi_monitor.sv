`ifndef AXI_MONITOR_SV
  `define AXI_MONITOR_SV

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_if.sv"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_seq_item.sv"

    class axi_monitor extends uvm_monitor;
        
        `uvm_component_utils(axi_monitor)

        virtual axi_if vif;
        uvm_analysis_port #(axi_seq_item) item_collected_port;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            item_collected_port   = new("item_collected_port", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal("NO_VIF", {"Virtual interface must be set for:", get_full_name(), ".vif"});
            end
            `uvm_info("MON_DBG", $sformatf("vif get OK, vif=%0s", (vif == null) ? "null" : "valid"), UVM_NONE)
        endfunction


        task run_phase(uvm_phase phase);
          
           super.run_phase(phase);

            forever begin
                // Wait for reset release
                while (vif.reset !== 1'b0) @(posedge vif.clk); //wait (vif.resest === 0);

                fork : monitor_threads
                    begin
                        fork
                            collect_write_data();
                            collect_read_data();
                        join
                    end
                    begin
                        while (vif.reset !== 1'b1) @(posedge vif.clk); //wait (vif.reset === 1);
                    end
                join_any

                // Kill the collection on reset
                disable monitor_threads;
                `uvm_info("MASTER_MONITOR","Reset detected: Collection threads terminated safely",UVM_HIGH)
            end

        endtask

        //--------------------------------------------------------------------------
        // WRITE TRANSACTION COLLECTION
        //--------------------------------------------------------------------------
        task collect_write_data();

            forever begin
                axi_seq_item xtn = axi_seq_item::type_id::create("xtn", this);

                // ---------------- AW ----------------
                do @(vif.monitor_cb);
                while (!(vif.monitor_cb.AWVALID && vif.monitor_cb.AWREADY));

                xtn.write_en = 1;

                xtn.AWADDR  = vif.monitor_cb.AWADDR;
                xtn.AWLEN   = vif.monitor_cb.AWLEN;
                xtn.AWSIZE  = vif.monitor_cb.AWSIZE;
                xtn.AWBURST = vif.monitor_cb.AWBURST;

                xtn.WDATA = 0;
                xtn.WSTRB = 0;

                // ---------------- W ----------------
                for (int i = 0; i <= xtn.AWLEN; i++) begin
                    do @(vif.monitor_cb);
                    while (!(vif.monitor_cb.WVALID && vif.monitor_cb.WREADY));

                    //xtn.WDATA.push_back(vif.monitor_cb.WDATA);
                    //xtn.WSTRB.push_back(vif.monitor_cb.WSTRB);

                    xtn.WDATA = vif.monitor_cb.WDATA;
                    xtn.WSTRB = vif.monitor_cb.WSTRB;

                    if (i != xtn.AWLEN && vif.monitor_cb.WLAST)
                        `uvm_error("MASTER_MON_WRITE", "WLAST asserted early")

                    if (i == xtn.AWLEN && !vif.monitor_cb.WLAST)
                        `uvm_error("MASTER_MON_WRITE", "WLAST missing on final beat")
                end

                // ---------------- B ----------------
                do @(vif.monitor_cb);
                while (!(vif.monitor_cb.BVALID && vif.monitor_cb.BREADY));

                xtn.BRESP = vif.monitor_cb.BRESP;

                item_collected_port.write(xtn);
            end

        endtask

        //--------------------------------------------------------------------------
        // READ TRANSACTION COLLECTION
        //--------------------------------------------------------------------------
        task collect_read_data();

            forever begin

                axi_seq_item xtn = axi_seq_item::type_id::create("xtn", this);

                // ---------------- AR ----------------
                do @(vif.monitor_cb);
                while (!(vif.monitor_cb.ARVALID && vif.monitor_cb.ARREADY));

                xtn.read_en = 0;

                xtn.ARADDR  = vif.monitor_cb.ARADDR;
                xtn.ARLEN   = vif.monitor_cb.ARLEN;
                xtn.ARSIZE  = vif.monitor_cb.ARSIZE;
                xtn.ARBURST = vif.monitor_cb.ARBURST;

                // ---------------- R ----------------
                for (int i = 0; i <= xtn.ARLEN; i++) begin
                    do @(vif.monitor_cb);
                    while (!(vif.monitor_cb.RVALID && vif.monitor_cb.RREADY));

                    //xtn.RDATA.push_back(vif.monitor_cb.RDATA);
                    xtn.RDATA = vif.monitor_cb.RDATA;
                    xtn.RRESP = vif.monitor_cb.RRESP;

                    if (i != xtn.ARLEN && vif.monitor_cb.RLAST)
                        `uvm_error("MASTER_MON_READ", "RLAST asserted early")

                    if (i == xtn.ARLEN && !vif.monitor_cb.RLAST)
                        `uvm_error("MASTER_MON_READ", "RLAST missing on final beat")
                end

                item_collected_port.write(xtn);
            end

        endtask

    endclass

`endif