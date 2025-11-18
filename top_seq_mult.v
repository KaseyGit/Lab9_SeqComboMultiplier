module top_seq_mult(
	input clk, rst,
	input [3:0] A, B,
	output wire [6:0] seg,
	output wire [3:0] an);
	
	wire [7:0] bin_result;
	wire mult_to_conv, conv_to_disp;
	wire [15:0] bcd_result;
	wire sys_rdy;
	reg [7:0] bin_in;
	reg [15:0] bcd_in;
	
	//calculate the product --> bin 2 bcd --> display the value
	//TODO: add a done signal to prompt bin2bcd
	seq_mult mult(.clk(clk), .rst(rst), .a(A), .b(B), .p(bin_result), .rdy(mult_to_conv));
	
	//pass the result into bin 2 bcd
	//module bin2bcd(bin, en, clk,reset,  bcd_out, rdy);S
	bin2bcd conv(.clk(clk), .reset(rst), .bin({4'b0, bin_in}), .en(mult_to_conv), .bcd_out(bcd_result), .rdy(conv_to_disp)); 
	
	//pass the BCD value into mutliseg driver
	//module multiseg_driver(input clk, input en, input [15:0] bcd_in, output [3:0] seg_anode, output [6:0] seg_cathode, output rdy //take after all anodes have displayed);
	multiseg_driver display(.clk(clk), .en(conv_to_disp), .bcd_in(bcd_in), .seg_anode(an), .seg_cathode(seg), .rdy(sys_rdy));
	
	always @(posedge clk) begin
	       if (mult_to_conv) bin_in <= bin_result;
	       if (conv_to_disp) bcd_in <= bcd_result;
	   end
endmodule