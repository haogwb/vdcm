module parseEcg #(parameter ssm_idx = 0,ecg_idx=0)
(
  input mode_XFM,
  input [127:0] suffix,
  input [2:0]ecNumSample,
  output [6:0] m_signBitValid,
  output [7:0] numbits,
  output [8:0] coeff_0,
  output [8:0] coeff_1,
  output [8:0] coeff_2,
  output [8:0] coeff_3,
  output [8:0] coeff_4,
  output [8:0] coeff_5,
  output [8:0] coeff_6
  

);
//reg [127:0] suffix_left;
parameter kEcXfm = 0;
wire [3:0]m_modeType = 0;
wire [3:0] numBitsLastSigPos = 4;
wire isCompSkip = 0;
//reg  [3:0] lastSigPos;
//
//always@(*)
//begin
//  if(mode_XFM & m_modeType==kEcXfm & ~isCompSkip)
//    case(numBitsLastSigPos)
//      4'h2: lastSigPos = suffix[127-:2];
//      4'h3: lastSigPos = suffix[127-:3];
//      4'h4: lastSigPos = suffix[127-:4];
//      default :lastSigPos = 0;
//    endcase
//   else
//      lastSigPos = 0;
//end
//
//ECG , decode

wire value;
assign value = suffix[127-:1];//parse group skip flag

//decode Ecg prefix
//wire uiBits = suffix[127-numBitsLastSigPos-1-:1];
wire [7:0] uiBits = suffix[127-1-:8];
reg [3:0] prefix;
always@(*)
begin
  prefix = 0;
  casez (uiBits)
    8'b0???_????: prefix = 0;
    8'b10??_????: prefix = 1;
    8'b110?_????: prefix = 2;
    8'b1110_????: prefix = 3;
    8'b1111_0???: prefix = 4;
    8'b1111_10??: prefix = 5;
    8'b1111_110?: prefix = 6;
    8'b1111_1110: prefix = 7;
    8'b1111_1111: prefix = 8;
    default:prefix = 0;
  endcase
end

//always@(*)
//begin
//  suffix_rm_prefix = 0;
//  casez (uiBits)
//    8'b0???_????: suffix_rm_prefix = suffix[127-numBitsLastSigPos-1-1:0],;
//    8'b10??_????: suffix_rm_prefix = 1;
//    8'b110?_????: suffix_rm_prefix = 2;
//    8'b1110_????: suffix_rm_prefix = 3;
//    8'b1111_0???: suffix_rm_prefix = 4;
//    8'b1111_10??: suffix_rm_prefix = 5;
//    8'b1111_110?: suffix_rm_prefix = 6;
//    8'b1111_1110: suffix_rm_prefix = 7;
//    8'b1111_1111: suffix_rm_prefix = 8;
//    default:suffix_rm_prefix = 0;
//  endcase
//end

reg [127:0] suffix_of_ec; 
wire [7:0] size_before_ec = 1+(prefix+1);
always@(*)
begin
  case(size_before_ec)
    8'h3:suffix_of_ec = {suffix[127-3:0],3'b0};
    8'h4:suffix_of_ec = {suffix[127-4:0],4'b0};
    8'h5:suffix_of_ec = {suffix[127-5:0],5'b0};
    8'h6:suffix_of_ec = {suffix[127-6:0],6'b0};
    8'h7:suffix_of_ec = {suffix[127-7:0],7'b0};
    8'h8:suffix_of_ec = {suffix[127-8:0],8'b0};
    8'h9:suffix_of_ec = {suffix[127-9:0],9'b0};
  endcase
end

//page68 , bitsReq : size is 1 to (bpc+2)
wire [3:0]bitsReq_kEcXfm = GetBitsReqFromCodeWord(prefix,ssm_idx-1);
wire [3:0]bitsReq = m_modeType==kEcXfm ? bitsReq_kEcXfm+1 : prefix+1;

wire [2:0] ecgIdx = ecg_idx;
wire useSignMag = ecgIdx < 3 ? 1 : 0;
//decodeVecEcSymbolSM

wire [1:0] VecThd=2;
wire dec_CPEC = (bitsReq > VecThd ) | mode_XFM ;
//decode cpec ecg
wire [3:0] ecgSt = 4;
wire [3:0] ecgEd = 9;
wire [7:0]src_4 = suffix_of_ec[127-:4];//suffix[127-numBitsLastSigPos-1-(prefix+1)-:4];
wire [7:0]src_5 = suffix_of_ec[127-4-:4];
wire [7:0]src_6 = suffix_of_ec[127-4*2-:4];
wire [7:0]src_7 = suffix_of_ec[127-4*3-:4];
wire [7:0]src_8 = suffix_of_ec[127-4*4-:4];

wire [7:0]src_1 = suffix_of_ec[127-:3];//suffix[127-numBitsLastSigPos-1-(prefix+1)-:4];
wire [7:0]src_2 = suffix_of_ec[127-3-:3];
wire [7:0]src_3 = suffix_of_ec[127-3*2-:3];

