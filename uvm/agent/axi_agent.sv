`ifndef AXI_AGENT_SV
  `define AXI_AGENT_SV

    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_seq_item.sv"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_sequence.sv"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_sequencer.sv"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_driver.sv"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_monitor.sv"

    class axi_agent extends uvm_agent;
        
        `uvm_component_utils(axi_agent)

        axi_driver    driver;
        axi_sequencer sequencer;
        axi_monitor   monitor;

        uvm_analysis_port#(axi_seq_item) item_collected_port;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            item_collected_port = new("item_collected_port", this);
        endfunction

        function void build_phase(uvm_phase phase);

            super.build_phase(phase);

            monitor  = axi_monitor::type_id::create("monitor", this);

            if(get_is_active() == UVM_ACTIVE) begin
                sequencer = axi_sequencer::type_id::create("sequencer", this);
                driver   = axi_driver::type_id::create("driver", this);
            end

        endfunction

        function void connect_phase(uvm_phase phase);

            monitor.item_collected_port.connect(item_collected_port);
            
            if(get_is_active() == UVM_ACTIVE) begin
                driver.seq_item_port.connect(sequencer.seq_item_export);
            end

        endfunction

    endclass

`endif    