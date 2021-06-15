module bitparse_ssm123 #(parameter ssm_idx = 0)
(
input clk,
input rstn,
input start_dec,
output codec_data_rd_en,
input [127:0] codec_data,

input isFls,

input modeNxt_MPPF,
input modeNxt_XFM,
input modeNxt_BP,
input use2x2,

input [3:0] modeNxt_Mpp_stepsize,

output reg [7:0]nxtBlkbitsSsm ,

output [7:0] pnxtBlkQuant [0:16-1],

output [8:0] xfm_coeff_0   ,
output [8:0] xfm_coeff_1   ,
output [8:0] xfm_coeff_2   ,
output [8:0] xfm_coeff_3   ,
output [8:0] xfm_coeff_4   ,
output [8:0] xfm_coeff_5   ,
output [8:0] xfm_coeff_6   ,
output [8:0] xfm_coeff_7   ,
output [8:0] xfm_coeff_8   ,
output [8:0] xfm_coeff_9   ,
output [8:0] xfm_coeff_10  ,
output [8:0] xfm_coeff_11  ,
output [8:0] xfm_coeff_12  ,
output [8:0] xfm_coeff_13  ,
output [8:0] xfm_coeff_14  ,
output [8:0] xfm_coeff_15  
);

wire [7:0] m_seMaxSize= 128;
wire [7:0] ssm0_fullness;
reg [7:0] ssm0_fullness_ff;
wire [7:0] ssmFunnelShiterSize = 255;//2*m_seMaxSize -1;
reg [254:0] shifter0;
wire wr_shifter0;

wire [127:0] suffix_rmc0;
wire [127:0] suffix_rmc01;
wire [7:0] qres_mppf_size;
wire [7:0] qres_size;
wire [7:0] xfm_size;
reg [127:0] suffix;
reg [2:0] stepSize_ssm0;
wire [3:0] numPx = 16;//getWidth * getHeight

//reg [7:0]nxtBlkbitsSsm ;
assign ssm0_fullness = /*wr_shifter0 ? ssm0_fullness_ff + 128 -nxtBlkbitsSsm : */ssm0_fullness_ff - nxtBlkbitsSsm;

always@(posedge clk or negedge rstn)
  if(~rstn)
    ssm0_fullness_ff <= 0;
  else if(wr_shifter0)
    ssm0_fullness_ff <= ssm0_fullness + 128;
  else
    ssm0_fullness_ff <= ssm0_fullness;

//always@(posedge clk or negedge rstn)
//  if(~rstn)
//    wr_shifter0 <= 0;
assign wr_shifter0 = start_dec & (ssm0_fullness< m_seMaxSize);
//    wr_shifter0 <= 1;
//  else
//    wr_shifter0 <= 0;

