module decMpp_com
(
  input clk,
  input rstn,
  input blk_vld,
  input [15:0] blkcounter,
  input [7:0] c0[0:15]
);
wire [7:0] c0[0:15];

wire [7:0] m_bitDepth = 8;
wire [7:0] clipMax = (1<<m_bitDepth) -1;
wire [7:0] clipMinc0 = 0;
wire [7:0] mp ;//= 8'h84;
wire [2:0] curStepSize = 2;
wire [8:0] pRec0 [0:15];
wire [8:0] pRec1 [0:15];
wire [8:0] pRec2 [0:15];
genvar i;
generate
for(i=0;i<16;i=i+1)begin
  wire [8:0] deQuant_c0; 
  assign deQuant_c0 =c0[i]<<curStepSize ;
  assign pRec0[i] = clip3(clipMax,clipMinc0,$signed(deQuant_c0)+mp);
end
endgenerate

reg [10:0] mean_c0[0:3];
always@(posedge clk or rstn)
  if(blk_vld)
    if(blkcounter==0)
      mean_c0[0] = 1<<(8-1);
    else 
      mean_c0[0] = (pRec0[0]+pRec0[1] + pRec0[8] + pRec0[9])>>2;
wire [7:0] middle = 1<<(m_bitDepth-1);
wire [3:0] m_bitDepth = 8;
wire [3:0] curStepSize =2;
wire [3:0] curBias = curStepSize == 0 ? 0 : 1<<(curStepSize-1);
wire [9:0] maxClip = (1<<m_bitDepth)-1 < (middle+2*curBias) ? (1<<m_bitDepth)-1 : (middle+2*curBias);
assign mp = clip3(maxClip,middle,mean_c0[0]+2*curBias);

function [7:0] clip3;
  input [7:0] clipMax;
  input [7:0] clipMin;
  input [7:0] rec;

  clip3 =  rec>clipMax ? clipMax : (rec<clipMin ? clipMin : rec);
endfunction




endmodule
