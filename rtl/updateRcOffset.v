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
input [15:0] m_slicePixelsRemaining,
output reg [15:0] m_rcOffsetInit
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

// if(m_numPixelsCoded >= Th)
endmodule