reg [7:0] src_tmp0;
reg [7:0] src_tmp1;
reg [7:0] src_tmp2;
reg [7:0] src_tmp3;
reg [7:0] src_tmp4;
reg [7:0] src_tmp5;
reg [7:0] src_tmp6;
always@(*)
begin
  case(bitsReq)
    8'h1 : src_tmp0 = suffix_of_ec[127-:1];
    8'h2 : src_tmp0 = suffix_of_ec[127-:2];
    8'h3 : src_tmp0 = suffix_of_ec[127-:3];
    8'h4 : src_tmp0 = suffix_of_ec[127-:4];
    8'h5 : src_tmp0 = suffix_of_ec[127-:5];
    8'h6 : src_tmp0 = suffix_of_ec[127-:6];
    8'h7 : src_tmp0 = suffix_of_ec[127-:7];
    8'h8 : src_tmp0 = suffix_of_ec[127-:8];
    8'h9 : src_tmp0 = suffix_of_ec[127-:9];
    8'h10 : src_tmp0 = suffix_of_ec[127-:10];
    default: src_tmp0 = 'bx;
  endcase
end
always@(*)
begin
  case(bitsReq)
    8'h1 : src_tmp1 = suffix_of_ec[127-1-:1];
    8'h2 : src_tmp1 = suffix_of_ec[127-2-:2];
    8'h3 : src_tmp1 = suffix_of_ec[127-3-:3];
    8'h4 : src_tmp1 = suffix_of_ec[127-4-:4];
    8'h5 : src_tmp1 = suffix_of_ec[127-5-:5];
    8'h6 : src_tmp1 = suffix_of_ec[127-6-:6];
    8'h7 : src_tmp1 = suffix_of_ec[127-7-:7];
    8'h8 : src_tmp1 = suffix_of_ec[127-8-:8];
    8'h9 : src_tmp1 = suffix_of_ec[127-9-:9];
    8'h10 : src_tmp1 = suffix_of_ec[127-10-:10];
    default: src_tmp1 = 'bx;
  endcase
end
always@(*)
begin
  case(bitsReq)
    8'h1 : src_tmp2 = suffix_of_ec[127-2*1-:1];
    8'h2 : src_tmp2 = suffix_of_ec[127-2*2-:2];
    8'h3 : src_tmp2 = suffix_of_ec[127-2*3-:3];
    8'h4 : src_tmp2 = suffix_of_ec[127-2*4-:4];
    8'h5 : src_tmp2 = suffix_of_ec[127-2*5-:5];
    8'h6 : src_tmp2 = suffix_of_ec[127-2*6-:6];
    8'h7 : src_tmp2 = suffix_of_ec[127-2*7-:7];
    8'h8 : src_tmp2 = suffix_of_ec[127-2*8-:8];
    8'h9 : src_tmp2 = suffix_of_ec[127-2*9-:9];
    8'h10 : src_tmp2 = suffix_of_ec[127-2*10-:10];
    default: src_tmp2 = 'bx;
  endcase
end
always@(*)
begin
  case(bitsReq)
    8'h1 : src_tmp3 = suffix_of_ec[127-3*1-:1];
    8'h2 : src_tmp3 = suffix_of_ec[127-3*2-:2];
    8'h3 : src_tmp3 = suffix_of_ec[127-3*3-:3];
    8'h4 : src_tmp3 = suffix_of_ec[127-3*4-:4];
    8'h5 : src_tmp3 = suffix_of_ec[127-3*5-:5];
    8'h6 : src_tmp3 = suffix_of_ec[127-3*6-:6];
    8'h7 : src_tmp3 = suffix_of_ec[127-3*7-:7];
    8'h8 : src_tmp3 = suffix_of_ec[127-3*8-:8];
    8'h9 : src_tmp3 = suffix_of_ec[127-3*9-:9];
    8'h10 : src_tmp3 = suffix_of_ec[127-3*10-:10];
    default: src_tmp3 = 'bx;
  endcase
end
always@(*)
begin
  case(bitsReq)
    8'h1 : src_tmp4 = suffix_of_ec[127-4*1-:1];
    8'h2 : src_tmp4 = suffix_of_ec[127-4*2-:2];
    8'h3 : src_tmp4 = suffix_of_ec[127-4*3-:3];
    8'h4 : src_tmp4 = suffix_of_ec[127-4*4-:4];
    8'h5 : src_tmp4 = suffix_of_ec[127-4*5-:5];
    8'h6 : src_tmp4 = suffix_of_ec[127-4*6-:6];
    8'h7 : src_tmp4 = suffix_of_ec[127-4*7-:7];
    8'h8 : src_tmp4 = suffix_of_ec[127-4*8-:8];
    8'h9 : src_tmp4 = suffix_of_ec[127-4*9-:9];
    8'h10 : src_tmp4 = suffix_of_ec[127-4*10-:10];
    default: src_tmp4 = 'bx;
  endcase
