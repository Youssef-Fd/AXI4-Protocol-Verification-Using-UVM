`ifndef AXI_SEQUENCER_SV
  `define AXI_SEQUENCER_SV

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_seq_item.sv"

    class axi_sequencer extends uvm_sequencer #(axi_seq_item);

        `uvm_component_utils(axi_sequencer)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

    endclass

`endif