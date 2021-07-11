`timescale 1ns/1ps

module tb;

bit clk;

bit rstn;

initial begin

  forever #10ns clk = ~clk; 

end



initial begin

 rstn = 1'b0; 

 #20ns;

 rstn = 1'b1; 

 #32us;

 //$stop;
 $finish;

end



bit [127:0] codec_data;
bit [127:0] codec_data_ssm1;
bit [127:0] codec_data_ssm2;
bit [127:0] codec_data_ssm3;

bit codec_data_rd_en;
bit codec_data_rd_en_ssm1;
bit codec_data_rd_en_ssm2;
bit codec_data_rd_en_ssm3;
bit start_dec;
bit start_dec_ff;
bit start_dec_ff1;
initial begin
  #1us;
  @(posedge clk) start_dec <= 1;
//  @(posedge clk) start_dec_ff = 1;
//  @(posedge clk) start_dec_ff1 = 1;
end

always@(posedge clk)begin
  start_dec_ff <= start_dec;
  start_dec_ff1 <= start_dec_ff;
end
wire [10:0] blk_x;
wire [10:0] blk_y;
reg [9:0] c;
reg [9:0] r;
always@(posedge clk or negedge rstn)begin
  if(~rstn)
    c <= 'd0;
  else if(start_dec_ff1)
    if(c==1080/8-1)
       c <= 0;
    else
       c <= c+'d1;
end

always@(posedge clk or negedge rstn)begin
  if(~rstn)
    r <= 'd0;
  else if(start_dec_ff1)
    if(c==1080/8-1)
       r <= r+'d1;
end

assign blk_x = c*8;
assign blk_y = r*2;
wire isFls = r==0;
wire isNxtBlkFls = isFls & c<1080/8-1; 

wire [7:0] mpp_qres_ssm0 [0:16-1];
reg  [7:0] mpp_qres_ssm0_ff [0:16-1];
wire [7:0] mpp_qres_ssm1 [0:16-1];
wire [7:0] mpp_qres_ssm2 [0:16-1];
wire [7:0] mpp_qres_ssm3 [0:16-1];

wire modeNxt_XFM;
wire modeNxt_BP;
wire modeNxt_BPSKIP;
wire modeNxt_MPPF;
wire modeNxt_MPP;
wire [3:0] use2x2;
wire [5:0] bpv2x2_ssm0;
wire [5:0] bpv2x1_p0_ssm0;
wire [5:0] bpv2x1_p1_ssm0;
wire [5:0] bpv2x2[0:3];
wire [5:0] bpv2x1_p0[0:3];
wire [5:0] bpv2x1_p1[0:3];
wire [3:0] modeNxt_Mpp_stepsize;
wire [7:0]nxtBlkbitsSsm0 ;
wire [7:0]nxtBlkbitsSsm1 ;
wire [7:0]nxtBlkbitsSsm2 ;
wire [7:0]nxtBlkbitsSsm3 ;
wire [7:0] r_initTxDelay;
wire [15:0] r_rcBufferFullnessOffsetThd;
wire [23:0] r_rcFullnessSlope;
wire [15:0] r_sliceWidth;
wire [15:0] r_sliceHeight;
wire [16*8-1:0] r_tgt_rate_delta_lut ; 
wire [7:0] r_rcFullnessScale;
wire [7:0] m_qp;

wire [8:0]xfm_coeff_c0_0 ; 
wire [8:0]xfm_coeff_c0_1 ; 
wire [8:0]xfm_coeff_c0_2 ; 
wire [8:0]xfm_coeff_c0_3 ; 
wire [8:0]xfm_coeff_c0_4 ; 
wire [8:0]xfm_coeff_c0_5 ; 
wire [8:0]xfm_coeff_c0_6 ; 
wire [8:0]xfm_coeff_c0_7 ; 
wire [8:0]xfm_coeff_c0_8 ; 
wire [8:0]xfm_coeff_c0_9 ; 
wire [8:0]xfm_coeff_c0_10; 
wire [8:0]xfm_coeff_c0_11; 
wire [8:0]xfm_coeff_c0_12; 
wire [8:0]xfm_coeff_c0_13; 
wire [8:0]xfm_coeff_c0_14; 
wire [8:0]xfm_coeff_c0_15; 
wire [8:0]xfm_coeff_c1_0 ; 
wire [8:0]xfm_coeff_c1_1 ; 
wire [8:0]xfm_coeff_c1_2 ; 
wire [8:0]xfm_coeff_c1_3 ; 
wire [8:0]xfm_coeff_c1_4 ; 
wire [8:0]xfm_coeff_c1_5 ; 
wire [8:0]xfm_coeff_c1_6 ; 
wire [8:0]xfm_coeff_c1_7 ; 
wire [8:0]xfm_coeff_c1_8 ; 
wire [8:0]xfm_coeff_c1_9 ; 
wire [8:0]xfm_coeff_c1_10; 
wire [8:0]xfm_coeff_c1_11; 
wire [8:0]xfm_coeff_c1_12; 
wire [8:0]xfm_coeff_c1_13; 
wire [8:0]xfm_coeff_c1_14; 
wire [8:0]xfm_coeff_c1_15; 
wire [8:0]xfm_coeff_c2_0 ; 
wire [8:0]xfm_coeff_c2_1 ; 
wire [8:0]xfm_coeff_c2_2 ; 
wire [8:0]xfm_coeff_c2_3 ; 
wire [8:0]xfm_coeff_c2_4 ; 
wire [8:0]xfm_coeff_c2_5 ; 
wire [8:0]xfm_coeff_c2_6 ; 
wire [8:0]xfm_coeff_c2_7 ; 
wire [8:0]xfm_coeff_c2_8 ; 
wire [8:0]xfm_coeff_c2_9 ; 
wire [8:0]xfm_coeff_c2_10; 
wire [8:0]xfm_coeff_c2_11; 
wire [8:0]xfm_coeff_c2_12; 
wire [8:0]xfm_coeff_c2_13; 
wire [8:0]xfm_coeff_c2_14; 
wire [8:0]xfm_coeff_c2_15; 
wire [8:0]bp_quant_c0[0:15];
wire [8:0]bp_quant_c1[0:15];
wire [8:0]bp_quant_c2[0:15];
bitparse #(.ssm_idx(0)) u_bitparse(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec),
  .codec_data_rd_en (codec_data_rd_en),

  .codec_data       (codec_data),
  .isNxtBlockFls    (isNxtBlkFls), 

  .modeNxt_XFM      (modeNxt_XFM),
  .modeNxt_BP       (modeNxt_BP),
  .modeNxt_BPSKIP       (modeNxt_BPSKIP),
  .modeNxt_MPP        (modeNxt_MPP),
  .modeNxt_MPPF       (modeNxt_MPPF),
  .use2x2           (use2x2),
  .bpv2x2           ( bpv2x2_ssm0           ),
  .bpv2x1_p0        ( bpv2x1_p0_ssm0        ),
  .bpv2x1_p1        ( bpv2x1_p1_ssm0        ),
  .modeNxt_Mpp_stepsize(modeNxt_Mpp_stepsize),
  .nxtBlkbitsSsm0    (nxtBlkbitsSsm0),
  .pnxtBlkQuant(mpp_qres_ssm0)

);
bitparse_ssm123 #(.ssm_idx(1)) u_bitparse_ssm1(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec_ff),
  .codec_data_rd_en (codec_data_rd_en_ssm1),

  .codec_data       (codec_data_ssm1),
  .isFls            (isFls),
  .modeNxt_XFM      (modeNxt_XFM),
  .modeNxt_BP       (modeNxt_BP),
  .modeNxt_MPPF       (modeNxt_MPPF),
  .use2x2           (use2x2[1]),
  .bpv2x2           ( bpv2x2[1]           ),
  .bpv2x1_p0        ( bpv2x1_p0[1]        ),
  .bpv2x1_p1        ( bpv2x1_p1[1]        ),
  .modeNxt_Mpp_stepsize(modeNxt_Mpp_stepsize),

  .nxtBlkbitsSsm    (nxtBlkbitsSsm1),
  .pnxtBlkQuant(mpp_qres_ssm1),

  .xfm_coeff_0   (xfm_coeff_c0_0 ) ,
  .xfm_coeff_1   (xfm_coeff_c0_1 ) ,
  .xfm_coeff_2   (xfm_coeff_c0_2 ) ,
  .xfm_coeff_3   (xfm_coeff_c0_3 ) ,
  .xfm_coeff_4   (xfm_coeff_c0_4 ) ,
  .xfm_coeff_5   (xfm_coeff_c0_5 ) ,
  .xfm_coeff_6   (xfm_coeff_c0_6 ) ,
  .xfm_coeff_7   (xfm_coeff_c0_7 ) ,
  .xfm_coeff_8   (xfm_coeff_c0_8 ) ,
  .xfm_coeff_9   (xfm_coeff_c0_9 ) ,
  .xfm_coeff_10  (xfm_coeff_c0_10) ,
  .xfm_coeff_11  (xfm_coeff_c0_11) ,
  .xfm_coeff_12  (xfm_coeff_c0_12) ,
  .xfm_coeff_13  (xfm_coeff_c0_13) ,
  .xfm_coeff_14  (xfm_coeff_c0_14) ,
  .xfm_coeff_15  (xfm_coeff_c0_15) ,

  .bp_quant      (bp_quant_c0    )
);
bitparse_ssm123 #(.ssm_idx(2)) u_bitparse_ssm2(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec_ff),
  .codec_data_rd_en (codec_data_rd_en_ssm2),

  .codec_data       (codec_data_ssm2),

  .isFls            (isFls),
  .modeNxt_XFM      (modeNxt_XFM),
  .modeNxt_BP       (modeNxt_BP),
  .modeNxt_MPPF       (modeNxt_MPPF),
  .use2x2           (use2x2[2]),
  .bpv2x2           ( bpv2x2[2]           ),
  .bpv2x1_p0        ( bpv2x1_p0[2]        ),
  .bpv2x1_p1        ( bpv2x1_p1[2]        ),
  .modeNxt_Mpp_stepsize(modeNxt_Mpp_stepsize),

  .nxtBlkbitsSsm    (nxtBlkbitsSsm2),
  .pnxtBlkQuant(mpp_qres_ssm2),

  .xfm_coeff_0   (xfm_coeff_c1_0 ) ,
  .xfm_coeff_1   (xfm_coeff_c1_1 ) ,
  .xfm_coeff_2   (xfm_coeff_c1_2 ) ,
  .xfm_coeff_3   (xfm_coeff_c1_3 ) ,
  .xfm_coeff_4   (xfm_coeff_c1_4 ) ,
  .xfm_coeff_5   (xfm_coeff_c1_5 ) ,
  .xfm_coeff_6   (xfm_coeff_c1_6 ) ,
  .xfm_coeff_7   (xfm_coeff_c1_7 ) ,
  .xfm_coeff_8   (xfm_coeff_c1_8 ) ,
  .xfm_coeff_9   (xfm_coeff_c1_9 ) ,
  .xfm_coeff_10  (xfm_coeff_c1_10) ,
  .xfm_coeff_11  (xfm_coeff_c1_11) ,
  .xfm_coeff_12  (xfm_coeff_c1_12) ,
  .xfm_coeff_13  (xfm_coeff_c1_13) ,
  .xfm_coeff_14  (xfm_coeff_c1_14) ,
  .xfm_coeff_15  (xfm_coeff_c1_15) ,

  .bp_quant      (bp_quant_c1    )
);

bitparse_ssm123 #(.ssm_idx(3)) u_bitparse_ssm3(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec_ff),
  .codec_data_rd_en (codec_data_rd_en_ssm3),

  .codec_data       (codec_data_ssm3),

  .isFls            (isFls),
  .modeNxt_XFM      (modeNxt_XFM),
  .modeNxt_BP       (modeNxt_BP),
  .modeNxt_MPPF       (modeNxt_MPPF),
  .use2x2           (use2x2[3]),
  .bpv2x2           ( bpv2x2[3]           ),
  .bpv2x1_p0        ( bpv2x1_p0[3]        ),
  .bpv2x1_p1        ( bpv2x1_p1[3]        ),
  .modeNxt_Mpp_stepsize(modeNxt_Mpp_stepsize),

  .nxtBlkbitsSsm    (nxtBlkbitsSsm3),
  .pnxtBlkQuant(mpp_qres_ssm3),


  .xfm_coeff_0   (xfm_coeff_c2_0 ) ,
  .xfm_coeff_1   (xfm_coeff_c2_1 ) ,
  .xfm_coeff_2   (xfm_coeff_c2_2 ) ,
  .xfm_coeff_3   (xfm_coeff_c2_3 ) ,
  .xfm_coeff_4   (xfm_coeff_c2_4 ) ,
  .xfm_coeff_5   (xfm_coeff_c2_5 ) ,
  .xfm_coeff_6   (xfm_coeff_c2_6 ) ,
  .xfm_coeff_7   (xfm_coeff_c2_7 ) ,
  .xfm_coeff_8   (xfm_coeff_c2_8 ) ,
  .xfm_coeff_9   (xfm_coeff_c2_9 ) ,
  .xfm_coeff_10  (xfm_coeff_c2_10) ,
  .xfm_coeff_11  (xfm_coeff_c2_11) ,
  .xfm_coeff_12  (xfm_coeff_c2_12) ,
  .xfm_coeff_13  (xfm_coeff_c2_13) ,
  .xfm_coeff_14  (xfm_coeff_c2_14) ,
  .xfm_coeff_15  (xfm_coeff_c2_15) ,

  .bp_quant      (bp_quant_c2    )
);

always@(posedge clk)
  mpp_qres_ssm0_ff <= mpp_qres_ssm0;


wire [3*16*9-1:0]xfm_coeff;
assign xfm_coeff[1 *9-1 -:9] = xfm_coeff_c0_0 ;
assign xfm_coeff[2 *9-1 -:9] = xfm_coeff_c0_1 ;
assign xfm_coeff[3 *9-1 -:9] = xfm_coeff_c0_2 ;
assign xfm_coeff[4 *9-1 -:9] = xfm_coeff_c0_3 ;
assign xfm_coeff[5 *9-1 -:9] = xfm_coeff_c0_4 ;
assign xfm_coeff[6 *9-1 -:9] = xfm_coeff_c0_5 ;
assign xfm_coeff[7 *9-1 -:9] = xfm_coeff_c0_6 ;
assign xfm_coeff[8 *9-1 -:9] = xfm_coeff_c0_7 ;
assign xfm_coeff[9 *9-1 -:9] = xfm_coeff_c0_8 ;
assign xfm_coeff[10*9-1 -:9] = xfm_coeff_c0_9 ;
assign xfm_coeff[11*9-1 -:9] = xfm_coeff_c0_10;
assign xfm_coeff[12*9-1 -:9] = xfm_coeff_c0_11;
assign xfm_coeff[13*9-1 -:9] = xfm_coeff_c0_12;
assign xfm_coeff[14*9-1 -:9] = xfm_coeff_c0_13;
assign xfm_coeff[15*9-1 -:9] = xfm_coeff_c0_14;
assign xfm_coeff[16*9-1 -:9] = xfm_coeff_c0_15;
assign xfm_coeff[(1*16*9)+1 *9-1 -:9] = xfm_coeff_c1_0 ;
assign xfm_coeff[(1*16*9)+2 *9-1 -:9] = xfm_coeff_c1_1 ;
assign xfm_coeff[(1*16*9)+3 *9-1 -:9] = xfm_coeff_c1_2 ;
assign xfm_coeff[(1*16*9)+4 *9-1 -:9] = xfm_coeff_c1_3 ;
assign xfm_coeff[(1*16*9)+5 *9-1 -:9] = xfm_coeff_c1_4 ;
assign xfm_coeff[(1*16*9)+6 *9-1 -:9] = xfm_coeff_c1_5 ;
assign xfm_coeff[(1*16*9)+7 *9-1 -:9] = xfm_coeff_c1_6 ;
assign xfm_coeff[(1*16*9)+8 *9-1 -:9] = xfm_coeff_c1_7 ;
assign xfm_coeff[(1*16*9)+9 *9-1 -:9] = xfm_coeff_c1_8 ;
assign xfm_coeff[(1*16*9)+10*9-1 -:9] = xfm_coeff_c1_9 ;
assign xfm_coeff[(1*16*9)+11*9-1 -:9] = xfm_coeff_c1_10;
assign xfm_coeff[(1*16*9)+12*9-1 -:9] = xfm_coeff_c1_11;
assign xfm_coeff[(1*16*9)+13*9-1 -:9] = xfm_coeff_c1_12;
assign xfm_coeff[(1*16*9)+14*9-1 -:9] = xfm_coeff_c1_13;
assign xfm_coeff[(1*16*9)+15*9-1 -:9] = xfm_coeff_c1_14;
assign xfm_coeff[(1*16*9)+16*9-1 -:9] = xfm_coeff_c1_15;
assign xfm_coeff[(2*16*9)+1 *9-1 -:9] = xfm_coeff_c2_0 ;
assign xfm_coeff[(2*16*9)+2 *9-1 -:9] = xfm_coeff_c2_1 ;
assign xfm_coeff[(2*16*9)+3 *9-1 -:9] = xfm_coeff_c2_2 ;
assign xfm_coeff[(2*16*9)+4 *9-1 -:9] = xfm_coeff_c2_3 ;
assign xfm_coeff[(2*16*9)+5 *9-1 -:9] = xfm_coeff_c2_4 ;
assign xfm_coeff[(2*16*9)+6 *9-1 -:9] = xfm_coeff_c2_5 ;
assign xfm_coeff[(2*16*9)+7 *9-1 -:9] = xfm_coeff_c2_6 ;
assign xfm_coeff[(2*16*9)+8 *9-1 -:9] = xfm_coeff_c2_7 ;
assign xfm_coeff[(2*16*9)+9 *9-1 -:9] = xfm_coeff_c2_8 ;
assign xfm_coeff[(2*16*9)+10*9-1 -:9] = xfm_coeff_c2_9 ;
assign xfm_coeff[(2*16*9)+11*9-1 -:9] = xfm_coeff_c2_10;
assign xfm_coeff[(2*16*9)+12*9-1 -:9] = xfm_coeff_c2_11;
assign xfm_coeff[(2*16*9)+13*9-1 -:9] = xfm_coeff_c2_12;
assign xfm_coeff[(2*16*9)+14*9-1 -:9] = xfm_coeff_c2_13;
assign xfm_coeff[(2*16*9)+15*9-1 -:9] = xfm_coeff_c2_14;
assign xfm_coeff[(2*16*9)+16*9-1 -:9] = xfm_coeff_c2_15;

reg mode_XFM;
always@(posedge clk)
  mode_XFM <= modeNxt_XFM;


reg [5:0] bpv2x2_ssm0_ff;
reg [5:0] bpv2x1_p0_ssm0_ff;
reg [5:0] bpv2x1_p1_ssm0_ff;
always@(posedge clk)begin
  bpv2x2_ssm0_ff    <= bpv2x2_ssm0;
  bpv2x1_p0_ssm0_ff <= bpv2x1_p0_ssm0;
  bpv2x1_p1_ssm0_ff <= bpv2x1_p1_ssm0;
end

assign bpv2x2[0]    =bpv2x2_ssm0_ff    ;
assign bpv2x1_p0[0] =bpv2x1_p0_ssm0_ff ;
assign bpv2x1_p1[0] =bpv2x1_p1_ssm0_ff ;
reg [3:0]use2x2_ff;
reg bpskip_ff;
always@(posedge clk)begin
  use2x2_ff <= use2x2;
  bpskip_ff <= modeNxt_BPSKIP;
end  

mode_dec  u_mode_dec (
    .clk     (clk),
    .rstn     (rstn),
    .blk_vld         ( start_dec_ff),
    .isFls            (isFls),
    .mode_XFM        ( mode_XFM      ),
    .mpp_qres_ssm0   ( mpp_qres_ssm0_ff ),
    .mpp_qres_ssm1   ( mpp_qres_ssm1 ),
    .mpp_qres_ssm2   ( mpp_qres_ssm2 ),
    .mpp_qres_ssm3   ( mpp_qres_ssm3 ),

    .m_qp            ( m_qp                ),
    .xfm_coeff       ( xfm_coeff           ),

    .bpskip           ( bpskip_ff        ),
    .use2x2           ( use2x2_ff        ),
    .bpv2x2           ( bpv2x2           ),
    .bpv2x1_p0        ( bpv2x1_p0        ),
    .bpv2x1_p1        ( bpv2x1_p1        ),
    .bp_quant_c0      ( bp_quant_c0      ),
    .bp_quant_c1      ( bp_quant_c1      ),
    .bp_quant_c2      ( bp_quant_c2      )
);

wire [8*8-1:0] r_max_qp_lut;
decRateControl u_decRateControl(
    .clk                     ( clk                 ),
    .rstn                    ( rstn                ),
    .start_dec_ff1           (start_dec_ff1),
  .isFls             (isFls),
  .nxtBlkbitsSsm0    (nxtBlkbitsSsm0),
  .nxtBlkbitsSsm1    (nxtBlkbitsSsm1),
  .nxtBlkbitsSsm2    (nxtBlkbitsSsm2),
  .nxtBlkbitsSsm3    (nxtBlkbitsSsm3),
  .r_sliceWidth              ( r_sliceWidth        ),
  .r_sliceHeight             ( r_sliceHeight       ),
  .r_initTxDelay                ( r_initTxDelay                [7:0]  ),
  .r_rcBufferFullnessOffsetThd  ( r_rcBufferFullnessOffsetThd  [15:0] ),
  .r_rcFullnessSlope            ( r_rcFullnessSlope            [23:0] ),
  .r_rcFullnessScale (r_rcFullnessScale),
  .r_tgt_rate_delta_lut      ( r_tgt_rate_delta_lut),
  .r_max_qp_lut              ( r_max_qp_lut        ),
  .m_qp                      ( m_qp                )
);

reg [7:0] pps[0:127];
initial begin
$readmemh("/mnt/hgfs/VDC-M/VDC-M_v1.2.2_2019.02.25/ppsbytes.txt",pps);
end

assign r_tgt_rate_delta_lut = {pps[64],pps[65],pps[66],pps[67],pps[68],pps[69],pps[70],pps[71],
                                        pps[72],pps[73],pps[74],pps[75],pps[76],pps[77],pps[78],pps[79] } ; 
assign r_rcFullnessScale=pps[37];
assign r_initTxDelay =pps[29];
assign r_rcBufferFullnessOffsetThd={pps[38],pps[39]};
assign r_rcFullnessSlope={pps[40],pps[41],pps[42]};;
assign r_sliceWidth = {pps[8],pps[9]};
assign r_sliceHeight = {pps[10],pps[11]};
assign r_max_qp_lut = {pps[56],pps[57],pps[58],pps[59],pps[60],pps[61],pps[62],pps[63]};
reg [127:0] codec_bits[0:4050-1];

initial begin

$readmemh("./bits.bits",codec_bits);

end



bit [10:0] codec_rd_addr;
bit [2:0] rd_en_num;
assign rd_en_num =  codec_data_rd_en + codec_data_rd_en_ssm1 + codec_data_rd_en_ssm2 + codec_data_rd_en_ssm3;
always@(posedge clk or negedge rstn)
  if(~rstn)
    codec_rd_addr <= 0;
  else if(rd_en_num==4)
    codec_rd_addr <= codec_rd_addr + 4;
  else if(rd_en_num==3)
    codec_rd_addr <= codec_rd_addr + 3;
  else if(rd_en_num==2)
    codec_rd_addr <= codec_rd_addr + 2;
  else if(rd_en_num==1)
    codec_rd_addr <= codec_rd_addr + 1;

always@(*)
begin
  if(codec_data_rd_en)
  codec_data = codec_bits[codec_rd_addr];

  if(codec_data_rd_en & codec_data_rd_en_ssm1)
    codec_data_ssm1 = codec_bits[codec_rd_addr+1];
  else if(codec_data_rd_en_ssm1)
    codec_data_ssm1 = codec_bits[codec_rd_addr];

  if(codec_data_rd_en & codec_data_rd_en_ssm1& codec_data_rd_en_ssm2)
    codec_data_ssm2 = codec_bits[codec_rd_addr+2];
  else if((codec_data_rd_en ^ codec_data_rd_en_ssm1)& codec_data_rd_en_ssm2)
    codec_data_ssm2 = codec_bits[codec_rd_addr+1];
  else if(codec_data_rd_en_ssm2)
    codec_data_ssm2 = codec_bits[codec_rd_addr+0];

  if(codec_data_rd_en & codec_data_rd_en_ssm1& codec_data_rd_en_ssm2& codec_data_rd_en_ssm3)
    codec_data_ssm3 = codec_bits[codec_rd_addr+3];
  else if((codec_data_rd_en+codec_data_rd_en_ssm1+ codec_data_rd_en_ssm2)==2 & codec_data_rd_en_ssm3)
    codec_data_ssm3 = codec_bits[codec_rd_addr+2];
  else if((codec_data_rd_en+codec_data_rd_en_ssm1+ codec_data_rd_en_ssm2)==1 & codec_data_rd_en_ssm3)
    codec_data_ssm3 = codec_bits[codec_rd_addr+1];
  else 
    codec_data_ssm3 = codec_bits[codec_rd_addr+0];


//  if(codec_data_rd_en)

//    codec_rd_addr = codec_rd_addr + 1;

end



integer fd_fullness;
integer fd_rc;
integer fd_mpp;
initial begin
  fd_fullness = $fopen("fullness.txt","w");
  fd_rc = $fopen("/mnt/hgfs/VDC-M/VDC-M_v1.2.2_2019.02.25/debugTracerDecoder_targetrate.txt","r");
  fd_mpp = $fopen("/mnt/hgfs/VDC-M/VDC-M_v1.2.2_2019.02.25/debugTracerDecoder_mpp.txt","r");
end

always@(posedge clk)
  if(start_dec_ff1)begin
    $fwrite(fd_fullness,"%02h ",tb.u_bitparse.ssm0_fullness_ff[7:0]);
    $fwrite(fd_fullness,"%02h ",tb.u_bitparse_ssm1.ssm0_fullness_ff[7:0]);
    $fwrite(fd_fullness,"%02h ",tb.u_bitparse_ssm2.ssm0_fullness_ff[7:0]);
    $fwrite(fd_fullness,"%02h \n",tb.u_bitparse_ssm3.ssm0_fullness_ff[7:0]);
  end

bit[15:0] tgtRate;
bit[15:0] bufferfullness;
bit[15:0] rcbufferfullness;
bit [8:0] k0_rec0,k0_rec1,k0_rec2,k0_rec3,k0_rec4,k0_rec5,k0_rec6,k0_rec7,k0_rec8,k0_rec9,k0_rec10,k0_rec11,k0_rec12,k0_rec13,k0_rec14,k0_rec15;
bit [8:0] k1_rec0,k1_rec1,k1_rec2,k1_rec3,k1_rec4,k1_rec5,k1_rec6,k1_rec7,k1_rec8,k1_rec9,k1_rec10,k1_rec11,k1_rec12,k1_rec13,k1_rec14,k1_rec15;
bit [8:0] k2_rec0,k2_rec1,k2_rec2,k2_rec3,k2_rec4,k2_rec5,k2_rec6,k2_rec7,k2_rec8,k2_rec9,k2_rec10,k2_rec11,k2_rec12,k2_rec13,k2_rec14,k2_rec15;
always@(posedge clk)
  if(start_dec_ff)begin
    $fscanf(fd_rc,"%d,%d,%d",tgtRate,bufferfullness,rcbufferfullness);
  end

reg mpp_dec_err=0;  
always@(posedge clk)
  if(modeNxt_MPP)begin
    $fscanf(fd_mpp,"%02h %02h %02h %02h %02h %02h %02h %02h ",k0_rec0,k0_rec1,k0_rec2,k0_rec3,k0_rec4,k0_rec5,k0_rec6,k0_rec7);
    $fscanf(fd_mpp,"%02h %02h %02h %02h %02h %02h %02h %02h ",k0_rec8,k0_rec9,k0_rec10,k0_rec11,k0_rec12,k0_rec13,k0_rec14,k0_rec15);
    $fscanf(fd_mpp,"%02h %02h %02h %02h %02h %02h %02h %02h ",k1_rec0,k1_rec1,k1_rec2,k1_rec3,k1_rec4,k1_rec5,k1_rec6,k1_rec7);
    $fscanf(fd_mpp,"%02h %02h %02h %02h %02h %02h %02h %02h ",k1_rec8,k1_rec9,k1_rec10,k1_rec11,k1_rec12,k1_rec13,k1_rec14,k1_rec15);
    $fscanf(fd_mpp,"%02h %02h %02h %02h %02h %02h %02h %02h ",k2_rec0,k2_rec1,k2_rec2,k2_rec3,k2_rec4,k2_rec5,k2_rec6,k2_rec7);
    $fscanf(fd_mpp,"%02h %02h %02h %02h %02h %02h %02h %02h ",k2_rec8,k2_rec9,k2_rec10,k2_rec11,k2_rec12,k2_rec13,k2_rec14,k2_rec15);
  end

reg  mode_MPP;
always@(posedge clk)
  mode_MPP <= modeNxt_MPP;
always@(negedge clk)
    if( mode_MPP & 
      (  k0_rec0!=tb.u_mode_dec.u_decMpp.pRec0[0]| k0_rec1!=tb.u_mode_dec.u_decMpp.pRec0[1]| k0_rec2!=tb.u_mode_dec.u_decMpp.pRec0[2]| k0_rec3!=tb.u_mode_dec.u_decMpp.pRec0[3]
      | k0_rec4!=tb.u_mode_dec.u_decMpp.pRec0[4]| k0_rec5!=tb.u_mode_dec.u_decMpp.pRec0[5]| k0_rec6!=tb.u_mode_dec.u_decMpp.pRec0[6]| k0_rec7!=tb.u_mode_dec.u_decMpp.pRec0[7]
      | k0_rec8!=tb.u_mode_dec.u_decMpp.pRec0[8]| k0_rec9!=tb.u_mode_dec.u_decMpp.pRec0[9]| k0_rec10!=tb.u_mode_dec.u_decMpp.pRec0[10]| k0_rec11!=tb.u_mode_dec.u_decMpp.pRec0[11]
      | k0_rec12!=tb.u_mode_dec.u_decMpp.pRec0[12]| k0_rec13!=tb.u_mode_dec.u_decMpp.pRec0[13]| k0_rec14!=tb.u_mode_dec.u_decMpp.pRec0[14]| k0_rec15!=tb.u_mode_dec.u_decMpp.pRec0[15]
      | k1_rec0!=tb.u_mode_dec.u_decMpp.pRec1[0]| k1_rec1!=tb.u_mode_dec.u_decMpp.pRec1[1]| k1_rec2!=tb.u_mode_dec.u_decMpp.pRec1[2]| k1_rec3!=tb.u_mode_dec.u_decMpp.pRec1[3]
      | k1_rec4!=tb.u_mode_dec.u_decMpp.pRec1[4]| k1_rec5!=tb.u_mode_dec.u_decMpp.pRec1[5]| k1_rec6!=tb.u_mode_dec.u_decMpp.pRec1[6]| k1_rec7!=tb.u_mode_dec.u_decMpp.pRec1[7]
      | k1_rec8!=tb.u_mode_dec.u_decMpp.pRec1[8]| k1_rec9!=tb.u_mode_dec.u_decMpp.pRec1[9]| k1_rec10!=tb.u_mode_dec.u_decMpp.pRec1[10]| k1_rec11!=tb.u_mode_dec.u_decMpp.pRec1[11]
      | k1_rec12!=tb.u_mode_dec.u_decMpp.pRec1[12]| k1_rec13!=tb.u_mode_dec.u_decMpp.pRec1[13]| k1_rec14!=tb.u_mode_dec.u_decMpp.pRec1[14]| k1_rec15!=tb.u_mode_dec.u_decMpp.pRec1[15]
      | k2_rec0!=tb.u_mode_dec.u_decMpp.pRec2[0]| k2_rec1!=tb.u_mode_dec.u_decMpp.pRec2[1]| k2_rec2!=tb.u_mode_dec.u_decMpp.pRec2[2]| k2_rec3!=tb.u_mode_dec.u_decMpp.pRec2[3]
      | k2_rec4!=tb.u_mode_dec.u_decMpp.pRec2[4]| k2_rec5!=tb.u_mode_dec.u_decMpp.pRec2[5]| k2_rec6!=tb.u_mode_dec.u_decMpp.pRec2[6]| k2_rec7!=tb.u_mode_dec.u_decMpp.pRec2[7]
      | k2_rec8!=tb.u_mode_dec.u_decMpp.pRec2[8]| k2_rec9!=tb.u_mode_dec.u_decMpp.pRec2[9]| k2_rec10!=tb.u_mode_dec.u_decMpp.pRec2[10]| k2_rec11!=tb.u_mode_dec.u_decMpp.pRec2[11]
      | k2_rec12!=tb.u_mode_dec.u_decMpp.pRec2[12]| k2_rec13!=tb.u_mode_dec.u_decMpp.pRec2[13]| k2_rec14!=tb.u_mode_dec.u_decMpp.pRec2[14]| k2_rec15!=tb.u_mode_dec.u_decMpp.pRec2[15]
      ))
      mpp_dec_err <= 1'b1;
    else
      mpp_dec_err <= 1'b0;

initial begin

    $fsdbDumpfile("test.fsdb");

    $fsdbDumpvars(0,tb);

    $fsdbDumpMDA(0, tb);

end



endmodule;
