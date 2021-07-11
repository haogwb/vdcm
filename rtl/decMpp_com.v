module decMpp_com #(parameter depth=8,k=0)
(
  input clk,
  input rstn,
  input blk_vld,
  input isFls,
  input [15:0] blkcounter,
  input [depth-1:0]   prev_rec[0:15] ,
  input [7:0] c0[0:15],

  output reg [depth-1:0] pRec0 [0:15]
);
wire [7:0] c0[0:15];

wire [7:0] m_bitDepth = 8;
wire [7:0] clipMax = (1<<m_bitDepth) -1;
wire [7:0] clipMinc0 = 0;
wire [7:0] mp[0:3] ;//= 8'h84;
wire [2:0] curStepSize = 2;
genvar i;
generate
for(i=0;i<16;i=i+1)begin
  wire [8:0] deQuant_c0; 
  assign deQuant_c0 =c0[i]<<curStepSize ;
  always@*
  case(i)
    0,1,8,9:
  pRec0[i] = clip3(clipMax,clipMinc0,(k==0?{1'b0,deQuant_c0} :{deQuant_c0[8],deQuant_c0})+mp[0]);
    2,3,10,11:                                                           
  pRec0[i] = clip3(clipMax,clipMinc0,(k==0?{1'b0,deQuant_c0} :{deQuant_c0[8],deQuant_c0})+mp[1]);
    4,5,12,13:                                                          
  pRec0[i] = clip3(clipMax,clipMinc0,(k==0?{1'b0,deQuant_c0} :{deQuant_c0[8],deQuant_c0})+mp[2]);
    6,7,14,15:                                                         
  pRec0[i] = clip3(clipMax,clipMinc0,(k==0?{1'b0,deQuant_c0} :{deQuant_c0[8],deQuant_c0})+mp[3]);
  endcase
end
endgenerate

reg [10:0] mean_c0[0:3];
//always@(posedge clk or rstn)
//  if(blk_vld)
  always@(*)
    if(blkcounter==1)begin
    //if(isFls==1)begin
      mean_c0[0] = 1<<(8-1);
      mean_c0[1] = 1<<(8-1);
      mean_c0[2] = 1<<(8-1);
      mean_c0[3] = 1<<(8-1);
    end else begin
      mean_c0[0] = (prev_rec[0]+prev_rec[1] + prev_rec[08] + prev_rec[09])>>2;
      mean_c0[1] = (prev_rec[2]+prev_rec[3] + prev_rec[10] + prev_rec[11])>>2;
      mean_c0[2] = (prev_rec[4]+prev_rec[5] + prev_rec[12] + prev_rec[13])>>2;
      mean_c0[3] = (prev_rec[6]+prev_rec[7] + prev_rec[14] + prev_rec[15])>>2;
     //mean_c0[0] <= (pRec0[0]+pRec0[1] + pRec0[08] + pRec0[09])>>2;
     //mean_c0[1] <= (pRec0[2]+pRec0[3] + pRec0[10] + pRec0[11])>>2;
     //mean_c0[2] <= (pRec0[4]+pRec0[5] + pRec0[12] + pRec0[13])>>2;
     //mean_c0[3] <= (pRec0[6]+pRec0[7] + pRec0[14] + pRec0[15])>>2;
    end
wire [7:0] middle = 1<<(m_bitDepth-1);
wire [3:0] m_bitDepth = 8;
wire [3:0] curStepSize =2;
wire [3:0] curBias = curStepSize == 0 ? 0 : 1<<(curStepSize-1);
wire [9:0] maxClip = (1<<m_bitDepth)-1 < (middle+2*curBias) ? (1<<m_bitDepth)-1 : (middle+2*curBias);
assign mp[0] = clip3(maxClip,middle,mean_c0[0]+2*curBias);
assign mp[1] = clip3(maxClip,middle,mean_c0[1]+2*curBias);
assign mp[2] = clip3(maxClip,middle,mean_c0[2]+2*curBias);
assign mp[3] = clip3(maxClip,middle,mean_c0[3]+2*curBias);

function [7:0] clip3;
  input [7:0] clipMax;
  input [7:0] clipMin;
  input [8:0] rec;

  clip3 =  rec>clipMax ? clipMax : (rec<clipMin ? clipMin : rec);
endfunction




endmodule
