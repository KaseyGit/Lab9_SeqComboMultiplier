`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2025 02:52:33 PM
// Design Name: 
// Module Name: top_seq_mult_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_seq_mult_tb();
    //	input clk, rst,
//	input [3:0] A, B,
//	output wire [6:0] seg,
//	output wire [3:0] an);
    reg clk, rst;
    reg [3:0] A, B;
    wire [6:0] seg;
    wire [3:0] an;
    
    top_seq_mult uut(.clk(clk), .rst(rst), .A(A), .B(B), .seg(seg), .an(an));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        A = 4'b0; B = 4'b0;
        #100; //reset is on
        
        rst = 0;
        A = 4'b0110;
        B = 4'b0100;
        //result should be 24
        #1000;
        $finish;
    end
    
endmodule
