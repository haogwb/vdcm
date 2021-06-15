module xfm_rec #(parameter COEFF_SIZE=9)
(
input clk,
input rstn,

input [7:0] m_qp,
input [3*16*COEFF_SIZE-1:0]xfm_coeff 
);

genvar i;
generate 
for(i=0;i<3;i=i+1) begin

xfm_rec_c #(.k(i)) u_xfm_rec_c (
    .clk                 ( clk                 ),
    .rstn                ( rstn                ),
    .m_qp                ( m_qp                ),
    .coeff_0             ( xfm_coeff  [(i*16*9)+1 *9-1:(i*16*9)+0 *9] ),
    .coeff_1             ( xfm_coeff  [(i*16*9)+2 *9-1:(i*16*9)+1 *9] ),
    .coeff_2             ( xfm_coeff  [(i*16*9)+3 *9-1:(i*16*9)+2 *9] ),
    .coeff_3             ( xfm_coeff  [(i*16*9)+4 *9-1:(i*16*9)+3 *9] ),
    .coeff_4             ( xfm_coeff  [(i*16*9)+5 *9-1:(i*16*9)+4 *9] ),
    .coeff_5             ( xfm_coeff  [(i*16*9)+6 *9-1:(i*16*9)+5 *9] ),
    .coeff_6             ( xfm_coeff  [(i*16*9)+7 *9-1:(i*16*9)+6 *9] ),
    .coeff_7             ( xfm_coeff  [(i*16*9)+8 *9-1:(i*16*9)+7 *9] ),
    .coeff_8             ( xfm_coeff  [(i*16*9)+9 *9-1:(i*16*9)+8 *9] ),
    .coeff_9             ( xfm_coeff  [(i*16*9)+10*9-1:(i*16*9)+9 *9] ),
    .coeff_10            ( xfm_coeff  [(i*16*9)+11*9-1:(i*16*9)+10*9] ),
    .coeff_11            ( xfm_coeff  [(i*16*9)+12*9-1:(i*16*9)+11*9] ),
    .coeff_12            ( xfm_coeff  [(i*16*9)+13*9-1:(i*16*9)+12*9] ),
    .coeff_13            ( xfm_coeff  [(i*16*9)+14*9-1:(i*16*9)+13*9] ),
    .coeff_14            ( xfm_coeff  [(i*16*9)+15*9-1:(i*16*9)+14*9] ),
    .coeff_15            ( xfm_coeff  [(i*16*9)+16*9-1:(i*16*9)+15*9] )
);
end
endgenerate


endmodule
