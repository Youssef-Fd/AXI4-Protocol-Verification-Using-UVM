`ifndef AXI_ENV_SV
  `define AXI_ENV_SV

    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_scoreboard.sv"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_agent.sv"
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_subscriber.sv"

    class axi_env extends uvm_test;
        
        `uvm_component_utils(axi_env)
        
        axi_agent     agent;
        axi_scoreboard scoreboard;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            scoreboard = axi_scoreboard::type_id::create("scoreboard", this);
            agent      = axi_agent::type_id::create("agent", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            agent.item_collected_port.connect(scoreboard.item_collected_export.analysis_export);
        endfunction

    endclass

`endif
