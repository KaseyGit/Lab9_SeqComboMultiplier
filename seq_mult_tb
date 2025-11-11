`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 02:15:47 PM
// Design Name: 
// Module Name: seq_mult_tb
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


module seq_mult_tb();

reg clk;
reg rst;
reg [3:0] a;
reg [3:0] b;
wire [7:0] p;

seq_mult dut(.clk(clk), .rst(rst), .a(a), .b(b), .p(p));

initial clk = 0;
always #5 clk = ~clk;

initial begin 
	rst = 1;
	a = 4'b0000;
	b = 4'b0000;
	#20
	
	rst = 0;
	#5;
	
	//2 * 3
	a = 4'b0010; //2
	b = 4'b0011; //3
	#100;
	//looking for 6 b0110
	
	//4 * 5
	a = 4'b0100; //4
	b = 4'b0101; //5
	#100;
	//looking for 20 b10100
	
	//15 * 15
	a = 4'b1111;
	b = 4'b1111;
	#100;
	//looking for 225 b11100001
	
	//$finish;
end
endmodule
