module decBufferFullnes
(
input clk,
input rstn,
input start_dec_ff1,
input [9:0] prevBlkBits,
output reg [15:0] m_numPixelsCoded,
output reg [15:0] m_numBlocksCoded,
output reg [15:0] m_bufferFullness
);

//reg [15:0] m_numBlocksCoded ;
reg [15:0] m_bufferFullness_prev;
wire [9:0]m_aveBlkBits=128;
always@(posedge clk or negedge rstn)
  if(!rstn)
    m_numPixelsCoded <= 8'b0;
  else if(start_dec_ff1)
    m_numPixelsCoded <= m_numPixelsCoded + 8'h10;

always@(posedge clk or negedge rstn)
  if(!rstn)
    m_numBlocksCoded <= 8'b0;
  else if(start_dec_ff1)
    m_numBlocksCoded <= m_numBlocksCoded + 8'h1;

always@(posedge clk or negedge rstn)
  if(!rstn)
    m_bufferFullness_prev <= 8'b0;
  else if(start_dec_ff1)
    m_bufferFullness_prev <= m_bufferFullness;

always@(*)begin
  if(m_numPixelsCoded <= 16*64)
    m_bufferFullness = prevBlkBits + m_bufferFullness_prev;
  else
    m_bufferFullness = prevBlkBits-m_aveBlkBits + m_bufferFullness_prev;
end

wire [15:0] m_chunkCounts = 0;
wire isEvenChunk = ~m_chunkCounts[0];
wire [9:0] m_sliceWidth=1080;
wire isSliceWidthMultipleof16 = ~(|m_sliceWidth[3:0]);
wire [9:0] chunkAdjBits =0;
wire [9:0] curChunkBits =0;
wire [9:0] nxtChunkBits =0;

reg [31:0] m_sliceBitsCur_tmp;
wire [31:0] m_sliceBitsCur = m_sliceBitsCur_tmp + prevBlkBits;
always@(posedge clk or negedge rstn)
  if(!rstn)
    m_sliceBitsCur_tmp <= 8'b0;
  else if(start_dec_ff1)
    m_sliceBitsCur_tmp <= m_sliceBitsCur;

endmodule

