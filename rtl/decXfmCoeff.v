module decXfmCoeff #(parameter ssm_idx = 0,comp=0)
(
  input mode_XFM,
  input [127:0] suffix,
  output [7:0] pnxtBlkQuant [0:16-1],
  output [7:0]  coef_size
  

);

decEcg_allGroups #(.ssm_idx(ssm_idx),.m_modeType(0))u_decEcg_allGroups
(
  .suffix    (suffix),
  .mode_XFM  (mode_XFM),
  .coef_size(coef_size)
);
endmodule