wire [254:0] shifter_left = shifter0 << nxtBlkbitsSsm;
genvar i;
always@(posedge clk or negedge rstn)
  if(~rstn)
    shifter0 <= 0;
  else if(wr_shifter0)
    if(ssm0_fullness_ff==0)
      shifter0 <= {codec_data,127'b0};
    else
      //case(ssm0_fullness)
      //8'd48 : shifter0 <= {shifter0[47+127:127],codec_data,{255-48-128{1'b0}}};
      case(ssm0_fullness)

      8'd1 : shifter0 <= {shifter_left[254-:1],codec_data,{255-1-128{1'b0}}};
      8'd2 : shifter0 <= {shifter_left[254-:2],codec_data,{255-2-128{1'b0}}};
      8'd3 : shifter0 <= {shifter_left[254-:3],codec_data,{255-3-128{1'b0}}};
      8'd4 : shifter0 <= {shifter_left[254-:4],codec_data,{255-4-128{1'b0}}};
      8'd5 : shifter0 <= {shifter_left[254-:5],codec_data,{255-5-128{1'b0}}};
      8'd6 : shifter0 <= {shifter_left[254-:6],codec_data,{255-6-128{1'b0}}};
      8'd7 : shifter0 <= {shifter_left[254-:7],codec_data,{255-7-128{1'b0}}};
      8'd8 : shifter0 <= {shifter_left[254-:8],codec_data,{255-8-128{1'b0}}};
      8'd9 : shifter0 <= {shifter_left[254-:9],codec_data,{255-9-128{1'b0}}};
      8'd10 : shifter0 <= {shifter_left[254-:10],codec_data,{255-10-128{1'b0}}};
      8'd11 : shifter0 <= {shifter_left[254-:11],codec_data,{255-11-128{1'b0}}};
      8'd12 : shifter0 <= {shifter_left[254-:12],codec_data,{255-12-128{1'b0}}};
      8'd13 : shifter0 <= {shifter_left[254-:13],codec_data,{255-13-128{1'b0}}};
      8'd14 : shifter0 <= {shifter_left[254-:14],codec_data,{255-14-128{1'b0}}};
      8'd15 : shifter0 <= {shifter_left[254-:15],codec_data,{255-15-128{1'b0}}};
      8'd16 : shifter0 <= {shifter_left[254-:16],codec_data,{255-16-128{1'b0}}};
      8'd17 : shifter0 <= {shifter_left[254-:17],codec_data,{255-17-128{1'b0}}};
      8'd18 : shifter0 <= {shifter_left[254-:18],codec_data,{255-18-128{1'b0}}};
      8'd19 : shifter0 <= {shifter_left[254-:19],codec_data,{255-19-128{1'b0}}};
      8'd20 : shifter0 <= {shifter_left[254-:20],codec_data,{255-20-128{1'b0}}};
      8'd21 : shifter0 <= {shifter_left[254-:21],codec_data,{255-21-128{1'b0}}};
      8'd22 : shifter0 <= {shifter_left[254-:22],codec_data,{255-22-128{1'b0}}};
      8'd23 : shifter0 <= {shifter_left[254-:23],codec_data,{255-23-128{1'b0}}};
      8'd24 : shifter0 <= {shifter_left[254-:24],codec_data,{255-24-128{1'b0}}};
      8'd25 : shifter0 <= {shifter_left[254-:25],codec_data,{255-25-128{1'b0}}};
      8'd26 : shifter0 <= {shifter_left[254-:26],codec_data,{255-26-128{1'b0}}};
      8'd27 : shifter0 <= {shifter_left[254-:27],codec_data,{255-27-128{1'b0}}};
      8'd28 : shifter0 <= {shifter_left[254-:28],codec_data,{255-28-128{1'b0}}};
      8'd29 : shifter0 <= {shifter_left[254-:29],codec_data,{255-29-128{1'b0}}};
      8'd30 : shifter0 <= {shifter_left[254-:30],codec_data,{255-30-128{1'b0}}};
      8'd31 : shifter0 <= {shifter_left[254-:31],codec_data,{255-31-128{1'b0}}};
      8'd32 : shifter0 <= {shifter_left[254-:32],codec_data,{255-32-128{1'b0}}};
      8'd33 : shifter0 <= {shifter_left[254-:33],codec_data,{255-33-128{1'b0}}};
      8'd34 : shifter0 <= {shifter_left[254-:34],codec_data,{255-34-128{1'b0}}};
      8'd35 : shifter0 <= {shifter_left[254-:35],codec_data,{255-35-128{1'b0}}};
      8'd36 : shifter0 <= {shifter_left[254-:36],codec_data,{255-36-128{1'b0}}};
      8'd37 : shifter0 <= {shifter_left[254-:37],codec_data,{255-37-128{1'b0}}};
      8'd38 : shifter0 <= {shifter_left[254-:38],codec_data,{255-38-128{1'b0}}};
      8'd39 : shifter0 <= {shifter_left[254-:39],codec_data,{255-39-128{1'b0}}};
      8'd40 : shifter0 <= {shifter_left[254-:40],codec_data,{255-40-128{1'b0}}};
      8'd41 : shifter0 <= {shifter_left[254-:41],codec_data,{255-41-128{1'b0}}};
      8'd42 : shifter0 <= {shifter_left[254-:42],codec_data,{255-42-128{1'b0}}};
      8'd43 : shifter0 <= {shifter_left[254-:43],codec_data,{255-43-128{1'b0}}};
      8'd44 : shifter0 <= {shifter_left[254-:44],codec_data,{255-44-128{1'b0}}};
      8'd45 : shifter0 <= {shifter_left[254-:45],codec_data,{255-45-128{1'b0}}};
      8'd46 : shifter0 <= {shifter_left[254-:46],codec_data,{255-46-128{1'b0}}};
      8'd47 : shifter0 <= {shifter_left[254-:47],codec_data,{255-47-128{1'b0}}};
      8'd48 : shifter0 <= {shifter_left[254-:48],codec_data,{255-48-128{1'b0}}};
      8'd49 : shifter0 <= {shifter_left[254-:49],codec_data,{255-49-128{1'b0}}};
      8'd50 : shifter0 <= {shifter_left[254-:50],codec_data,{255-50-128{1'b0}}};
      8'd51 : shifter0 <= {shifter_left[254-:51],codec_data,{255-51-128{1'b0}}};
      8'd52 : shifter0 <= {shifter_left[254-:52],codec_data,{255-52-128{1'b0}}};
      8'd53 : shifter0 <= {shifter_left[254-:53],codec_data,{255-53-128{1'b0}}};
      8'd54 : shifter0 <= {shifter_left[254-:54],codec_data,{255-54-128{1'b0}}};
      8'd55 : shifter0 <= {shifter_left[254-:55],codec_data,{255-55-128{1'b0}}};
      8'd56 : shifter0 <= {shifter_left[254-:56],codec_data,{255-56-128{1'b0}}};
      8'd57 : shifter0 <= {shifter_left[254-:57],codec_data,{255-57-128{1'b0}}};
      8'd58 : shifter0 <= {shifter_left[254-:58],codec_data,{255-58-128{1'b0}}};
      8'd59 : shifter0 <= {shifter_left[254-:59],codec_data,{255-59-128{1'b0}}};
      8'd60 : shifter0 <= {shifter_left[254-:60],codec_data,{255-60-128{1'b0}}};
      8'd61 : shifter0 <= {shifter_left[254-:61],codec_data,{255-61-128{1'b0}}};
      8'd62 : shifter0 <= {shifter_left[254-:62],codec_data,{255-62-128{1'b0}}};
      8'd63 : shifter0 <= {shifter_left[254-:63],codec_data,{255-63-128{1'b0}}};
      8'd64 : shifter0 <= {shifter_left[254-:64],codec_data,{255-64-128{1'b0}}};
      8'd65 : shifter0 <= {shifter_left[254-:65],codec_data,{255-65-128{1'b0}}};
      8'd66 : shifter0 <= {shifter_left[254-:66],codec_data,{255-66-128{1'b0}}};
      8'd67 : shifter0 <= {shifter_left[254-:67],codec_data,{255-67-128{1'b0}}};
      8'd68 : shifter0 <= {shifter_left[254-:68],codec_data,{255-68-128{1'b0}}};
      8'd69 : shifter0 <= {shifter_left[254-:69],codec_data,{255-69-128{1'b0}}};
      8'd70 : shifter0 <= {shifter_left[254-:70],codec_data,{255-70-128{1'b0}}};
      8'd71 : shifter0 <= {shifter_left[254-:71],codec_data,{255-71-128{1'b0}}};
      8'd72 : shifter0 <= {shifter_left[254-:72],codec_data,{255-72-128{1'b0}}};
      8'd73 : shifter0 <= {shifter_left[254-:73],codec_data,{255-73-128{1'b0}}};
      8'd74 : shifter0 <= {shifter_left[254-:74],codec_data,{255-74-128{1'b0}}};
      8'd75 : shifter0 <= {shifter_left[254-:75],codec_data,{255-75-128{1'b0}}};
      8'd76 : shifter0 <= {shifter_left[254-:76],codec_data,{255-76-128{1'b0}}};
      8'd77 : shifter0 <= {shifter_left[254-:77],codec_data,{255-77-128{1'b0}}};
      8'd78 : shifter0 <= {shifter_left[254-:78],codec_data,{255-78-128{1'b0}}};
      8'd79 : shifter0 <= {shifter_left[254-:79],codec_data,{255-79-128{1'b0}}};
      8'd80 : shifter0 <= {shifter_left[254-:80],codec_data,{255-80-128{1'b0}}};
      8'd81 : shifter0 <= {shifter_left[254-:81],codec_data,{255-81-128{1'b0}}};
      8'd82 : shifter0 <= {shifter_left[254-:82],codec_data,{255-82-128{1'b0}}};
      8'd83 : shifter0 <= {shifter_left[254-:83],codec_data,{255-83-128{1'b0}}};
      8'd84 : shifter0 <= {shifter_left[254-:84],codec_data,{255-84-128{1'b0}}};
      8'd85 : shifter0 <= {shifter_left[254-:85],codec_data,{255-85-128{1'b0}}};
      8'd86 : shifter0 <= {shifter_left[254-:86],codec_data,{255-86-128{1'b0}}};
      8'd87 : shifter0 <= {shifter_left[254-:87],codec_data,{255-87-128{1'b0}}};
      8'd88 : shifter0 <= {shifter_left[254-:88],codec_data,{255-88-128{1'b0}}};
      8'd89 : shifter0 <= {shifter_left[254-:89],codec_data,{255-89-128{1'b0}}};
      8'd90 : shifter0 <= {shifter_left[254-:90],codec_data,{255-90-128{1'b0}}};
      8'd91 : shifter0 <= {shifter_left[254-:91],codec_data,{255-91-128{1'b0}}};
      8'd92 : shifter0 <= {shifter_left[254-:92],codec_data,{255-92-128{1'b0}}};
      8'd93 : shifter0 <= {shifter_left[254-:93],codec_data,{255-93-128{1'b0}}};
      8'd94 : shifter0 <= {shifter_left[254-:94],codec_data,{255-94-128{1'b0}}};
      8'd95 : shifter0 <= {shifter_left[254-:95],codec_data,{255-95-128{1'b0}}};
      8'd96 : shifter0 <= {shifter_left[254-:96],codec_data,{255-96-128{1'b0}}};
      8'd97 : shifter0 <= {shifter_left[254-:97],codec_data,{255-97-128{1'b0}}};
      8'd98 : shifter0 <= {shifter_left[254-:98],codec_data,{255-98-128{1'b0}}};
      8'd99 : shifter0 <= {shifter_left[254-:99],codec_data,{255-99-128{1'b0}}};
      8'd100 : shifter0 <= {shifter_left[254-:100],codec_data,{255-100-128{1'b0}}};
      8'd101 : shifter0 <= {shifter_left[254-:101],codec_data,{255-101-128{1'b0}}};
      8'd102 : shifter0 <= {shifter_left[254-:102],codec_data,{255-102-128{1'b0}}};
      8'd103 : shifter0 <= {shifter_left[254-:103],codec_data,{255-103-128{1'b0}}};
      8'd104 : shifter0 <= {shifter_left[254-:104],codec_data,{255-104-128{1'b0}}};
      8'd105 : shifter0 <= {shifter_left[254-:105],codec_data,{255-105-128{1'b0}}};
      8'd106 : shifter0 <= {shifter_left[254-:106],codec_data,{255-106-128{1'b0}}};
      8'd107 : shifter0 <= {shifter_left[254-:107],codec_data,{255-107-128{1'b0}}};
      8'd108 : shifter0 <= {shifter_left[254-:108],codec_data,{255-108-128{1'b0}}};
      8'd109 : shifter0 <= {shifter_left[254-:109],codec_data,{255-109-128{1'b0}}};
      8'd110 : shifter0 <= {shifter_left[254-:110],codec_data,{255-110-128{1'b0}}};
      8'd111 : shifter0 <= {shifter_left[254-:111],codec_data,{255-111-128{1'b0}}};
      8'd112 : shifter0 <= {shifter_left[254-:112],codec_data,{255-112-128{1'b0}}};
      8'd113 : shifter0 <= {shifter_left[254-:113],codec_data,{255-113-128{1'b0}}};
      8'd114 : shifter0 <= {shifter_left[254-:114],codec_data,{255-114-128{1'b0}}};
      8'd115 : shifter0 <= {shifter_left[254-:115],codec_data,{255-115-128{1'b0}}};
      8'd116 : shifter0 <= {shifter_left[254-:116],codec_data,{255-116-128{1'b0}}};
      8'd117 : shifter0 <= {shifter_left[254-:117],codec_data,{255-117-128{1'b0}}};
      8'd118 : shifter0 <= {shifter_left[254-:118],codec_data,{255-118-128{1'b0}}};
      8'd119 : shifter0 <= {shifter_left[254-:119],codec_data,{255-119-128{1'b0}}};
      8'd120 : shifter0 <= {shifter_left[254-:120],codec_data,{255-120-128{1'b0}}};
      8'd121 : shifter0 <= {shifter_left[254-:121],codec_data,{255-121-128{1'b0}}};
      8'd122 : shifter0 <= {shifter_left[254-:122],codec_data,{255-122-128{1'b0}}};
      8'd123 : shifter0 <= {shifter_left[254-:123],codec_data,{255-123-128{1'b0}}};
      8'd124 : shifter0 <= {shifter_left[254-:124],codec_data,{255-124-128{1'b0}}};
      8'd125 : shifter0 <= {shifter_left[254-:125],codec_data,{255-125-128{1'b0}}};
      8'd126 : shifter0 <= {shifter_left[254-:126],codec_data,{255-126-128{1'b0}}};
      8'd127 : shifter0 <= {shifter_left[254-:127],codec_data,{255-127-128{1'b0}}};
      //8'd48 : shifter0 <= {shifter_left[254-::48],codec_data,{255-481303028{1'b0}}};
      //8'd56 : shifter0 <= {shifter_left[254-:56],codec_data,{255-56-128{1'b0}}};
      //8'd98 : shifter0 <= {shifter_left[254-:98],codec_data,{255-98-128{1'b0}}};
      //8'd112 : shifter0 <= {shifter_left[254-:112],codec_data,{255-112-128{1'b0}}};
      default : shifter0 <= {shifter_left[254:-128],codec_data};
      endcase
  else
      shifter0 <= shifter_left;
