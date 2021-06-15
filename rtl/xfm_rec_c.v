module xfm_rec_c #(parameter COEFF_SIZE=9,k)
(
input clk,
input rstn,
input [7:0] m_qp,

input [COEFF_SIZE-1:0]coeff_0 , 
input [COEFF_SIZE-1:0]coeff_1 , 
input [COEFF_SIZE-1:0]coeff_2 , 
input [COEFF_SIZE-1:0]coeff_3 , 
input [COEFF_SIZE-1:0]coeff_4 , 
input [COEFF_SIZE-1:0]coeff_5 , 
input [COEFF_SIZE-1:0]coeff_6 , 
input [COEFF_SIZE-1:0]coeff_7 , 
input [COEFF_SIZE-1:0]coeff_8 , 
input [COEFF_SIZE-1:0]coeff_9 , 
input [COEFF_SIZE-1:0]coeff_10, 
input [COEFF_SIZE-1:0]coeff_11, 
input [COEFF_SIZE-1:0]coeff_12, 
input [COEFF_SIZE-1:0]coeff_13, 
input [COEFF_SIZE-1:0]coeff_14, 
input [COEFF_SIZE-1:0]coeff_15 
);

//    { 16, 18, 33, 26 },
//    { 17, 20, 36, 28 },
//    { 19, 22, 39, 30 },
//    { 21, 23, 42, 33 },
//    { 23, 26, 46, 36 },
//    { 25, 28, 50, 39 },
//    { 27, 30, 55, 43 },
//    { 29, 33, 60, 47 } };
wire [5:0]dctInverseQuant_8x2[0:7][0:3];
assign dctInverseQuant_8x2[0][0] = 16;
assign dctInverseQuant_8x2[0][1] = 18;
assign dctInverseQuant_8x2[0][2] = 33;
assign dctInverseQuant_8x2[0][3] = 26;
assign dctInverseQuant_8x2[1][0] = 17;
assign dctInverseQuant_8x2[1][1] = 20;
assign dctInverseQuant_8x2[1][2] = 36;
assign dctInverseQuant_8x2[1][3] = 28;
assign dctInverseQuant_8x2[2][0] = 19;
assign dctInverseQuant_8x2[2][1] = 22;
assign dctInverseQuant_8x2[2][2] = 39;
assign dctInverseQuant_8x2[2][3] = 30;
assign dctInverseQuant_8x2[3][0] = 21;
assign dctInverseQuant_8x2[3][1] = 23;
assign dctInverseQuant_8x2[3][2] = 42;
assign dctInverseQuant_8x2[3][3] = 33;

assign dctInverseQuant_8x2[4][0] = 23;
assign dctInverseQuant_8x2[4][1] = 26;
assign dctInverseQuant_8x2[4][2] = 46;
assign dctInverseQuant_8x2[4][3] = 36;

assign dctInverseQuant_8x2[5][0] = 25;
assign dctInverseQuant_8x2[5][1] = 28;
assign dctInverseQuant_8x2[5][2] = 50;
assign dctInverseQuant_8x2[5][3] = 39;

assign dctInverseQuant_8x2[6][0] = 27;
assign dctInverseQuant_8x2[6][1] = 30;
assign dctInverseQuant_8x2[6][2] = 55;
assign dctInverseQuant_8x2[6][3] = 43;

assign dctInverseQuant_8x2[7][0] = 29;
assign dctInverseQuant_8x2[7][1] = 33;
assign dctInverseQuant_8x2[7][2] = 60;
assign dctInverseQuant_8x2[7][3] = 47;

wire [5:0]quant_table[0:3];

wire [2*8-1:0]dctQuantMapping_8x2 = { 2'b0, 2'b1, 2'h2, 2'h3, 2'h0, 2'h3, 2'h2, 2'h1 };
wire [2*8-1:0]map = dctQuantMapping_8x2;

wire [7:0] qp= compQpmod(m_qp,k);
wire [4:0] qp_per = qp[7:3];
wire [2:0] qp_rem = qp[2:0];
assign quant_table = dctInverseQuant_8x2[qp_rem];

