module decBpvBlock #(parameter ssm_idx = 0)
(

  input mode_BP,
  input isFls,
  input use2x2,
  input [127:0] suffix,
  output [7:0]  bp_size,
  output [5:0] bpv2x2,
  output [5:0] bpv2x1_p0,
  output [5:0] bpv2x1_p1,
 
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

reg [5:0] bpv2x2_tmp;
wire [3:0] m_bpvNumBits = 6;
wire m_isFls = isFls;//1;
wire [2:0] bitsPerBpv = m_isFls ? m_bpvNumBits -1 : m_bpvNumBits;
always@(*)
begin
  bpv2x2_tmp = 0;
  case(bitsPerBpv)
  8'h1: bpv2x2_tmp = use2x2 ? suffix[127] : 0;
  8'h2: bpv2x2_tmp = use2x2 ? suffix[127-:2] : 0;
  8'h3: bpv2x2_tmp = use2x2 ? suffix[127-:3] : 0;
  8'h4: bpv2x2_tmp = use2x2 ? suffix[127-:4] : 0;
  8'h5: bpv2x2_tmp = use2x2 ? suffix[127-:5] : 0;
  8'h6: bpv2x2_tmp = use2x2 ? suffix[127-:6] : 0;
//  8'h7: bpv2x2_tmp = use2x2 ? suffix[127-:7] : 0;
  default: bpv2x2_tmp = 0;
  endcase
end
assign bpv2x2 = use2x2 & m_isFls? bpv2x2_tmp + 32 : bpv2x2_tmp;

reg [5:0] bpv2x1_p0_tmp;
reg [5:0] bpv2x1_p1_tmp;
always@(*)
begin
  bpv2x1_p0_tmp = 0;
  case(bitsPerBpv)
  8'h1: bpv2x1_p0_tmp = ~use2x2 ? suffix[127] : 0;
  8'h2: bpv2x1_p0_tmp = ~use2x2 ? suffix[127-:2] : 0;
  8'h3: bpv2x1_p0_tmp = ~use2x2 ? suffix[127-:3] : 0;
  8'h4: bpv2x1_p0_tmp = ~use2x2 ? suffix[127-:4] : 0;
  8'h5: bpv2x1_p0_tmp = ~use2x2 ? suffix[127-:5] : 0;
  8'h6: bpv2x1_p0_tmp = ~use2x2 ? suffix[127-:6] : 0;
//  8'h7: bpv2x1_p0_tmp = ~use2x2 ? suffix[127-:7] : 0;
  default: bpv2x1_p0_tmp = 0;
  endcase
end
assign bpv2x1_p0 = !use2x2 & m_isFls? bpv2x1_p0_tmp + 32 : bpv2x1_p0_tmp;

always@(*)
begin
  bpv2x1_p1_tmp = 0;
  case(bitsPerBpv)
  8'h1: bpv2x1_p1_tmp = ~use2x2 ? suffix[127-1] : 0;
  8'h2: bpv2x1_p1_tmp = ~use2x2 ? suffix[127-2-:2] : 0;
  8'h3: bpv2x1_p1_tmp = ~use2x2 ? suffix[127-3-:3] : 0;
  8'h4: bpv2x1_p1_tmp = ~use2x2 ? suffix[127-4-:4] : 0;
  8'h5: bpv2x1_p1_tmp = ~use2x2 ? suffix[127-5-:5] : 0;
  8'h6: bpv2x1_p1_tmp = ~use2x2 ? suffix[127-6-:6] : 0;
//  8'h7: bpv2x1_p1_tmp = ~use2x2 ? suffix[127-7-:7] : 0;
  default: bpv2x1_p1_tmp = 0;
  endcase
end
assign bpv2x1_p1 = !use2x2 & m_isFls? bpv2x1_p1_tmp + 32 : bpv2x1_p1_tmp;



wire [7:0] bpv_size;
assign bpv_size = use2x2 ? bitsPerBpv : bitsPerBpv*2 ;


wire [127:0] suffix_rm_bpv = use2x2 ? suffix<<bitsPerBpv : suffix<<(bitsPerBpv*2);
wire [7:0] coef_size;

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

decEcg_allGroups #(.ssm_idx(ssm_idx))u_decEcg_allGroups
(
  .suffix    (suffix_rm_bpv),
  .mode_XFM  (mode_BP),
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

assign bp_size = bpv_size + coef_size;

assign coeff_0 = comp_coeff_0;
assign coeff_1 = comp_coeff_1;
assign coeff_2 = comp_coeff_4;
assign coeff_3 = comp_coeff_5;
assign coeff_4 = comp_coeff_8;
assign coeff_5 = comp_coeff_9;
assign coeff_6 = comp_coeff_12;
assign coeff_7 = comp_coeff_13;
assign coeff_8 = comp_coeff_2;
assign coeff_9 = comp_coeff_3;
assign coeff_10 = comp_coeff_6;
assign coeff_11 = comp_coeff_7;
assign coeff_12 = comp_coeff_10;
assign coeff_13 = comp_coeff_11;
assign coeff_14 = comp_coeff_14;
assign coeff_15 = comp_coeff_15;


endmodule
