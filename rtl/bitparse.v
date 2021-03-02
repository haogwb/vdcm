module bitparse #(parameter ssm_idx = 0)
(
input clk,
input rstn,
input start_dec,
output codec_data_rd_en,
input [127:0] codec_data,


output [7:0] pnxtBlkQuant [0:16-1]

);

wire [7:0] m_seMaxSize= 128;
wire [7:0] ssm0_fullness;
reg [7:0] ssm0_fullness_ff;
wire [7:0] ssmFunnelShiterSize = 255;//2*m_seMaxSize -1;
reg [254:0] shifter0;
wire wr_shifter0;

wire [127:0] suffix_rmc0;
wire [127:0] suffix_rmc01;
wire [7:0] qres_size;
reg [127:0] suffix;
reg [2:0] stepSize_ssm0;
wire [3:0] numPx = 16;//getWidth * getHeight

reg [7:0]nxtBlkbitsSsm0 ;
assign ssm0_fullness = /*wr_shifter0 ? ssm0_fullness_ff + 128 -nxtBlkbitsSsm0 : */ssm0_fullness_ff - nxtBlkbitsSsm0;

always@(posedge clk or negedge rstn)
  if(~rstn)
    ssm0_fullness_ff <= 0;
  else if(wr_shifter0)
    ssm0_fullness_ff <= ssm0_fullness + 128;

//always@(posedge clk or negedge rstn)
//  if(~rstn)
//    wr_shifter0 <= 0;
assign wr_shifter0 = start_dec & (ssm0_fullness< m_seMaxSize);
//    wr_shifter0 <= 1;
//  else
//    wr_shifter0 <= 0;

wire [254:0] shifter_left = shifter0 << nxtBlkbitsSsm0;
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
      8'd48 : shifter0 <= {shifter_left[254-:48],codec_data,{255-48-128{1'b0}}};
      8'd56 : shifter0 <= {shifter_left[254-:56],codec_data,{255-56-128{1'b0}}};
      8'd98 : shifter0 <= {shifter_left[254-:98],codec_data,{255-98-128{1'b0}}};
      8'd112 : shifter0 <= {shifter_left[254-:112],codec_data,{255-112-128{1'b0}}};
      default : shifter0 <= {shifter_left[254:-128],codec_data};
      endcase
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

generate 
if(ssm_idx==0)
begin

wire [2:0] mode_header_bits;
//mode header
parameter MPP =2;
wire sameFlag = shifter_out[127];
wire [1:0] tmp = shifter_out[126:125];
wire [1:0] MPPF_BPSkip = {1'b0,shifter_out[124]};
reg [1:0] prevMode;
wire [1:0] modeNxt = sameFlag ? prevMode : (&tmp ? MPPF_BPSkip : tmp);
always@(posedge clk or negedge rstn)
  if(~rstn)
    prevMode <= 2'b0;
  else 
    prevMode <= modeNxt;

assign mode_header_bits = 1 + (sameFlag ? 0 : (&tmp ? 3 : 2));

//flatness header
wire flatnessFlag = sameFlag ? shifter_out[126] : (&tmp ? shifter_out[123] : shifter_out[124]);
wire [2:0] flatnessType = flatnessFlag ?( sameFlag ?{1'b0,shifter_out[125:124]}
                                                   :(&tmp ? {1'b0,shifter_out[122:121]} :{1'b0,shifter_out[123:122]}))
                                       : 4;
wire [2:0] flatness_header_bits = 1 + (flatnessFlag ? 2 : 0); 

wire [1:0] m_origSrcCsc = 0;
wire mppDecCsc = shifter_out[127-(flatness_header_bits+mode_header_bits)];
parameter Ycbcr = 2;
parameter Ycocg = 1;
parameter Rgb = 0; reg [1:0] m_nxtBlkCsc;
always@(*)begin if(modeNxt==MPP)begin if(m_origSrcCsc == Ycbcr) m_nxtBlkCsc = Ycbcr; else m_nxtBlkCsc = mppDecCsc ? Ycocg : 
Rgb; end else begin m_nxtBlkCsc = 0; end end wire csc_bits = m_origSrcCsc == Ycbcr ? 0 : 1; wire [2:0] mode_flat_csc_size = 
mode_header_bits + flatness_header_bits + csc_bits; //parse stepSize
wire [3:0] m_bitDepth = 8;
wire [2:0] numBits = m_bitDepth > 8 ? 4 : 3;
reg [2:0] nxtBlkStepSize ;
always@*
begin
  case (mode_flat_csc_size) 
  3'h1: nxtBlkStepSize = shifter_out[126:124];
  3'h2: nxtBlkStepSize = shifter_out[125:123];
  3'h3: nxtBlkStepSize = shifter_out[124:122];
  3'h4: nxtBlkStepSize = shifter_out[123:121];
  3'h5: nxtBlkStepSize = shifter_out[122:120];
  3'h6: nxtBlkStepSize = shifter_out[121:119];
  3'h7: nxtBlkStepSize = shifter_out[120:118];
  default : nxtBlkStepSize = 0;
  endcase
end

always@*
begin
  case (mode_flat_csc_size) 
  3'h1:     suffix = {shifter_out[123:0],4'b0};
  3'h2:     suffix = {shifter_out[122:0],5'b0};
  3'h3:     suffix = {shifter_out[121:0],6'b0};
  3'h4:     suffix = {shifter_out[120:0],7'b0};
  3'h5:     suffix = {shifter_out[119:0],8'b0};
  3'h6:     suffix = {shifter_out[118:0],9'b0};
  3'h7:     suffix = {shifter_out[117:0],10'b0};
  default : suffix = 0;
  endcase
end


//decodeMppSuffix
wire [1:0] curSuffixCsc = m_nxtBlkCsc;
wire [3:0] bitDepth_comp0 = m_bitDepth;

//ssm0
always@*begin
  case (curSuffixCsc)
    Rgb,Ycbcr : stepSize_ssm0 = nxtBlkStepSize;
    Ycocg : stepSize_ssm0 = nxtBlkStepSize;
  default :stepSize_ssm0 = nxtBlkStepSize;
endcase
end

assign  nxtBlkbitsSsm0 = rd_shifter_rqst ? qres_size + mode_flat_csc_size + numBits : 0;

end
endgenerate

generate 
begin
if(ssm_idx==1)
begin
assign suffix = shifter_out[127:0];
assign  nxtBlkbitsSsm0 = rd_shifter_rqst ? qres_size  : 0;
end
end
endgenerate

decMppSuffix #(.ssm_idx(ssm_idx))u_decMppSuffix_ssm0
(
  .bitDepth  (8/*bitDepth_comp0*/),
  .stepSize  (ssm_idx ? 2 : stepSize_ssm0),
  .suffix    (suffix),
  .pnxtBlkQuant(pnxtBlkQuant),
  .suffix_left(suffix_rmc0),
  .qres_size(qres_size)
);

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