assign codec_data_rd_en = wr_shifter0;


reg rd_shifter_rqst;
always@(posedge clk or negedge rstn)
  if(~rstn)
    rd_shifter_rqst <= 1'b0;
  else if(wr_shifter0)
    rd_shifter_rqst <= 1'b1;

reg [127:0] shifter_out;
always@(*)
  if(ssm0_fullness_ff !=0 & rd_shifter_rqst)
    shifter_out = shifter0[254:127];
  else
    shifter_out = 0;


//generate 
//begin
//if(ssm_idx==1)
//begin
assign suffix = shifter_out[127:0];
//end
//end
//endgenerate
reg [3:0] stepSize;
always@(posedge clk)
  stepSize <= modeNxt_Mpp_stepsize;
decMppSuffix #(.ssm_idx(ssm_idx))u_decMppSuffix
(
  .bitDepth  (8/*bitDepth_comp0*/),
  .stepSize  (stepSize),//ssm_idx ?tb.u_bitparse.stepSize_ssm0[2:0] /*2*/ : stepSize_ssm0),
  .suffix    (suffix),
  .pnxtBlkQuant(pnxtBlkQuant),
  .suffix_left(suffix_rmc0),
  .qres_size(qres_size)
);

reg mode_MPPF;
always@(posedge clk)
  mode_MPPF <= modeNxt_MPPF;
