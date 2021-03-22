module parseEcg #(parameter ssm_idx = 0,comp=0)
(
  input mode_XFM,
  input [127:0] suffix,
  output [7:0] numbits 
  

);
//reg [127:0] suffix_left;
parameter kEcXfm = 0;
wire [3:0]m_modeType = 0;
wire [3:0] numBitsLastSigPos = 4;
wire isCompSkip = 0;
reg  [3:0] lastSigPos;

always@(*)
begin
  if(mode_XFM & m_modeType==kEcXfm & ~isCompSkip)
    case(numBitsLastSigPos)
      4'h2: lastSigPos = suffix[127-:2];
      4'h3: lastSigPos = suffix[127-:3];
      4'h4: lastSigPos = suffix[127-:4];
      default :lastSigPos = 0;
    endcase
   else
      lastSigPos = 0;
end

//ECG , decode

wire value;
assign value = suffix[127-numBitsLastSigPos-:1];

//decode Ecg prefix
//wire uiBits = suffix[127-numBitsLastSigPos-1-:1];
wire [7:0] uiBits = suffix[127-numBitsLastSigPos-1-:8];
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
wire [7:0] size_before_ec = numBitsLastSigPos+1+(prefix+1);
always@(*)
begin
  case(size_before_ec)
    8'h8:suffix_of_ec = {suffix[127-8:0],8'b0};
    8'h9:suffix_of_ec = {suffix[127-9:0],9'b0};
  endcase
end


wire [7:0]bitsReq_kEcXfm = GetBitsReqFromCodeWord(prefix,0);
wire [7:0]bitsReq = m_modeType==kEcXfm ? bitsReq_kEcXfm+1 : prefix+1;

wire [2:0] ecgIdx = 0;
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

//wire [127:0] suffix_left = {suffix_of_ec[127-4*5:0],20'b0};
assign numbits = 28;
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
//always@*
//  case(bits)
//    8'h8:
//         suffix_left = {suffix[127-(3*4*8):0], {(3*4*8){1'b0}}};
//    8'h7:                                   
//         suffix_left = {suffix[127-(3*4*7):0], {(3*4*7){1'b0}}};
//    8'h6:                                  
//         suffix_left = {suffix[127-(3*4*6):0], {(3*4*6){1'b0}}};
//    8'h5:                                   
//         suffix_left = {suffix[127-(3*4*5):0], {(3*4*5){1'b0}}};
//  endcase
//
//assign qres_size = bits*3*4;
endmodule
