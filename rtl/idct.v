module idct #(parameter COEFF_SIZE=9)
(

 input [COEFF_SIZE+6+5+1-1:0] tmp_array_0  ,
 input [COEFF_SIZE+6+5+1-1:0] tmp_array_1  ,
 input [COEFF_SIZE+6+5+1-1:0] tmp_array_2  ,
 input [COEFF_SIZE+6+5+1-1:0] tmp_array_3  ,
 input [COEFF_SIZE+6+5+1-1:0] tmp_array_4  ,
 input [COEFF_SIZE+6+5+1-1:0] tmp_array_5  ,
 input [COEFF_SIZE+6+5+1-1:0] tmp_array_6  ,
 input [COEFF_SIZE+6+5+1-1:0] tmp_array_7  ,

 output [COEFF_SIZE+6+5+1+1+1+1-1:0] x_0 , 
 output [COEFF_SIZE+6+5+1+1+1+1-1:0] x_1 , 
 output [COEFF_SIZE+6+5+1+1+1+1-1:0] x_2 , 
 output [COEFF_SIZE+6+5+1+1+1+1-1:0] x_3 , 
 output [COEFF_SIZE+6+5+1+1+1+1-1:0] x_4 , 
 output [COEFF_SIZE+6+5+1+1+1+1-1:0] x_5 , 
 output [COEFF_SIZE+6+5+1+1+1+1-1:0] x_6 , 
 output [COEFF_SIZE+6+5+1+1+1+1-1:0] x_7  






);


wire [COEFF_SIZE+6+5+1-1:0] z_array_0 =  tmp_array_0 ; 
wire [COEFF_SIZE+6+5+1-1:0] z_array_1 =  tmp_array_4 ; 
wire [COEFF_SIZE+6+5+1-1:0] z_array_2 =  tmp_array_2 ; 
wire [COEFF_SIZE+6+5+1-1:0] z_array_3 =  tmp_array_6 ; 
wire [COEFF_SIZE+6+5+1-1:0] z_array_4 =  tmp_array_7 ; 
wire [COEFF_SIZE+6+5+1-1:0] z_array_5 =  tmp_array_3 ; 
wire [COEFF_SIZE+6+5+1-1:0] z_array_6 =  tmp_array_5 ; 
wire [COEFF_SIZE+6+5+1-1:0] z_array_7 =  tmp_array_1 ; 

wire [COEFF_SIZE+6+5+1+1-1:0] ea_0 =  $signed(z_array_0) + $signed(z_array_1) ; 
wire [COEFF_SIZE+6+5+1+1-1:0] ea_1 =  $signed(z_array_0) - $signed(z_array_1) ; 
wire [COEFF_SIZE+6+5+1+7-1:0] ea_2_tmp =  $signed({1'b0,'h11}) *$signed(z_array_2) - $signed({1'b0,'h29})*$signed(z_array_3) ; 
wire [COEFF_SIZE+6+5+1+7-1:0] ea_3_tmp =  $signed({1'b0,'h29}) *$signed(z_array_2) + $signed({1'b0,'h11})*$signed(z_array_3) ; 
wire [COEFF_SIZE+6+5+1+1-1:0] ea_2 =  ea_2_tmp >> 6;
wire [COEFF_SIZE+6+5+1+1-1:0] ea_3 =  ea_3_tmp >> 6;


wire [COEFF_SIZE+6+5+1+1+1-1:0] eb_0 =  $signed(ea_0) + $signed(ea_3) ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] eb_1 =  $signed(ea_1) + $signed(ea_2) ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] eb_2 =  $signed(ea_1) - $signed(ea_2) ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] eb_3 =  $signed(ea_0) - $signed(ea_3) ; 



wire [COEFF_SIZE+6+5+1+1-1:0] da_0 =  $signed(z_array_7) - $signed(z_array_4) ; 
wire [COEFF_SIZE+6+5+1+1-1:0] da_1 =  $signed(z_array_5) ;
wire [COEFF_SIZE+6+5+1+1-1:0] da_2 =  $signed(z_array_6) ;
wire [COEFF_SIZE+6+5+1+1-1:0] da_3 =  $signed(z_array_7) + $signed(z_array_4) ; 

wire [COEFF_SIZE+6+5+1+1+1-1:0] db_0 =  $signed(da_0) + $signed(da_2) ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] db_1 =  $signed(da_3) - $signed(da_1) ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] db_2 =  $signed(da_0) - $signed(da_2) ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] db_3 =  $signed(da_1) + $signed(da_3) ; 

wire [COEFF_SIZE+6+5+1+1+1-1:0] dc_0 =  ($signed({1'b0,'d94}) *$signed(db_0) - $signed({1'b0,'d63})  *$signed(db_3))>>7 ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] dc_1 =  ($signed({1'b0,'d111})*$signed(db_1) - $signed({1'b0,'d22})  *$signed(db_2))>>7 ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] dc_2 =  ($signed({1'b0,'d22}) *$signed(db_1) + $signed({1'b0,'d111}) *$signed(db_2))>>7 ; 
wire [COEFF_SIZE+6+5+1+1+1-1:0] dc_3 =  ($signed({1'b0,'d63}) *$signed(db_0) + $signed({1'b0,'d94})  *$signed(db_3))>>7 ; 


assign  x_0 = $signed(eb_0) + $signed(dc_3);
assign  x_1 = $signed(eb_1) + $signed(dc_2);
assign  x_2 = $signed(eb_2) + $signed(dc_1);
assign  x_3 = $signed(eb_3) + $signed(dc_0);
assign  x_4 = $signed(eb_3) - $signed(dc_0);
assign  x_5 = $signed(eb_2) - $signed(dc_1);
assign  x_6 = $signed(eb_1) - $signed(dc_2);
assign  x_7 = $signed(eb_0) - $signed(dc_3);
endmodule