decMppfSuffix #(.ssm_idx(ssm_idx))u_decMppfSuffix
(
  .bitDepth  (8/*bitDepth_comp0*/),
//  .stepSize  (stepSize),//ssm_idx ?tb.u_bitparse.stepSize_ssm0[2:0] /*2*/ : stepSize_ssm0),
  .suffix    (suffix),
  .pnxtBlkQuant(),
  .suffix_left(),
  .qres_size(qres_mppf_size)
);


reg mode_XFM;
always@(posedge clk)
  mode_XFM <= modeNxt_XFM;
decXfmCoeff #(.ssm_idx(ssm_idx))u_decXfmCoeff
(
  .mode_XFM   (mode_XFM),
  .suffix    (mode_XFM ? suffix : 0),
//  .suffix_left(suffix_rmc0),
  .coef_size(xfm_size),

  .coeff_0   (xfm_coeff_0 ) ,
  .coeff_1   (xfm_coeff_1 ) ,
  .coeff_2   (xfm_coeff_2 ) ,
  .coeff_3   (xfm_coeff_3 ) ,
  .coeff_4   (xfm_coeff_4 ) ,
  .coeff_5   (xfm_coeff_5 ) ,
  .coeff_6   (xfm_coeff_6 ) ,
  .coeff_7   (xfm_coeff_7 ) ,
  .coeff_8   (xfm_coeff_8 ) ,
  .coeff_9   (xfm_coeff_9 ) ,
  .coeff_10  (xfm_coeff_10) ,
  .coeff_11  (xfm_coeff_11) ,
  .coeff_12  (xfm_coeff_12) ,
  .coeff_13  (xfm_coeff_13) ,
  .coeff_14  (xfm_coeff_14) ,
  .coeff_15  (xfm_coeff_15) 
);


