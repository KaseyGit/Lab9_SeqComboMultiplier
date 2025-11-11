module seq_mult(input wire clk,input wire rst, input [3:0] a, input [3:0] b, output reg [7:0] p);
//input[3:0] a, b;
//output reg[7:0] p; //final output

reg[3:0] operand_b, shift_count;
reg[7:0] partial_product, multiplicand;
//multiplicand gets shifted left
//operand_b gets shifted right

reg [2:0] PS, NS;
parameter s0_idle = 0, s1_multiply = 1, s2_update_r = 2, s3_done = 3;

always@(posedge clk)
begin 
	if(rst) 
	PS<= s0_idle; 
	else
	PS <= NS;
end 

//STATE DESCRIPTION
always@(posedge clk) begin
	if(rst) begin
		partial_product <= 8'b0;
		shift_count <= 4'b0;
		multiplicand <= 8'b0;
		operand_b <= 4'b0;
		p <= 8'b0;
	end
	else begin
		case (PS)
		s0_idle: begin
			//a and b are assigned to multiplicand and operand_b
			partial_product <= 8'b0;
			shift_count <= 4'b0;
			multiplicand <= {4'b0, a}; //0000 aaaa
			operand_b <= b;
			p <= 8'b0;
			//NS <= s1_multiply;
		end
	
		s1_multiply: begin
			//b[0] = 0, shift without adding 
			if(operand_b[0] == 0 && shift_count < 4) begin
				partial_product <= partial_product;
				multiplicand <= multiplicand << 1;
				shift_count <= shift_count + 1;
				operand_b <= operand_b >> 1;
			end
		end

		s2_update_r: begin
			//this runs if b[0] != 0
			
			partial_product <= partial_product + multiplicand;
			multiplicand <= multiplicand << 1;
			operand_b <= operand_b >> 1;
			shift_count <= shift_count + 1;
		end

		s3_done: begin
			p<= partial_product;
		end
	endcase
end
end
always@(*)
begin 
	NS = PS;
	
	case(PS)
		s0_idle: begin
			NS = s1_multiply;
		end
		
		s1_multiply: begin
			if(shift_count < 4) begin
				if(operand_b[0] == 0) begin
					NS = s1_multiply;
				end
				else begin //operand_b[0] == 1, go to s2
					NS = s2_update_r;
				end
			end
			else begin
				NS = s3_done;
			end
		end
		
		//check the next bit
		s2_update_r: begin
			NS = s1_multiply;
		end
		
		//finished
		s3_done: begin 
			NS = s0_idle;
		end
	endcase
end
endmodule
