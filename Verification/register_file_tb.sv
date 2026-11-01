`timescale 1ns/1ps
module register_file_tb;
    logic [4:0] rs1_sel,rs2_sel,rd_sel;
    logic reg_write,clk=0,reset;
    logic [31:0] wb_data,rs1_data,rs2_data;
    register_file dut(.*);
    always #5 clk=~clk;
    initial begin
        rs1_sel=1; rs2_sel=0; rd_sel=1; wb_data=32'h12345678; reg_write=0; reset=1; #1;
        if(rs1_data!==0 || rs2_data!==0) $fatal(1,"async reset");
        reset=0; reg_write=1; @(posedge clk); #1;
        if(rs1_data!==32'h12345678 || rs2_data!==0) $fatal(1,"write/read/x0");
        rd_sel=0; wb_data=32'hffffffff; @(posedge clk); #1;
        rs1_sel=0; #1; if(rs1_data!==0) $fatal(1,"x0 write protection");
        $display("register_file_tb PASS"); $finish;
    end
endmodule
