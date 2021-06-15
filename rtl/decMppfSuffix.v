module decMppfSuffix #(parameter ssm_idx = 0,comp=0)
(
  input [3:0] bitDepth,
  input [127:0] suffix,
  output [7:0] pnxtBlkQuant [0:16-1],
  output reg [127:0] suffix_left,
  output [7:0]  qres_size
  

);
wire[1:0] curSuffixCsc = ssm_idx == 0 ?0 :0;
wire curMppfINdex = ssm_idx == 0 ?0 :0;
wire [1:0] m_csc = curSuffixCsc;
wire [3:0] compBits=  ssm_idx==0 ? 2: 2;
reg [3:0] stepSize;
parameter Ycbcr = 2;
parameter Ycocg = 1;
parameter Rgb = 0;
always@*begin
  case (curSuffixCsc)
    Rgb,Ycbcr : stepSize = bitDepth - compBits;
//    Ycocg : stepSize = (ssm_idx) 
  default :stepSize = bitDepth - compBits;
endcase
end



wire [3:0] bits = bitDepth - stepSize;
wire [3:0] a = bits-1;
wire [7:0] minCode = 0-(1<<a);
wire [7:0] maxCode = (1<<a)-1;
reg  [7:0] val [0:16-1];

genvar i;
generate
for(i=0;i<12;i=i+1)begin
  always@*
  case(bits)
    8'h8:
         val[i] = suffix[127-(i*8):120-(i*8)];
    8'h7:
         val[i] = suffix[127-(i*7):121-(i*7)];
    8'h6:
         val[i] = suffix[127-(i*6):122-(i*6)];
    8'h5:
         val[i] = suffix[127-(i*5):123-(i*5)];
    8'h4:
         val[i] = suffix[127-(i*4):124-(i*4)];
    8'h3:
         val[i] = suffix[127-(i*3):125-(i*3)];
    8'h2:
         val[i] = suffix[127-(i*2):126-(i*2)];
    8'h1:
         val[i] = suffix[127-(i*1):127-(i*1)];
  endcase
end
endgenerate
  

wire [7:0] c0[0:3];
wire [7:0] c1[0:3];
wire [7:0] c2[0:3];
generate
for(i=0;i<4;i=i+1)begin
  assign c0[i] = val[i] + minCode;
end
endgenerate

generate
for(i=0;i<4;i=i+1)begin
  assign c1[i] = val[4+i] + minCode;
end
endgenerate

generate
for(i=0;i<4;i=i+1)begin
  assign c2[i] = val[8+i] + minCode;
end
endgenerate


generate
for(i=0;i<12;i=i+1)begin
  assign pnxtBlkQuant[i] = val[i]+minCode;
end
endgenerate


always@*
  case(bits)
    8'h8:
         suffix_left = {suffix[127-(3*4*8):0], {(3*4*8){1'b0}}};
    8'h7:                                   
         suffix_left = {suffix[127-(3*4*7):0], {(3*4*7){1'b0}}};
    8'h6:                                  
         suffix_left = {suffix[127-(3*4*6):0], {(3*4*6){1'b0}}};
    8'h5:                                   
         suffix_left = {suffix[127-(3*4*5):0], {(3*4*5){1'b0}}};
  endcase

assign qres_size = bits*3*4;
endmodule
