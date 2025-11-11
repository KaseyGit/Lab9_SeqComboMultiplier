module combo_mult(a, b, p);
input[3:0] a, b;
wire[3:0] m0; //pp1
wire[4:0] m1; //pp2 
wire[5:0] m2; //pp2 
wire[6:0] m3; //pp4

wire [7:0] s1, s2, s3;
output[7:0] p;


assign m0 = a & {4{b[0]}}; 
assign m1 = {(a & {4{b[1]}}), 1'b0}; 
assign m2 = {(a & {4{b[2]}}), 2'b00};
assign m3 = {(a & {4{b[3]}}), 3'b000};


assign s1 = {4'b0, m0} + {3'b0,  m1}; //sum of pp1 and pp2
assign s2 = s1 + {2'b0,  m2}; //sum of pp2 and pp3
assign s3 = s2 + {1'b0,  m3}; //sum of pp3 and pp4

assign p = s3; //result

endmodule
