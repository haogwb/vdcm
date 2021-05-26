module decXfmCoeff #(parameter ssm_idx = 0,comp=0)
(
  input mode_XFM,
  input [127:0] suffix,
  output [7:0] pnxtBlkQuant [0:16-1],
  output [7:0]  coef_size,
  
  output [8:0] coeff_0   ,
  output [8:0] coeff_1   ,
  output [8:0] coeff_2   ,
  output [8:0] coeff_3   ,
  output [8:0] coeff_4   ,
  output [8:0] coeff_5   ,
  output [8:0] coeff_6   ,
  output [8:0] coeff_7   ,
  output [8:0] coeff_8   ,
  output [8:0] coeff_9   ,
  output [8:0] coeff_10  ,
  output [8:0] coeff_11  ,
  output [8:0] coeff_12  ,
  output [8:0] coeff_13  ,
  output [8:0] coeff_14  ,
  output [8:0] coeff_15  

);

wire [8:0] comp_coeff_0   ;
wire [8:0] comp_coeff_1   ;
wire [8:0] comp_coeff_2   ;
wire [8:0] comp_coeff_3   ;
wire [8:0] comp_coeff_4   ;
wire [8:0] comp_coeff_5   ;
wire [8:0] comp_coeff_6   ;
wire [8:0] comp_coeff_7   ;
wire [8:0] comp_coeff_8   ;
wire [8:0] comp_coeff_9   ;
wire [8:0] comp_coeff_10  ;
wire [8:0] comp_coeff_11  ;
wire [8:0] comp_coeff_12  ;
wire [8:0] comp_coeff_13  ;
wire [8:0] comp_coeff_14  ;
wire [8:0] comp_coeff_15  ;
decEcg_allGroups #(.ssm_idx(ssm_idx),.m_modeType(0))u_decEcg_allGroups
(
  .suffix    (suffix),
  .mode_XFM  (mode_XFM),
  .coef_size(coef_size),
  .coeff_0   (comp_coeff_0 ) ,
  .coeff_1   (comp_coeff_1 ) ,
  .coeff_2   (comp_coeff_2 ) ,
  .coeff_3   (comp_coeff_3 ) ,
  .coeff_4   (comp_coeff_4 ) ,
  .coeff_5   (comp_coeff_5 ) ,
  .coeff_6   (comp_coeff_6 ) ,
  .coeff_7   (comp_coeff_7 ) ,
  .coeff_8   (comp_coeff_8 ) ,
  .coeff_9   (comp_coeff_9 ) ,
  .coeff_10  (comp_coeff_10) ,
  .coeff_11  (comp_coeff_11) ,
  .coeff_12  (comp_coeff_12) ,
  .coeff_13  (comp_coeff_13) ,
  .coeff_14  (comp_coeff_14) ,
  .coeff_15  (comp_coeff_15) 
);

//K444
wire [4*16-1:0] g_ecIndexMapping_Transform_8x2 ={ 4'd0, 4'd1, 4'd2, 4'd4, 4'd5, 4'd9, 4'd10, 4'd11, 4'd3, 4'd6, 4'd7, 4'd8, 4'd12, 4'd13, 4'd14, 4'd15};
assign coeff_0 = comp_coeff_0;
assign coeff_1 = comp_coeff_1;
assign coeff_2 = comp_coeff_2;
assign coeff_3 = comp_coeff_4;
assign coeff_4 = comp_coeff_5;
assign coeff_5 = comp_coeff_9;
assign coeff_6 = comp_coeff_10;
assign coeff_7 = comp_coeff_11;
assign coeff_8 = comp_coeff_3;
assign coeff_9 = comp_coeff_6;
assign coeff_10 = comp_coeff_7;
assign coeff_11 = comp_coeff_8;
assign coeff_12 = comp_coeff_12;
assign coeff_13 = comp_coeff_13;
assign coeff_14 = comp_coeff_14;
assign coeff_15 = comp_coeff_15;
endmodule
