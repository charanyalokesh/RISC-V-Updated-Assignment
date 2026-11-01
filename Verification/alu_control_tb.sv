`timescale 1ns/1ps
module alu_control_tb;
    logic [2:0] alu_op,fn3;
    logic [6:0] imm11_5;
    logic fn7_5;
    logic [4:0] control_out;
    alu_control dut(.*);
    initial begin
        alu_op=0; fn3=0; fn7_5=0; imm11_5=0; #1; if(control_out!==0) $fatal(1,"ADD");
        fn7_5=1; #1; if(control_out!==1) $fatal(1,"SUB");
        alu_op=1; fn3=5; imm11_5=7'h20; #1; if(control_out!==7) $fatal(1,"SRAI");
        imm11_5=0; #1; if(control_out!==6) $fatal(1,"SRLI");
        alu_op=4; fn3=3'b110; #1; if(control_out!==5'b01110) $fatal(1,"BLTU");
        alu_op=2; #1; if(control_out!==0) $fatal(1,"load ADD");
        $display("alu_control_tb PASS"); $finish;
    end
endmodule
