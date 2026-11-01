`timescale 1ns/1ps
module alu_tb;
    logic [4:0] alu_control;
    logic [31:0] rs1_data,rs2_data,alu_out;
    logic zero;
    alu dut(.*);
    task automatic check(input logic [4:0] op,input logic [31:0] expected,input logic expected_zero);
        begin alu_control=op; #1; if(alu_out!==expected || zero!==expected_zero) $fatal(1,"ALU op %b got %h zero %b",op,alu_out,zero); end
    endtask
    initial begin
        rs1_data=32'h80000001; rs2_data=32'd1;
        check(0,32'h80000002,0); check(1,32'h80000000,0);
        check(2,32'h80000000,0); check(3,32'h80000001,0); check(4,32'h00000001,0);
        check(5,32'h00000002,0); check(6,32'h40000000,0); check(7,32'hc0000000,0);
        check(8,1,0); check(9,0,0); check(10,0,0);
        rs1_data=4; rs2_data=4; check(10,0,1); check(11,0,0);
        rs1_data=32'hffffffff; rs2_data=0; check(12,0,1); check(13,0,0);
        check(14,0,0); check(15,0,1);
        $display("alu_tb PASS"); $finish;
    end
endmodule
