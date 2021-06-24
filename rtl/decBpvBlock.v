module decBpvBlock #(parameter ssm_idx = 0)
(

  input mode_BP,
  input isFls,
  input use2x2,
  input [127:0] suffix,
  output [7:0]  bp_size,
  output [5:0] bpv2x2,
  output [5:0] bpv2x1_p0,
  output [5:0] bpv2x1_p1
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
decEcg_allGroups #(.ssm_idx(ssm_idx))u_decEcg_allGroups
(
  .suffix    (suffix_rm_bpv),
  .mode_XFM  (mode_BP),
  .coef_size(coef_size)
);

assign bp_size = bpv_size + coef_size;



endmodule