reg mode_BP;
always@(posedge clk)
  mode_BP <= modeNxt_BP;
reg use2x2_ff;
always@(posedge clk)
  use2x2_ff <= use2x2;
wire [7:0] bp_size;
decBpvBlock #(.ssm_idx(ssm_idx)) u_decBpvBlock (
    .mode_BP                 ( mode_BP           ),
    .isFls                   ( isFls),
    .use2x2                  ( use2x2_ff            ),
    .suffix                  ( mode_BP ? suffix    [127:0]:0 ),
    .bp_size                ( bp_size  [7:0]   )
);

assign  nxtBlkbitsSsm = rd_shifter_rqst ? ( mode_XFM ? xfm_size :mode_BP ? bp_size: mode_MPPF ? qres_mppf_size: qres_size  )//: 0)
                                         : 0;
reg parse_vld;
always@(posedge clk or negedge rstn)
  if(~rstn)
    parse_vld <= 0;
  else
    parse_vld <= rd_shifter_rqst;

//decMppSuffix u_decMppSuffix_c1
//(
//  .bitDepth  (bitDepth_comp0),
//  .stepSize  (stepSize_ssm0),
//  .suffix    (suffix_rmc0),
//  .pnxtBlkQuant(),
//  .suffix_left(suffix_rmc01)
//);
endmodule
