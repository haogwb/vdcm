module updateRcOffset
(
input clk,
input rstn,
input start_dec_ff1,
input [7:0] m_numBlksInLine,
input [7:0] r_initTxDelay,
input [15:0] r_rcBufferFullnessOffsetThd,
input [23:0] r_rcFullnessSlope,
input [15:0] m_numPixelsCoded,
input [15:0] m_numBlocksCoded,
input [15:0] m_slicePixelsRemaining,
output reg [15:0] m_rcOffsetInit,
output reg  [15:0] m_rcOffset
);

wire [11:0] m_numBlksInSlice = 21600/16;//m_slicePixelsRemaining[15:4];
wire [4:0] blkMaxNumPixels=16;
wire [15:0] m_rcOffsetInit=8192;
wire [7:0] m_aveBlkBits =128;
wire [11:0] Th=m_numBlksInSlice - (m_numBlksInLine * r_rcBufferFullnessOffsetThd);

always@(posedge clk or negedge rstn)
  if(!rstn)
    m_rcOffsetInit <= 'd8192;
  else if(start_dec_ff1 & (m_numPixelsCoded+16) <= r_initTxDelay * blkMaxNumPixels)
    m_rcOffsetInit <= m_rcOffsetInit - m_aveBlkBits;

reg [16:0] m_bufferFracBitsAccum;
reg [16:0] m_bufferFracBitsAccum_pre;
wire [4:0] rc_bufferOffsetPrecision = 16;
always@(posedge clk or negedge rstn)
  if(!rstn)
    m_bufferFracBitsAccum_pre <= 'd0;
  else if(start_dec_ff1)
    m_bufferFracBitsAccum_pre <= m_bufferFracBitsAccum[15:0];

reg [15:0] m_rcOffset_pre;
always@(posedge clk or negedge rstn)
  if(!rstn)
    m_rcOffset_pre <= 'd0;
  else if(start_dec_ff1)
    m_rcOffset_pre <= m_rcOffset;


always@(*)
begin
  if(m_numBlocksCoded >= Th) begin
    m_bufferFracBitsAccum = m_bufferFracBitsAccum_pre + r_rcFullnessSlope[15:0];
    if(m_slicePixelsRemaining <= blkMaxNumPixels & |m_slicePixelsRemaining & m_bufferFracBitsAccum[15:0] >= (1<<(rc_bufferOffsetPrecision-1)))
      m_rcOffset = m_rcOffset_pre + r_rcFullnessSlope[23:16] + m_bufferFracBitsAccum[16]+1;
    else
      m_rcOffset = m_rcOffset_pre + r_rcFullnessSlope[23:16] + m_bufferFracBitsAccum[16];
  end else begin
    m_bufferFracBitsAccum = m_bufferFracBitsAccum_pre;
      m_rcOffset = m_rcOffset_pre ;
  end

end

endmodule

