module decMpp
(
  input [7:0] mpp_qres_ssm0 [0:16-1],
  input [7:0] mpp_qres_ssm1 [0:16-1],
  input [7:0] mpp_qres_ssm2 [0:16-1],
  input [7:0] mpp_qres_ssm3 [0:16-1]
  

);



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

wire [7:0] m_bitDepth = 8;
wire [7:0] clipMax = (1<<m_bitDepth) -1;
wire [7:0] clipMinc0 = 0;
wire [7:0] mp = 8'h84;
wire [2:0] curStepSize = 2;
wire [8:0] pRec0 [0:15];
wire [8:0] pRec1 [0:15];
wire [8:0] pRec2 [0:15];
generate
for(i=0;i<16;i=i+1)begin
  wire [8:0] deQuant_c0; 
  assign deQuant_c0 =c0[i]<<curStepSize ;
  assign pRec0[i] = clip3(clipMax,clipMinc0,$signed(deQuant_c0)+mp);
end
for(i=0;i<16;i=i+1)begin
  wire [8:0] deQuant_c1; 
  assign deQuant_c1 =c1[i]<<curStepSize ;
  assign pRec1[i] = clip3(clipMax,clipMinc0,deQuant_c1+mp);
end
for(i=0;i<16;i=i+1)begin
  wire [8:0] deQuant_c2; 
  assign deQuant_c2 =c2[i]<<curStepSize ;
  assign pRec2[i] = clip3(clipMax,clipMinc0,deQuant_c2+mp);
end
endgenerate


function [7:0] clip3;
  input [7:0] clipMax;
  input [7:0] clipMin;
  input [7:0] rec;

  clip3 =  rec>clipMax ? clipMax : (rec<clipMin ? clipMin : rec);
endfunction

endmodule
