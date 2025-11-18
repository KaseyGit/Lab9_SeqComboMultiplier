module multiseg_driver(
    input clk,
    input en,
    input [15:0] bcd_in,
    output [3:0] seg_anode,
    output [6:0] seg_cathode,
    output rdy //take after all anodes have displayed
    );
    wire [3:0] bcd_result;
	reg [15:0] anode_bcd_in;

    
    always @(posedge clk) begin
    	if(en)
            begin
            anode_bcd_in<=bcd_in;
            end
    end
	
	anode_generator anode_gen(.en(en), .clk(clk), .bcd_in(bcd_in), .seg_anode(seg_anode), .bcd_out(bcd_result), .rdy(rdy));
	segment_7_binary cat_gen(.data_in(bcd_result), .seg(seg_cathode));
endmodule

module anode_generator(
    input clk,
    input en,
    input [15:0] bcd_in,
    output [3:0] seg_anode,
    output reg [3:0] bcd_out, //the given four bits to display to the selected anode
    output rdy
    );
    
	reg [9:0] counter = 0; //10-bit counter is more stable for some reason
	reg [3:0] anode = 4'b1110; //active low
	reg [3:0] anode_buff;
	reg [11:0] anode_counter = 3'b0;
	reg [3:0] shift_en = 4'd0;
	
	reg anode_counter_en=0;
	
	always @(posedge clk) begin
		counter <= counter + 1; //so this is slow enough for us to see the changes, allows all four shifts to be shown
		shift_en <= shift_en << 1;
		if (anode_counter == 12'd4095) begin
		//put out rdy
		  // reg [3:0] shift_en = 4'd0;
		   // shift_en <= shift_en << 1; 
		  //  if(ctr_max) begin
		  //      shift_en <= 4'd1;
		  //end
		  //assign en = |shift_en;
		//reset anode counter to 0
		  shift_en <= 4'd1;
		  anode_counter <= 0;
		  anode_counter_en <=0;
		end
		if (en) begin
		//anode counter may start counting
		  anode_counter_en <= 1;
		end
		
		if (counter == 1023) begin
		    anode_buff <= anode;
			anode <= {anode[2:0], anode[3]}; //acts like a circular shift register
			//do this so we can sequence through the four anodes: 1110 -> 0111 -> 1011 -> 1101
			
			//group the data
			case (anode)
				4'b1110: bcd_out <= bcd_in[3:0]; //if rightmost anode is active, 4 LSB from bcd are the displayed here
				4'b1101: bcd_out <= bcd_in[7:4];
				4'b1011: bcd_out <= bcd_in[11:8];
				4'b0111: bcd_out <= bcd_in[15:12];
				default: bcd_out <= 4'b0;
			endcase
			counter <= 0;
			//if received main enable set flag anode counter incr here
			if (anode_counter_en) anode_counter <= anode_counter + 1;
		end
	end
	
	assign seg_anode = anode_buff;
	assign rdy = |shift_en;
endmodule

module segment_7_binary(
    input [3:0] data_in,
    output reg [6:0] seg
    
    );
    
    
    //behavioral
	always @* begin
		case (data_in)
			0: seg = 7'b0000001; //bit order is ABCDEFG, where A = seg[6]
			1'b0001: seg = 7'b1001111; //can write cases either way
			2: seg = 7'b0010010;
			3: seg = 7'b0000110;
			4: seg = 7'b1001100;
			5: seg = 7'b0100100;
			6: seg = 7'b0100000;
			7: seg = 7'b0001111;
			8: seg = 7'b0000000;
			9: seg = 7'b0000100;
			default: seg = 7'b1111111; //default is no display
		endcase
	end
    
endmodule