wire [5:0] quant_c0 =quant_table[map[(8-0)*2-1-:2]];
wire [5:0] quant_c1 =quant_table[map[(8-1)*2-1-:2]];
wire [5:0] quant_c2 =quant_table[map[(8-2)*2-1-:2]];
wire [5:0] quant_c3 =quant_table[map[(8-3)*2-1-:2]];
wire [5:0] quant_c4 =quant_table[map[(8-4)*2-1-:2]];
wire [5:0] quant_c5 =quant_table[map[(8-5)*2-1-:2]];
wire [5:0] quant_c6 =quant_table[map[(8-6)*2-1-:2]];
wire [5:0] quant_c7 =quant_table[map[(8-7)*2-1-:2]];
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_0  = ({{6+5{coeff_0[COEFF_SIZE-1]}},coeff_0} * quant_c0)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_1  = ({{6+5{coeff_1[COEFF_SIZE-1]}},coeff_1} * quant_c1)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_2  = ({{6+5{coeff_2[COEFF_SIZE-1]}},coeff_2} * quant_c2)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_3  = ({{6+5{coeff_3[COEFF_SIZE-1]}},coeff_3} * quant_c3)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_4  = ({{6+5{coeff_4[COEFF_SIZE-1]}},coeff_4} * quant_c4)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_5  = ({{6+5{coeff_5[COEFF_SIZE-1]}},coeff_5} * quant_c5)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_6  = ({{6+5{coeff_6[COEFF_SIZE-1]}},coeff_6} * quant_c6)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_7  = ({{6+5{coeff_7[COEFF_SIZE-1]}},coeff_7} * quant_c7)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_8  = ({{6+5{coeff_8[COEFF_SIZE-1]}},coeff_8} * quant_c0)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_9  = ({{6+5{coeff_9[COEFF_SIZE-1]}},coeff_9} * quant_c1)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_10 = ({{6+5{coeff_10[COEFF_SIZE-1]}},coeff_10} * quant_c2)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_11 = ({{6+5{coeff_11[COEFF_SIZE-1]}},coeff_11} * quant_c3)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_12 = ({{6+5{coeff_12[COEFF_SIZE-1]}},coeff_12} * quant_c4)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_13 = ({{6+5{coeff_13[COEFF_SIZE-1]}},coeff_13} * quant_c5)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_14 = ({{6+5{coeff_14[COEFF_SIZE-1]}},coeff_14} * quant_c6)<<qp_per;
wire [COEFF_SIZE+6+5-1:0] xfm_rec_coeff_15 = ({{6+5{coeff_15[COEFF_SIZE-1]}},coeff_15} * quant_c7)<<qp_per;



