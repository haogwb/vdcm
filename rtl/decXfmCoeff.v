module decXfmCoeff #(parameter ssm_idx = 0,comp=0)
(
  input mode_XFM,
  input [127:0] suffix,
  output [7:0] pnxtBlkQuant [0:16-1],
  output [7:0]  coef_size
  

);

wire [7:0] numbits0;
wire [7:0] numbits1;
parseEcg #(.ssm_idx(ssm_idx))u_parseEcg0
(
  .mode_XFM   (mode_XFM),
  .suffix    (mode_XFM ? suffix : 0),
//  .suffix_left(suffix_rmc0),
  .numbits(numbits0)
);

wire[127:0] suffix_rm_ecg0 = {suffix[127-28:0],28'b0};
parseEcg #(.ssm_idx(ssm_idx))u_parseEcg1
(
  .mode_XFM   (mode_XFM),
  .suffix    (mode_XFM ? suffix_rm_ecg0 : 0),
//  .suffix_left(suffix_rmc0),
  .numbits(numbits1)
);


endmodule
