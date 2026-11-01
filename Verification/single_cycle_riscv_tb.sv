`timescale 1ns/1ps
module single_cycle_riscv_tb;
    logic clk=0, reset=0, stall=0;
    logic [31:0] instruction,mem_out,rs2_data,alu_out,address;
    logic mem_write,mem_read; logic [2:0] fn3; logic [6:0] opcode;
    single_cycle_riscv dut(.*);
    always #5 clk=~clk;
    task automatic step(input logic [31:0] insn);
        begin instruction=insn; @(posedge clk); #1; end
    endtask
    initial begin
        instruction=32'h00000013; mem_out=0; reset=1; #1;
        if(address!==32'h80000000) $fatal(1,"reset PC");
        reset=0;
        step(32'h00500093); // addi x1,x0,5
        step(32'h00308113); // addi x2,x1,3 (dependency)
        if(dut.u_id.register_file_unit.register[1]!==5 || dut.u_id.register_file_unit.register[2]!==8) $fatal(1,"ALU dependency");
        instruction=32'h00202023; #1; if(!mem_write || alu_out!==0 || rs2_data!==8) $fatal(1,"store interface");
        step(32'h00002183); // lw x3,0(x0)
        mem_out=8; #1; @(posedge clk); #1;
        if(dut.u_id.register_file_unit.register[3]!==8) $fatal(1,"load writeback");
        step(32'h00210463); // beq x2,x2,+8
        if(address!==32'h80000018) $fatal(1,"taken branch target");
        step(32'h0080006f); // jal x0,+8
        if(address!==32'h80000020) $fatal(1,"JAL target");
        stall=1; instruction=32'h00100213; @(posedge clk); #1;
        if(address!==32'h80000020 || dut.u_id.register_file_unit.register[4]!==0) $fatal(1,"stall behavior");
        $display("single_cycle_riscv_tb PASS"); $finish;
    end
endmodule