end

always@(*)
begin
  case(bitsReq)
    8'h1 : src_tmp5 = suffix_of_ec[127-5*1-:1];
    8'h2 : src_tmp5 = suffix_of_ec[127-5*2-:2];
    8'h3 : src_tmp5 = suffix_of_ec[127-5*3-:3];
    8'h4 : src_tmp5 = suffix_of_ec[127-5*4-:4];
    8'h5 : src_tmp5 = suffix_of_ec[127-5*5-:5];
    8'h6 : src_tmp5 = suffix_of_ec[127-5*6-:6];
    8'h7 : src_tmp5 = suffix_of_ec[127-5*7-:7];
    8'h8 : src_tmp5 = suffix_of_ec[127-5*8-:8];
    8'h9 : src_tmp5 = suffix_of_ec[127-5*9-:9];
    8'h10 : src_tmp5 = suffix_of_ec[127-5*10-:10];
    default: src_tmp5 = 'bx;
  endcase
end


always@(*)
begin
  case(bitsReq)
    8'h1 : src_tmp6 = suffix_of_ec[127-6*1-:1];
    8'h2 : src_tmp6 = suffix_of_ec[127-6*2-:2];
    8'h3 : src_tmp6 = suffix_of_ec[127-6*3-:3];
    8'h4 : src_tmp6 = suffix_of_ec[127-6*4-:4];
    8'h5 : src_tmp6 = suffix_of_ec[127-6*5-:5];
    8'h6 : src_tmp6 = suffix_of_ec[127-6*6-:6];
    8'h7 : src_tmp6 = suffix_of_ec[127-6*7-:7];
    8'h8 : src_tmp6 = suffix_of_ec[127-6*8-:8];
    8'h9 : src_tmp6 = suffix_of_ec[127-6*9-:9];
    8'h10 : src_tmp6 = suffix_of_ec[127-6*10-:10];
    default: src_tmp6 = 'bx;
  endcase
end

wire[7:0] signBitVld_mask = (1<<ecNumSample) - 1;
wire [6:0]m_signBitValid_all;
assign m_signBitValid_all[0] = value ? 0 : |src_tmp0;
assign m_signBitValid_all[1] = value ? 0 : |src_tmp1;
assign m_signBitValid_all[2] = value ? 0 : |src_tmp2;
assign m_signBitValid_all[3] = value ? 0 : |src_tmp3;
assign m_signBitValid_all[4] = value ? 0 : |src_tmp4;
assign m_signBitValid_all[5] = value ? 0 : |src_tmp5;
assign m_signBitValid_all[6] = value ? 0 : |src_tmp6;
assign m_signBitValid = useSignMag ? m_signBitValid_all & signBitVld_mask[6:0] : 0;


//wire [127:0] suffix_left = {suffix_of_ec[127-4*5:0],20'b0};
assign numbits = value ? 1 : size_before_ec+ecNumSample*bitsReq; //24;

wire [7:0]th = (1<<(bitsReq-1))-1;

assign coeff_0 = value ? 0 :useSignMag ? src_tmp0 : src_c2(src_tmp0,th);
assign coeff_1 = value ? 0 :useSignMag ? src_tmp1 : src_c2(src_tmp1,th);
assign coeff_2 = value ? 0 :useSignMag ? src_tmp2 : src_c2(src_tmp2,th);
assign coeff_3 = value ? 0 :useSignMag ? src_tmp3 : src_c2(src_tmp3,th);
assign coeff_4 = value ? 0 :useSignMag ? src_tmp4 : src_c2(src_tmp4,th);
assign coeff_5 = value ? 0 :useSignMag ? src_tmp5 : src_c2(src_tmp5,th);
assign coeff_6 = value ? 0 :useSignMag ? src_tmp6 : src_c2(src_tmp6,th);


function [7:0]GetBitsReqFromCodeWord;
  input [7:0]codeWord;
  input [1:0] k;
  if(k==0) begin
    if(codeWord==0)
      GetBitsReqFromCodeWord = 1;
    else if(codeWord==1)
      GetBitsReqFromCodeWord = 2;
    else if(codeWord==2)
      GetBitsReqFromCodeWord = 3;
    else if(codeWord==3)
      GetBitsReqFromCodeWord = 4;
    else if(codeWord==4)
      GetBitsReqFromCodeWord = 0;
    else
      GetBitsReqFromCodeWord = codeWord;
  end else begin
    if(codeWord==0)
      GetBitsReqFromCodeWord = 1;
    else if(codeWord==1)
      GetBitsReqFromCodeWord = 0;
    else
      GetBitsReqFromCodeWord = codeWord;
  end

endfunction

function [8:0] src_c2;
  input [7:0] src;
  input [7:0] th;
  reg [8:0] neg ;
  assign neg =src - (1<<bitsReq);
  src_c2 = src > th ? neg : src;

endfunction
endmodule
