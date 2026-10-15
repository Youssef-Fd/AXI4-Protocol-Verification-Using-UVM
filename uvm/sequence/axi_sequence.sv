`ifndef AXI_SEQUENCE_SV
`define AXI_SEQUENCE_SV

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "C:/Users/Lenovo/Documents/QuestaSim_AXI4_UVM/axi_seq_item.sv"


    class axi_sequence extends uvm_sequence #(axi_seq_item);

        `uvm_object_utils(axi_sequence)

        function new(string name = "axi_sequence");
            super.new(name);
        endfunction

    endclass


    //verification of incremental burst with equal length of write and read transaction 
    class sequence_1 extends axi_sequence;

        `uvm_object_utils(sequence_1)

        function new(string name = "sequence_1");
            super.new(name);
        endfunction

        task body();

            axi_seq_item transaction;
            repeat(1) begin
                `uvm_info("SEQUENCE 1 START","", UVM_HIGH)
                transaction = axi_seq_item::type_id::create("transaction");
                start_item(transaction);
                transaction.randomize() with { reset == 1'b1 ;};
                finish_item(transaction);
            end
            #30;
            repeat(1) begin
                transaction = axi_seq_item::type_id::create("transaction");
                start_item(transaction);
                transaction.randomize() with { reset == 1'b0;
                                             WRITE_BURST_LEN == 9;
                                             WRITE_BURST_LEN == READ_BURST_LEN; 
                                             unique{WRITE_ADDR};
                                             //WRITE_ADDR.size() == 1;
                                             //READ_ADDR.size() == 1;
                                             WRITE_ADDR[0] == READ_ADDR[0];
                                             //RDATA.size() == (READ_BURST_LEN + 1);
                                             unique{RDATA};
                                            };
                finish_item(transaction);
                `uvm_info("SEQUENCE 1 ENDED","", UVM_HIGH)
            end
        endtask

    endclass



    //verification of incremental burst with different length of write and read transaction 
    class sequence_2 extends axi_sequence;
        
        `uvm_object_utils(sequence_2)

        function new(string name = "sequence_2");
            super.new(name);
        endfunction

        task body();

            axi_seq_item transaction;
            repeat(1) begin
                `uvm_info("SEQUENCE 2 STARTED", "", UVM_HIGH)
                transaction = axi_seq_item::type_id::create("transaction");
                start_item(transaction);
                transaction.randomize() with {reset == 1;};
                finish_item(transaction);
            end
            #30;
            repeat(1) begin
                transaction = axi_seq_item::type_id::create("transaction");
                start_item(transaction);
                transaction.randomize() with { reset == 1'b0;
                                             WRITE_BURST_LEN == 9;
                                             READ_BURST_LEN == 5;
                                             //RDATA.size() == (READ_BURST_LEN + 1);
                                             unique{RDATA};
                                             unique{WRITE_ADDR};
                                             WRITE_ADDR[0] == READ_ADDR[0];
                                            };
                finish_item(transaction);
            end
            repeat(1) begin
                transaction = axi_seq_item::type_id::create("transaction");
                start_item(transaction);
                transaction.randomize() with { reset == 1'b0;
                                             WRITE_BURST_LEN == 5;
                                             READ_BURST_LEN == 9;
                                             //RDATA.size() == (READ_BURST_LEN + 1);
                                             unique{RDATA};
                                             unique{WRITE_ADDR};
                                             WRITE_ADDR[0] == READ_ADDR[0];
                                            };
                finish_item(transaction);
                `uvm_info("SEQUENCE 2 ENDED", "", UVM_HIGH)
            end

        endtask

    endclass



    //verification of incremental burst with un_aligned addess 
    class sequence_3 extends axi_sequence;
        
        `uvm_object_utils(sequence_3)

        function new(string name = "sequence_3");
            super.new(name);
        endfunction

        task body();
            axi_seq_item transaction;
            repeat(1) begin
                `uvm_info("SEQUENCE 3 STARTED", "", UVM_HIGH)
                transaction = axi_seq_item::type_id::create("transaction");
                start_item(transaction);
                transaction.randomize() with {reset == 1;};
                finish_item(transaction);
            end
            #30;
            repeat(1) begin
                transaction = axi_seq_item::type_id::create("transaction");
                start_item(transaction);
                transaction.randomize() with { reset == 1'b0;
                                             WRITE_ADDR[0] == 122;
                                             READ_ADDR[0] == 120;
                                             WRITE_BURST_LEN == 9;
                                             WRITE_BURST_LEN == READ_BURST_LEN; 
                                             //RDATA.size() == (READ_BURST_LEN + 1);
                                             unique{RDATA};
                                            };
                finish_item(transaction);
                `uvm_info("SEQUENCE 3 ENDED", "", UVM_HIGH)
            end
        endtask

    endclass

`endif