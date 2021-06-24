module decMpp #(parameter BPC=8)
(
  input clk,
  input rstn,
  input blk_vld,
  input isFls,
  input [7:0] mpp_qres_ssm0 [0:16-1],
  input [7:0] mpp_qres_ssm1 [0:16-1],
  input [7:0] mpp_qres_ssm2 [0:16-1],
  input [7:0] mpp_qres_ssm3 [0:16-1],
  
  input [BPC-1:0]   prev_rec_c0[0:15] ,
  input [BPC+1-1:0] prev_rec_c1[0:15] ,
  input [BPC+1-1:0] prev_rec_c2[0:15] ,

  output[BPC-1:0] pRec0 [0:15],
  output[BPC+1-1:0] pRec1 [0:15],
  output[BPC+1-1:0] pRec2 [0:15]

);

reg [15:0] blkcounter;
always@(posedge clk or rstn)
  if(~rstn)
    blkcounter <= 0;
  else if(blk_vld)
    blkcounter <= blkcounter + 1;


wire [7:0] c0[0:15];
wire [7:0] c1[0:15];
wire [7:0] c2[0:15];
//refer to 4.6.3.5
genvar i;
generate
for(i=0;i<4;i=i+1)begin
  assign c0[i] =mpp_qres_ssm0[i] ;
end
endgenerate

generate
for(i=0;i<4;i=i+1)begin
  assign c1[i] =mpp_qres_ssm0[i+4] ;
end
endgenerate

generate
for(i=0;i<4;i=i+1)begin
  assign c2[i] =mpp_qres_ssm0[i+8] ;
end
endgenerate

generate
for(i=4;i<16;i=i+1)begin
  assign c0[i] =mpp_qres_ssm1[i-4] ;
end
for(i=4;i<16;i=i+1)begin
  assign c1[i] =mpp_qres_ssm2[i-4] ;
end
for(i=4;i<16;i=i+1)begin
  assign c2[i] =mpp_qres_ssm3[i-4] ;
end
endgenerate
decMpp_com  #(.depth(BPC))u_decMpp_c0 (
    .clk                     ( clk                            ),
    .rstn                    ( rstn                           ),
    .blk_vld                 ( blk_vld                        ),
    .isFls            (isFls),
    .blkcounter              ( blkcounter              [15:0] ),
    .prev_rec                ( prev_rec_c0                    ),
    .c0                      ( c0                             ),
    .pRec0                   ( pRec0                          )
);
decMpp_com  #(.depth(BPC+1)) u_decMpp_c1 (
    .clk                     ( clk                            ),
    .rstn                    ( rstn                           ),
    .blk_vld                 ( blk_vld                        ),
    .isFls            (isFls),
    .blkcounter              ( blkcounter              [15:0] ),
    .prev_rec                ( prev_rec_c1                    ),
    .c0                      ( c1                             ),
    .pRec0                   ( pRec1                          )

);
decMpp_com  #(.depth(BPC+1))u_decMpp_c2 (
    .clk                     ( clk                            ),
    .rstn                    ( rstn                           ),
    .blk_vld                 ( blk_vld                        ),
    .isFls            (isFls),
    .blkcounter              ( blkcounter              [15:0] ),
    .prev_rec                ( prev_rec_c2                    ),
    .c0                      ( c2                             ),
    .pRec0                   ( pRec2                          )

);

endmodule
