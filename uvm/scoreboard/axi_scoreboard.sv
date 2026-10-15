`ifndef AXI_SCOREBOARD_SV
  `define AXI_SCOREBOARD_SV

    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_seq_item.sv"

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class axi_scoreboard extends uvm_scoreboard;

        `uvm_component_utils(axi_scoreboard)
        uvm_tlm_analysis_fifo #(axi_seq_item) item_collected_export;

        axi_seq_item trans;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            item_collected_export = new("item_collected_export", this);
        endfunction

        bit [31:0]wmem_data[$];
        bit [31:0]wmem_addr[$];
        bit [31:0]rmem_data[$];
        bit [31:0]rmem_addr[$];

        task run_phase(uvm_phase phase);

            forever begin

                wmem_addr.delete();
                rmem_addr.delete();
                wmem_data.delete();
                rmem_data.delete();
                item_collected_export.get(trans);
                `uvm_info("SCOREBOARD-PACKETS RECIEVED",$sformatf("%p,%p", trans.WDATA, trans.RDATA), UVM_HIGH);
        
                for(int i=0;i<=trans.AWLEN;i++) begin
                    if(trans.WSTRB==4'b1111)
                    wmem_data[i] = trans.WDATA[i];
                    else if(trans.WSTRB==4'b0111)
                    wmem_data[i][23:0] = trans.WDATA[23:0]; //trans.WDATA[i][23:0];
                    else if(trans.WSTRB==4'b0011)
                    wmem_data[i][15:0] = trans.WDATA[15:0]; //trans.WDATA[i][15:0];
                    else if(trans.WSTRB==4'b0001)
                    wmem_data[i][7:0] = trans.WDATA[7:0];  //trans.WDATA[i][7:0];
                end

                for(int i=0;i<=trans.ARLEN;i++) begin
                    rmem_data[i] = trans.RDATA[i];
                end

                for(int i=0;i<=trans.AWLEN;i++) begin
                    wmem_addr[i] = trans.AWADDR[i];
                end

                for(int i=0;i<=trans.ARLEN;i++) begin
                    rmem_addr[i] = trans.ARADDR[i];
                end

                        
                for(int i=0;i<=rmem_addr.size;i++) begin//1
                for(int j=0;j<wmem_addr.size;j++) begin//2
                    if(rmem_addr[i]==wmem_addr[j]) begin//3
                        `uvm_info("*** SCOREBOARD SAMPLED ***","",UVM_NONE);
                        if(rmem_data[i]==wmem_data[j]) begin//4
                            `uvm_info("*** SCOREBOARD  PASS ***","",UVM_NONE);
                            `uvm_info("DATA CHECK",$sformatf("\nwmem_data == %h\n", wmem_data[j]), UVM_HIGH);
                            `uvm_info("DATA CHECK",$sformatf("\nrmem_data == %h\n", rmem_data[i]), UVM_HIGH);
                            `uvm_info("ADDR CHECK",$sformatf("\nwmem_addr == %h\n", wmem_addr[j]), UVM_HIGH);
                            `uvm_info("ADDR CHECK",$sformatf("\nrmem_addr == %h\n", rmem_addr[i]), UVM_HIGH);
                        end//4
                        else begin//5
                            `uvm_error("DATA CHECK",$sformatf("wmem_data == %h", wmem_data[j]));
                            `uvm_error("DATA CHECK",$sformatf("rmem_data == %h", rmem_data[i]));
                            `uvm_error("DATA CHECK",$sformatf("wmem_addr == %h", wmem_addr[j]));
                            `uvm_error("DATA CHECK",$sformatf("rmem_addr == %h", rmem_addr[i]));
                            `uvm_info("** SCOREBOARD FAIL **","",UVM_NONE);
                        end//5
                    end//3
                    else continue;
                    end//2
                end//1
            end 

        endtask

    endclass

`endif