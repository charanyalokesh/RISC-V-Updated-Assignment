`timescale 1ns/1ps
module wb_stage_tb;
    logic [31:0] mem_out,alu_out,return_addr,imm_out,pc_signed_offset,wb_data;
    logic [1:0] memtoreg;
    logic [6:0] opcode_out_d;
    wb_stage dut(.*);
    initial begin
        mem_out=32'h11; alu_out=32'h22; return_addr=32'h33; imm_out=32'h44; pc_signed_offset=32'h55;
        memtoreg=0; opcode_out_d=0; #1; if(wb_data!==alu_out) $fatal(1,"ALU WB");
        memtoreg=1; #1; if(wb_data!==mem_out) $fatal(1,"load WB");
        memtoreg=2; opcode_out_d=7'h6f; #1; if(wb_data!==return_addr) $fatal(1,"JAL WB");
        opcode_out_d=7'h37; #1; if(wb_data!==imm_out) $fatal(1,"LUI WB");
        opcode_out_d=7'h17; #1; if(wb_data!==pc_signed_offset) $fatal(1,"AUIPC WB");
        $display("wb_stage_tb PASS"); $finish;
    end
endmodule
