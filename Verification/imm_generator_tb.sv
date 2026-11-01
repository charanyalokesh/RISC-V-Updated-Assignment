`timescale 1ns/1ps
module imm_generator_tb;
    logic [11:0] imm_input;
    logic [2:0] fn3;
    logic [6:0] opcode;
    logic [19:0] imm_input_uj;
    logic [31:0] imm_output;
    imm_generator dut(.*);
    initial begin
        imm_input=12'h800; fn3=0; opcode=7'b0000011; imm_input_uj=0; #1;
        if(imm_output!==32'hfffff800) $fatal(1,"I sign extension");
        opcode=7'b0100011; imm_input=12'hffc; #1;
        if(imm_output!==32'hfffffffc) $fatal(1,"S sign extension");
        opcode=7'b1100011; imm_input=12'h7ff; #1;
        if(imm_output!==32'h00000ffe) $fatal(1,"B shift");
        opcode=7'b1101111; imm_input_uj=20'h80000; #1;
        if(imm_output!==32'hfff00000) $fatal(1,"J sign extension/shift");
        opcode=7'b0110111; imm_input_uj=20'habcde; #1;
        if(imm_output!==32'habcde000) $fatal(1,"U immediate");
        opcode=7'b0010011; fn3=3'b101; imm_input=12'h405; #1;
        if(imm_output!==32'd5) $fatal(1,"shift immediate");
        $display("imm_generator_tb PASS"); $finish;
    end
endmodule
