module combo_mult_tb();

reg [3:0] a;
reg [3:0] b;
wire [7:0] p;

combo_mult dut(.a(a), .b(b), .p(p));


initial begin 
	
	//2 * 3
	a = 4'b0010; //2
	b = 4'b0011; //3
	#10;
	//looking for 6 b0110
	
	//4 * 5
	a = 4'b0100; //4
	b = 4'b0101; //5
	#10;
	//looking for 20 b10100
	
	//15 * 15
	a = 4'b1111;
	b = 4'b1111;
	#10;
	//looking for 225 b11100001
	
	$finish;
	end
endmodule
