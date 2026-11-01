`timescale 1ns/1ps
module main_control_tb;
    logic [6:0] opcode; logic [2:0] fn3;
    logic [1:0] memtoreg; logic branch,mux_inp,memread,memwrite,alusrc,reg_write; logic [2:0] aluop;
    main_control dut(.*);
    initial begin
        fn3=0; opcode=7'h33; #1; if(!reg_write || aluop!==0) $fatal(1,"R control");
        opcode=7'h03; #1; if(!reg_write || !memread || memtoreg!==1 || !alusrc) $fatal(1,"load control");
        opcode=7'h23; #1; if(!memwrite || reg_write) $fatal(1,"store control");
        opcode=7'h63; #1; if(!branch || aluop!==4) $fatal(1,"branch control");
        opcode=7'h67; #1; if(!mux_inp || memtoreg!==2) $fatal(1,"JALR control");
        opcode=7'h17; #1; if(!alusrc || !reg_write || memtoreg!==2) $fatal(1,"AUIPC control");
        $display("main_control_tb PASS"); $finish;
    end
endmodule
