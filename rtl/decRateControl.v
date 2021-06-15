module decRateControl
(
input clk,
input rstn,
input start_dec_ff1,

input isFls, 
input [7:0]nxtBlkbitsSsm0 ,
input [7:0]nxtBlkbitsSsm1 ,
input [7:0]nxtBlkbitsSsm2 ,
input [7:0]nxtBlkbitsSsm3 ,

input [7:0] r_initTxDelay,
input [15:0] r_rcBufferFullnessOffsetThd,
input [23:0] r_rcFullnessSlope,
input [7:0] r_rcFullnessScale,
input [15:0] r_sliceWidth,
input [16*8-1:0] r_tgt_rate_delta_lut,
input [8*8-1:0] r_max_qp_lut,

output [7:0] m_qp
);

reg [7:0]nxtBlkbitsSsm0_ff;
reg [9:0] prevBits;
wire [9:0] curBlkBits;
reg [9:0] prevBlkBits;
reg [15:0] m_slicePixelsRemaining;

always@(posedge clk or negedge rstn)
  if(!rstn)
    nxtBlkbitsSsm0_ff <= 8'b0;
  else
    nxtBlkbitsSsm0_ff <= nxtBlkbitsSsm0;
wire [9:0] postBits = nxtBlkbitsSsm0_ff + nxtBlkbitsSsm1+ nxtBlkbitsSsm2+ nxtBlkbitsSsm3;
always@(posedge clk or negedge rstn)
  if(!rstn)
    prevBits <= 10'b0;
  else
    prevBits <= postBits;;
  
assign curBlkBits = postBits-prevBits;
always@(posedge clk or negedge rstn)
  if(!rstn)
    prevBlkBits <= 10'b0;
  else
    prevBlkBits <= postBits;//curBlkBits;;
  
wire [15:0] m_numPixelsCoded;
wire [15:0] m_bufferFullness;
decBufferFullnes  u_decBufferFullnes (
    .clk                     ( clk                ),
    .rstn                    ( rstn               ),
    .start_dec_ff1           ( start_dec_ff1      ),
    .prevBlkBits             ( prevBlkBits  [9:0] ),
    .m_numPixelsCoded        ( m_numPixelsCoded   ),
    .m_bufferFullness        ( m_bufferFullness   )
);

wire [7:0] m_numBlksInLine = r_sliceWidth[10:3];
//wire [7:0] m_numBlksInSlice;
wire [15:0] m_rcOffsetInit;
updateRcOffset  u_updateRcOffset (
    .clk                          ( clk                                 ),
    .rstn                         ( rstn                                ),
    .start_dec_ff1                ( start_dec_ff1                       ),
    .m_numBlksInLine              ( m_numBlksInLine              [7:0]  ),
//    .m_numBlksInSlice             ( m_numBlksInSlice             [7:0]  ),
    .r_initTxDelay                ( r_initTxDelay                [7:0]  ),
    .r_rcBufferFullnessOffsetThd  ( r_rcBufferFullnessOffsetThd  [15:0] ),
    .r_rcFullnessSlope            ( r_rcFullnessSlope            [23:0] ),
    .m_numPixelsCoded             ( m_numPixelsCoded             [15:0] ),
    .m_slicePixelsRemaining       ( m_slicePixelsRemaining       [15:0] ),
    .m_rcOffsetInit               ( m_rcOffsetInit                      )
);
wire [15:0] m_rcOffset=0;
wire [31:0] temp = r_rcFullnessScale * (m_bufferFullness + m_rcOffset + m_rcOffsetInit);
wire [15:0] m_rcFullness = temp[31:4] > (1<<16)-1 ?  (1<<16)-1 :temp[19:4];

//wire [8:0] prevBlockBits='d296;
wire [8:0] targetBits ;//= 'd222;
wire [8:0] diffBits = prevBlkBits -targetBits;
wire [2:0] deltaQp = 5;
reg [7:0] maxQp ;//= 32;
wire [7:0] minQp = 16;
reg [3:0] minQpOffset ;//= 0;//8;
wire [15:0] m_rcBufferInitSize=8192;

always@(*)begin
  if(m_rcFullness>62259)
    maxQp = 4 + r_max_qp_lut[(8-7)*8-1-:8];
  else
    maxQp = r_max_qp_lut[(8-m_rcFullness[15:13])*8-1-:8];
end

always@(*)begin
  if((m_bufferFullness <= m_rcBufferInitSize/2) | m_rcFullness < 9830)
    minQpOffset = 0;
  else
    minQpOffset = 8;
end

reg [7:0] m_qp_prev;// = 36;
wire [7:0] m_qp_sel ;
assign m_qp_sel = clip3(maxQp,minQp+minQpOffset,m_qp_prev+deltaQp);

