`ifndef AXI_TEST_SV
  `define AXI_TEST_SV

    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_env.sv"

    class axi_test extends uvm_test;
        
        `uvm_component_utils(axi_test)

        axi_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = axi_env::type_id::create("env", this);
        endfunction

        function void end_of_elaboration_phase(uvm_phase phase);
            uvm_top.print_topology();
        endfunction

    endclass

    //===================================================//
    //                TEST CASE 1                        //
    //===================================================//
    class test_case_1 extends axi_test;

        `uvm_component_utils(test_case_1)

        function new(string name="test_case_1", uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);

            sequence_1 seq;
            phase.raise_objection(this);
            seq = sequence_1::type_id::create("seq",this);
            seq.start(env.agent.sequencer);
          #100;
            phase.drop_objection(this);
            
        endtask

    endclass


    //===================================================//
    //                TEST CASE 2                        //
    //===================================================//
    class test_case_2 extends axi_test;

        `uvm_component_utils(test_case_2)

        function new(string name="test_case_2", uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);

            sequence_2 seq;
            phase.raise_objection(this);
            seq = sequence_2::type_id::create("seq",this);
            seq.start(env.agent.sequencer);
            #100;
            phase.drop_objection(this);

        endtask

    endclass


    //===================================================//
    //                TEST CASE 3                        //
    //===================================================//
    class test_case_3 extends axi_test;

        `uvm_component_utils(test_case_3)

        function new(string name="test_case_3", uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);

            sequence_3 seq;
            phase.raise_objection(this);
            seq = sequence_3::type_id::create("seq",this);
            seq.start(env.agent.sequencer);
            #100;
            phase.drop_objection(this);

        endtask

    endclass


`endif