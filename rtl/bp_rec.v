module bp_rec #(parameter DEPTH=8,k=0)
(
input clk,
input rstn,
input [7:0] m_qp,

input       bpskip,
input [3:0] use2x2,
input [5:0] bpv2x2[0:3],
input [5:0] bpv2x1_p0[0:3],
input [5:0] bpv2x1_p1[0:3],

input [8:0]bp_quant_c0[0:15],
input [8:0]bp_quant_c1[0:15],
input [8:0]bp_quant_c2[0:15],

input [DEPTH-1:0] bp_rangec_k0_line0 [0:32],
input [DEPTH-1:0] bp_rangec_k0_line1 [0:32],
input [DEPTH-1:0] bp_rangec_k1_line0 [0:32],
input [DEPTH-1:0] bp_rangec_k1_line1 [0:32],
input [DEPTH-1:0] bp_rangec_k2_line0 [0:32],
input [DEPTH-1:0] bp_rangec_k2_line1 [0:32]
);


bp_rec_com  u_bp_rec_c0 (
    .clk                     ( clk                      ),
    .rstn                    ( rstn                     ),
    .m_qp                    ( m_qp                ),
    .bpskip                  ( bpskip        ),
    .use2x2                  ( use2x2        ),
    .bpv2x2                  ( bpv2x2 ),
    .bpv2x1_p0               ( bpv2x1_p0 ),
    .bpv2x1_p1               ( bpv2x1_p1 ),
    .bp_quant_c0             ( bp_quant_c0 ),

    .bp_rangec_k0_line0      ( bp_rangec_k0_line0), 
    .bp_rangec_k0_line1      ( bp_rangec_k0_line1) 
);

bp_rec_com  u_bp_rec_c1 (
    .clk                     ( clk                      ),
    .rstn                    ( rstn                     ),
    .m_qp                    ( m_qp                ),
    .bpskip                  ( bpskip        ),
    .use2x2                  ( use2x2        ),
    .bpv2x2                  ( bpv2x2 ),
    .bpv2x1_p0               ( bpv2x1_p0 ),
    .bpv2x1_p1               ( bpv2x1_p1 ),
    .bp_quant_c0             ( bp_quant_c1 ),

    .bp_rangec_k0_line0      ( bp_rangec_k1_line0), 
    .bp_rangec_k0_line1      ( bp_rangec_k1_line1) 
);

bp_rec_com  u_bp_rec_c2 (
    .clk                     ( clk                      ),
    .rstn                    ( rstn                     ),
    .m_qp                    ( m_qp                ),
    .bpskip                  ( bpskip        ),
    .use2x2                  ( use2x2        ),
    .bpv2x2                  ( bpv2x2 ),
    .bpv2x1_p0               ( bpv2x1_p0 ),
    .bpv2x1_p1               ( bpv2x1_p1 ),
    .bp_quant_c0             ( bp_quant_c2 ),

    .bp_rangec_k0_line0      ( bp_rangec_k2_line0), 
    .bp_rangec_k0_line1      ( bp_rangec_k2_line1) 
);


endmodule