//wire [7:0] m_qp;
//wire isFls = 1;
//wire [15:0] m_rcFullness = 26125;
assign m_qp = isFls & m_rcFullness <= 62915 ? (m_qp_sel > maxQp ? maxQp : m_qp_sel) : m_qp_sel;


always@(posedge clk or negedge rstn)
  if(!rstn)
    m_qp_prev <= 'd36;
  else if(start_dec_ff1)
    m_qp_prev <= m_qp;


//calcTargetRate
wire [9:0] m_slicebitsCurrent =prevBits;
wire [31:0] m_slicesBitsTotal = 172800;
reg [31:0] bitsRemaining_prev;
//wire [31:0] bitsRemaining =m_slicesBitsTotal - m_slicebitsCurrent - 896;
wire [31:0] bitsRemaining =bitsRemaining_prev - m_slicebitsCurrent ;
always@(posedge clk or negedge rstn)
  if(!rstn)
    m_slicePixelsRemaining <= 'd21600;
  else if(start_dec_ff1)
    m_slicePixelsRemaining <= m_slicePixelsRemaining - 16;

always@(posedge clk or negedge rstn)
  if(!rstn)
    bitsRemaining_prev <= m_slicesBitsTotal- 896;
  else if(start_dec_ff1)
    bitsRemaining_prev  <= bitsRemaining;

reg [4:0] m_tgtRateSacle_prev;
reg [15:0] m_tgtRateThd_prev;
reg [4:0] m_tgtRateSacle;
reg [15:0] m_tgtRateThd;
always@(*)begin
  if(m_slicePixelsRemaining <= m_tgtRateThd_prev)begin
    m_tgtRateSacle = m_tgtRateSacle_prev -1;
    m_tgtRateThd = 1<<(m_tgtRateSacle-1);
  end else begin
    m_tgtRateSacle = m_tgtRateSacle_prev;
    m_tgtRateThd = m_tgtRateThd_prev;
  end
end
always@(posedge clk or negedge rstn)
  if(!rstn)begin
    m_tgtRateSacle_prev <= 'd16;
    m_tgtRateThd_prev <= 'd32768;
  end else if(start_dec_ff1)begin
    m_tgtRateSacle_prev <= m_tgtRateSacle;
    m_tgtRateThd_prev <= m_tgtRateThd;
  end

wire  [32*7-1:0]g_targetRateInverseLut = {
    7'd126, 7'd122, 7'd119, 7'd115, 7'd112, 7'd109, 7'd106, 7'd103, 7'd101, 7'd98, 7'd96, 7'd94, 7'd92, 7'd90, 7'd88, 7'd86,
    7'd84, 7'd82, 7'd81, 7'd79, 7'd78, 7'd76, 7'd75, 7'd73, 7'd72, 7'd71, 7'd70, 7'd68, 7'd67, 7'd66, 7'd65, 7'd64};


wire [15:0] g_rc_tgtRateLutScaleBits =6;
wire [31:0] pTemp = m_slicePixelsRemaining << g_rc_tgtRateLutScaleBits;
wire [63:0] poffset = 1<<(m_tgtRateSacle-1);
wire [31:0] pMax = (1<<g_rc_tgtRateLutScaleBits) -1;
wire [31:0] p_tmp = (pTemp+poffset)>>m_tgtRateSacle;
wire [31:0] p = p_tmp > pMax ? pMax : p_tmp;
wire [31:0] scale = m_tgtRateSacle + g_rc_tgtRateLutScaleBits;
wire [63:0] baseTgtRateTemp = bitsRemaining * 16 * g_targetRateInverseLut[(32-(p-32))*7-1-:7];
wire [63:0] offset = 1<<(scale-1);
wire [31:0] baseTgtRate = (baseTgtRateTemp + offset) >> scale ;

wire [31:0] baseTgtRate_fls = isFls ? baseTgtRate + 2*16 : baseTgtRate;

wire [31:0] tgtRateShift = 16 -4;
wire [31:0] clipMax = (1<<4)-1;
wire [31:0] index_tmp = (m_rcFullness + (1<<(tgtRateShift-1)) )>> tgtRateShift;
wire [31:0] index = clip3(clipMax,0,index_tmp);

assign targetBits =  baseTgtRate_fls + r_tgt_rate_delta_lut[(16-index)*8-1-:8];


function [7:0] clip3;
  input [7:0] clipMax;
  input [7:0] clipMin;
  input [7:0] rec;

  clip3 =  rec>clipMax ? clipMax : (rec<clipMin ? clipMin : rec);
endfunction
endmodule