//inverse haar
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_0   =  $signed(xfm_rec_coeff_0 ) + $signed(xfm_rec_coeff_8  );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_1   =  $signed(xfm_rec_coeff_1 ) + $signed(xfm_rec_coeff_9  );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_2   =  $signed(xfm_rec_coeff_2 ) + $signed(xfm_rec_coeff_10 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_3   =  $signed(xfm_rec_coeff_3 ) + $signed(xfm_rec_coeff_11 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_4   =  $signed(xfm_rec_coeff_4 ) + $signed(xfm_rec_coeff_12 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_5   =  $signed(xfm_rec_coeff_5 ) + $signed(xfm_rec_coeff_13 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_6   =  $signed(xfm_rec_coeff_6 ) + $signed(xfm_rec_coeff_14 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_7   =  $signed(xfm_rec_coeff_7 ) + $signed(xfm_rec_coeff_15 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_8   =  $signed(xfm_rec_coeff_0 ) - $signed(xfm_rec_coeff_8  );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_9   =  $signed(xfm_rec_coeff_1 ) - $signed(xfm_rec_coeff_9  );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_10  =  $signed(xfm_rec_coeff_2 ) - $signed(xfm_rec_coeff_10 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_11  =  $signed(xfm_rec_coeff_3 ) - $signed(xfm_rec_coeff_11 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_12  =  $signed(xfm_rec_coeff_4 ) - $signed(xfm_rec_coeff_12 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_13  =  $signed(xfm_rec_coeff_5 ) - $signed(xfm_rec_coeff_13 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_14  =  $signed(xfm_rec_coeff_6 ) - $signed(xfm_rec_coeff_14 );
wire [COEFF_SIZE+6+5+1-1:0] tmp_array_15  =  $signed(xfm_rec_coeff_7 ) - $signed(xfm_rec_coeff_15 );
                               
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_0          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_1          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_2          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_3          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_4          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_5          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_6          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_7          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_8          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_9          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_10          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_11          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_12          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_13          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_14          ;
wire [COEFF_SIZE+6+5+1+1+1+1-1:0] idct_15          ;

idct  u_idct_row0 (
    .tmp_array_0             ( tmp_array_0  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_1             ( tmp_array_1  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_2             ( tmp_array_2  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_3             ( tmp_array_3  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_4             ( tmp_array_4  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_5             ( tmp_array_5  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_6             ( tmp_array_6  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_7             ( tmp_array_7  [COEFF_SIZE+6+5+1-1:0]       ),

    .x_0                     ( idct_0          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_1                     ( idct_1          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_2                     ( idct_2          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_3                     ( idct_3          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_4                     ( idct_4          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_5                     ( idct_5          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_6                     ( idct_6          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_7                     ( idct_7          [COEFF_SIZE+6+5+1+1+1+1-1:0] )
);

idct  u_idct_row1 (
    .tmp_array_0             ( tmp_array_8  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_1             ( tmp_array_9  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_2             ( tmp_array_10  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_3             ( tmp_array_11  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_4             ( tmp_array_12  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_5             ( tmp_array_13  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_6             ( tmp_array_14  [COEFF_SIZE+6+5+1-1:0]       ),
    .tmp_array_7             ( tmp_array_15  [COEFF_SIZE+6+5+1-1:0]       ),

    .x_0                     ( idct_8           [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_1                     ( idct_9           [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_2                     ( idct_10          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_3                     ( idct_11          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_4                     ( idct_12          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_5                     ( idct_13          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_6                     ( idct_14          [COEFF_SIZE+6+5+1+1+1+1-1:0] ),
    .x_7                     ( idct_15          [COEFF_SIZE+6+5+1+1+1+1-1:0] )
);


//post-shift

wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_0  =    $signed(idct_0 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_1  =    $signed(idct_1 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_2  =    $signed(idct_2 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_3  =    $signed(idct_3 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_4  =    $signed(idct_4 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_5  =    $signed(idct_5 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_6  =    $signed(idct_6 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_7  =    $signed(idct_7 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_8  =    $signed(idct_8 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_9  =    $signed(idct_9 ) + $signed({1'b0,'d128})      ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_10 =    $signed(idct_10) + $signed({1'b0,'d128})       ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_11 =    $signed(idct_11) + $signed({1'b0,'d128})       ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_12 =    $signed(idct_12) + $signed({1'b0,'d128})       ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_13 =    $signed(idct_13) + $signed({1'b0,'d128})       ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_14 =    $signed(idct_14) + $signed({1'b0,'d128})       ;
wire [COEFF_SIZE+6+5+1+1+1+1+1-1:0] abs_idct_15 =    $signed(idct_15) + $signed({1'b0,'d128})       ;

wire [COEFF_SIZE+6+1+1-1:0] shift_idct_0  =    abs_idct_0 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_1  =    abs_idct_1 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_2  =    abs_idct_2 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_3  =    abs_idct_3 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_4  =    abs_idct_4 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_5  =    abs_idct_5 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_6  =    abs_idct_6 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_7  =    abs_idct_7 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_8  =    abs_idct_8 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_9  =    abs_idct_9 >>8      ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_10 =    abs_idct_10>>8       ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_11 =    abs_idct_11>>8       ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_12 =    abs_idct_12>>8       ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_13 =    abs_idct_13>>8       ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_14 =    abs_idct_14>>8       ;
wire [COEFF_SIZE+6+1+1-1:0] shift_idct_15 =    abs_idct_15>>8       ;


wire [COEFF_SIZE+6+1+1-1:0] xfm_out_0  =    shift_idct_0       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_1  =    shift_idct_1       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_2  =    shift_idct_2       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_3  =    shift_idct_3       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_4  =    shift_idct_4       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_5  =    shift_idct_5       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_6  =    shift_idct_6       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_7  =    shift_idct_7       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_8  =    shift_idct_8       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_9  =    shift_idct_9       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_10 =    shift_idct_10       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_11 =    shift_idct_11       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_12 =    shift_idct_12       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_13 =    shift_idct_13       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_14 =    shift_idct_14       ;
wire [COEFF_SIZE+6+1+1-1:0] xfm_out_15 =    shift_idct_15       ;

wire [18:0] tmp_rec_out0  = xfm_out_0  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out1  = xfm_out_1  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out2  = xfm_out_2  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out3  = xfm_out_3  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out4  = xfm_out_4  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out5  = xfm_out_5  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out6  = xfm_out_6  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out7  = xfm_out_7  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out8  = xfm_out_8  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out9  = xfm_out_9  + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out10 = xfm_out_10 + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out11 = xfm_out_11 + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out12 = xfm_out_12 + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out13 = xfm_out_13 + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out14 = xfm_out_14 + (k==0 ? 'h80 : 0);
wire [18:0] tmp_rec_out15 = xfm_out_15 + (k==0 ? 'h80 : 0);

wire [7:0] max = (1<<8)-1;
wire [8:0] min = k==0 ? 8'b0 : 9'h100;
parameter depth = k==0 ? 8 : 9;
wire [depth-1:0] rec_out0  = k==0 ? clip3_tmp(min,max,tmp_rec_out0  ) : clip3_c12(min,max,tmp_rec_out0  );
wire [depth-1:0] rec_out1  = k==0 ? clip3_tmp(min,max,tmp_rec_out1  ) : clip3_c12(min,max,tmp_rec_out1  );
wire [depth-1:0] rec_out2  = k==0 ? clip3_tmp(min,max,tmp_rec_out2  ) : clip3_c12(min,max,tmp_rec_out2  );
wire [depth-1:0] rec_out3  = k==0 ? clip3_tmp(min,max,tmp_rec_out3  ) : clip3_c12(min,max,tmp_rec_out3  );
wire [depth-1:0] rec_out4  = k==0 ? clip3_tmp(min,max,tmp_rec_out4  ) : clip3_c12(min,max,tmp_rec_out4  );
wire [depth-1:0] rec_out5  = k==0 ? clip3_tmp(min,max,tmp_rec_out5  ) : clip3_c12(min,max,tmp_rec_out5  );
wire [depth-1:0] rec_out6  = k==0 ? clip3_tmp(min,max,tmp_rec_out6  ) : clip3_c12(min,max,tmp_rec_out6  );
wire [depth-1:0] rec_out7  = k==0 ? clip3_tmp(min,max,tmp_rec_out7  ) : clip3_c12(min,max,tmp_rec_out7  );
wire [depth-1:0] rec_out8  = k==0 ? clip3_tmp(min,max,tmp_rec_out8  ) : clip3_c12(min,max,tmp_rec_out8  );
wire [depth-1:0] rec_out9  = k==0 ? clip3_tmp(min,max,tmp_rec_out9  ) : clip3_c12(min,max,tmp_rec_out9  );
wire [depth-1:0] rec_out10 = k==0 ? clip3_tmp(min,max,tmp_rec_out10 ) : clip3_c12(min,max,tmp_rec_out10 );
wire [depth-1:0] rec_out11 = k==0 ? clip3_tmp(min,max,tmp_rec_out11 ) : clip3_c12(min,max,tmp_rec_out11 );
wire [depth-1:0] rec_out12 = k==0 ? clip3_tmp(min,max,tmp_rec_out12 ) : clip3_c12(min,max,tmp_rec_out12 );
wire [depth-1:0] rec_out13 = k==0 ? clip3_tmp(min,max,tmp_rec_out13 ) : clip3_c12(min,max,tmp_rec_out13 );
wire [depth-1:0] rec_out14 = k==0 ? clip3_tmp(min,max,tmp_rec_out14 ) : clip3_c12(min,max,tmp_rec_out14 );
wire [depth-1:0] rec_out15 = k==0 ? clip3_tmp(min,max,tmp_rec_out15 ) : clip3_c12(min,max,tmp_rec_out15 );

function [7:0] compQpmod;
  input [7:0] masterQp;
  input [1:0] k;
  reg [7:0] tmpQp;

  reg  [7*57-1:0] qStepCo = { 7'd24, 7'd25, 7'd26, 7'd27, 7'd29, 7'd30, 7'd31, 7'd33, 7'd34, 7'd35, 7'd37, 7'd38, 7'd39, 7'd40, 7'd42, 7'd43, 7'd44, 7'd46, 7'd47, 7'd48, 7'd50, 7'd51, 7'd52, 7'd53, 7'd55, 7'd56, 7'd57, 7'd59, 7'd60, 7'd61, 7'd63, 7'd64, 7'd65, 7'd66, 7'd68, 7'd69, 7'd70, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72};
  reg  [7*57-1:0] qStepCg = { 7'd24, 7'd25, 7'd26, 7'd27, 7'd28, 7'd29, 7'd30, 7'd31, 7'd32, 7'd33, 7'd34, 7'd35, 7'd36, 7'd37, 7'd38, 7'd39, 7'd40, 7'd41, 7'd42, 7'd43, 7'd45, 7'd46, 7'd47, 7'd48, 7'd49, 7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, 7'd66, 7'd67, 7'd68, 7'd69, 7'd70, 7'd71, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72, 7'd72};
  reg [7:0] qpAdj =0;
 //kYcoCg
    if(masterQp<16)
      tmpQp = (k==0 ? masterQp : masterQp + 8);
    else
      tmpQp = (k==0 ? masterQp : (k==1) ? qStepCo[(57-(masterQp - 16))*7-1-:7] : qStepCg[(57-(masterQp - 16))*7-1-:7]);

  compQpmod =  clip3(72,16,tmpQp) + qpAdj;
endfunction

function [7:0]clip3_tmp;
  input [7:0] min;
  input [7:0] max;
  input [COEFF_SIZE+6+1+1-1:0]rec_out;
//  input [7:0] pred;
//  if(&xfm_out_0[COEFF_SIZE+6+1+1-1:8])
//    clip3_tmp = {1'b1,xfm_out_0[7:0]} + 'h80;
//  else if(|xfm_out_0[COEFF_SIZE+6+1+1-1:8])
//    clip3_tmp = max;
//  else 
//    clip3_tmp = xfm_out_0[7:0]+pred;

  if(rec_out[COEFF_SIZE+6+1+1-1])
    clip3_tmp = min;
  else if(|rec_out[COEFF_SIZE+6+1+1-1:8])
    clip3_tmp = max;
  else
    clip3_tmp = rec_out;

endfunction

function [8:0]clip3_c12;
  input [8:0] min;
  input [8:0] max;
  input [COEFF_SIZE+6+1+1-1:0]rec_out;

  if(&rec_out[COEFF_SIZE+6+1+1-1:9])
    clip3_c12 = rec_out;
  else if(|rec_out[COEFF_SIZE+6+1+1-1:9] & rec_out[COEFF_SIZE+6+1+1-1])
    clip3_c12 = min;
  else if(|rec_out[COEFF_SIZE+6+1+1-1:9])
    clip3_c12 = max;
  else
    clip3_c12 = rec_out;

endfunction


function [7:0] clip3;
  input [7:0] clipMax;
  input [7:0] clipMin;
  input [7:0] rec;

  clip3 =  rec>clipMax ? clipMax : (rec<clipMin ? clipMin : rec);
endfunction


endmodule
