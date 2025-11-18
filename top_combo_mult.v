module top_combo_mult(
	input clk, rst,
	input [3:0] A, B,
	output wire [6:0] cath,
	output wire [3:0] an);
	
	wire [7:0] bin_result;
	wire mult_to_conv, conv_to_disp;
	wire [15:0] bcd_result;
	wire sys_rdy;	
	
	//calculate the product --> bin 2 bcd --> display the value
	//module combo_mult(a, b, p);
	combo_mult mult(.a(A), .b(B), .p(bin_result));
	
	//pass the result into bin 2 bcd
	//module bin2bcd(bin, en, clk,reset,  bcd_out, rdy);
	bin2bcd conv(.clk(clk), .reset(rst), .bin({4'b0, bin_result}), .en(1'b1), .bcd_out(bcd_result), .rdy(conv_to_disp)); 
	
	//pass the BCD value into mutliseg driver
	//module multiseg_driver(input clk, input en, input [15:0] bcd_in, output [3:0] seg_anode, output [6:0] seg_cathode, output rdy //take after all anodes have displayed);
	multiseg_driver display(.clk(clk), .en(conv_to_disp), .bcd_in(bcd_result), .seg_anode(an), .seg_cathode(cath), .rdy(sys_rdy));
endmodule