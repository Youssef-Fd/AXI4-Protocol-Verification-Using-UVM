`ifndef AXI_DRIVER_SV
  `define AXI_DRIVER_SV

    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_if.sv"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_seq_item.sv"


    `define DRIV_IF vif.driver_cb

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class axi_driver extends uvm_driver #(axi_seq_item);
    
        `uvm_component_utils(axi_driver)
        virtual axi_if vif;

        axi_seq_item req;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal("NO_VIF", {"Virtual interface must be set for:", get_full_name(), ".vif"});
            end
        endfunction

        virtual task run_phase(uvm_phase phase);

            wait (vif.reset === 1'b0);
            forever begin
                req = axi_seq_item::type_id::create("req");
                seq_item_port.get_next_item(req);
                //`uvm_info("SEQ", $sformatf("sending burst: addr=0x%0h len=%0d", req.ADDR, req.WRITE_BURST_LEN), UVM_LOW)
                drive(req);
                seq_item_port.item_done();
            end

        endtask

        virtual task drive(axi_seq_item req);

            @(`DRIV_IF);

            `DRIV_IF.WRITE_ADDR       <= req.WRITE_ADDR;
            `DRIV_IF.WRITE_BURST_LEN  <= req.WRITE_BURST_LEN;

            `DRIV_IF.write_en  <= req.write_en;
            if(req.write_en) begin
                @(`DRIV_IF);
                while (!`DRIV_IF.done_writing) @(`DRIV_IF);
                `DRIV_IF.write_en <= 0;
            end

            `DRIV_IF.READ_ADDR       <= req.READ_ADDR;
            `DRIV_IF.READ_BURST_LEN  <= req.READ_BURST_LEN;

            `DRIV_IF.read_en  <= req.read_en;
            if(req.read_en) begin
                @(`DRIV_IF);
                while (!`DRIV_IF.done_reading) @(`DRIV_IF);
                `DRIV_IF.read_en <= 0;
            end

        endtask

    endclass

        
        /* 
    //===================================================//
    //                WRITE ADDREDS BUS                  //
    //===================================================//
    virtual task write_address(axi_seq_item transaction);

        `uvm_info("DRIVER - WRITE ADDRESS","", UVM_HIGH)
        @(posedge vif.clk);
        `DRIV_IF.WRITE_ADDR = transaction.WRITE_ADDR;
        `DRIV_IF.AWADDR     =     transaction.AWADDR;
        `DRIV_IF.AWLEN      =     transaction.AWLEN;
        `DRIV_IF.AWSIZE     =     transaction.AWSIZE;
        `DRIV_IF.AWBURST    =     transaction.AWBURST;
        `DRIV_IF.AWLOCK     =     transaction.AWLOCK;
        `DRIV_IF.AWCACHE    =     transaction.AWCACHE;
        `DRIV_IF.AWPROT     =     transaction.AWPROT;
        `DRIV_IF.AWVALID    =     transaction.AWVALID;

        if(req.write_en) begin
            @(`DRIV_IF);
            while (!`DRIV_IF.done) @(`DRIV_IF);
            `DRIV_IF.write_en <= 0;
        end

    endtask

    //===================================================//
    //                WRITE DATA BUS                     //
    //===================================================//
    int write_data_count;
    task write_data(axi_seq_item transaction);
    
        write_data_count <= 0;
        if(transaction.WRITE_ADDR[0]%4==0)      transaction.WSTRB <= 4'b1111;
        else if(transaction.WRITE_ADDR[0]%4==1) transaction.WSTRB <= 4'b0001;
        else if(transaction.WRITE_ADDR[0]%4==2) transaction.WSTRB <= 4'b0011;
        else if(transaction.WRITE_ADDR[0]%4==3) transaction.WSTRB <= 4'b0111;

        repeat(transaction.WRITE_BURST_LEN) begin
            @(posedge vif.clk);
            `uvm_info("DRIVER - WRITE DATA BUS","",UVM_HIGH);
            `DRIV_IF.WDATA      <=     transaction.WDATA[write_data_count];
            `DRIV_IF.WSTRB      <=     transaction.WSTRB;
            `DRIV_IF.WVALID     <=     transaction.WVALID;
            if(write_data_count == transaction.WRITE_BURST_LEN) begin
                `DRIV_IF.WLAST      <=     1;
            end
            else begin 
                `DRIV_IF.WLAST <= 0;
            end
            while(vif.WREADY == 0) begin
                @(posedge vif.clk);
            end
            write_data_count++;
            @(posedge vif.clk);
            `DRIV_IF.WVALID   <=     0;
            transaction.WSTRB <= 4'b1111;
        end
        `DRIV_IF.WDATA  <= 0;

    endtask

    //===================================================//
    //                WRITE RESPONSE BUS                 //
    //===================================================//
    task write_response(axi_seq_item transaction);

        `uvm_info("DRIVER - WRITE RESPONSE BUS","",UVM_HIGH);
        `DRIV_IF.BREADY  <=  transaction.BREADY;
        while(vif.bvalid==0) begin
            @(posedge vif.clk);
        end

    endtask
    */


`endif