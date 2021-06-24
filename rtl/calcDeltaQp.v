module calcDeltaQp
(
input [15:0] r_sliceHeight,
input [15:0] m_rcFullness,
input [8:0] diffBits,
output reg [3:0] deltaQp
);
wire [5*7-1:0] g_qpIndexThresholdPositive = { 7'd10, 7'd29, 7'd50, 7'd60, 7'd70 }; // 4:4:4

wire [4*7-1:0] g_qpIndexThresholdNegative = { 7'd10, 7'd20, 7'd35, 7'd65 }; // 4:4:4

wire [8:0] absdiff = diffBits[8] ? ~diffBits+1 : diffBits;

reg [2:0] qpidx;

reg [2:0] qpUpmode;
always@(*)begin
  if(m_rcFullness >= 57672)
    qpUpmode = 2;
  else if(m_rcFullness >= 49807)
    qpUpmode = 1;
  else if(m_rcFullness <= 7864)
    qpUpmode = 4;
  else if(m_rcFullness <= 15729)
    qpUpmode = 3;
  else
    qpUpmode = 0;
end

always@(*) begin
  if(diffBits[8] | (~(|diffBits))) begin
     if(absdiff < g_qpIndexThresholdNegative[4*7-1-:7])
       qpidx = 0;
     else if(absdiff < g_qpIndexThresholdNegative[3*7-1-:7])
       qpidx = 1;
     else if(absdiff < g_qpIndexThresholdNegative[2*7-1-:7])
       qpidx = 2;
     else if(absdiff < g_qpIndexThresholdNegative[1*7-1-:7])
       qpidx = 3;
     else 
       qpidx = 4;
  end else begin
     if(absdiff < g_qpIndexThresholdPositive[5*7-1-:7])
       qpidx = 0;
     else if(absdiff < g_qpIndexThresholdPositive[4*7-1-:7])
       qpidx = 1;
     else if(absdiff < g_qpIndexThresholdPositive[3*7-1-:7])
       qpidx = 2;
     else if(absdiff < g_qpIndexThresholdPositive[2*7-1-:7])
       qpidx = 3;
     else if(absdiff < g_qpIndexThresholdPositive[1*7-1-:7])
       qpidx = 4;
     else 
       qpidx = 5;
  end
end


wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_0 = { 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5 };// normal operation 
wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_1 = { 4'd1, 4'd3, 4'd5, 4'd6, 4'd6, 4'd6 };// rcFullness >= 76
wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_2 = { 4'd2, 4'd4, 4'd5, 4'd6, 4'd7, 4'd7 };// rcFullness >= 88
wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_3 = { 4'hF, 4'h0, 4'h1, 4'h1, 4'h2, 4'h2 };// rcFullness <= 24
wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_4 = { 4'hE, 4'hF, 4'hf, 4'h0, 4'h1, 4'h1 };// rcFullness <= 12

wire [6*4-1:0] g_iQpIncrement_0 = { 4'h0, 4'h1, 4'h2, 4'h3, 4'h4, 4'h5 };    // normal operation 
wire [6*4-1:0] g_iQpIncrement_1 = { 4'h1, 4'h2, 4'h3, 4'h5, 4'h5, 4'h6 };    // rcFullness >= 76
wire [6*4-1:0] g_iQpIncrement_2 = { 4'h2, 4'h3, 4'h4, 4'h6, 4'h7, 4'h7 };    // rcFullness >= 88
wire [6*4-1:0] g_iQpIncrement_3 = { 4'hf, 4'h0, 4'h1, 4'h1, 4'h2, 4'h2 };    // rcFullness <= 24
wire [6*4-1:0] g_iQpIncrement_4 = { 4'he, 4'hf, 4'hf, 4'h0, 4'h1, 4'h1 };    // rcFullness <= 24

wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_0 = { 4'h0, 4'h1, 4'h2, 4'h3, 4'h4 }; // normal operation 
wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_1 = { 4'hf, 4'h0, 4'h0, 4'h1, 4'h1 }; // rcFullness >= 76
wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_2 = { 4'he, 4'he, 4'h0, 4'h1, 4'h1 }; // rcFullness >= 88
wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_3 = { 4'h1, 4'h1, 4'h2, 4'h4, 4'h4 }; // rcFullness <= 24
wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_4 = { 4'h2, 4'h2, 4'h4, 4'h5, 4'h5 }; // rcFullness <= 12

wire [5*4-1:0] g_iQpDecrement_0 = {4'h0, 4'h1, 4'h2, 4'h3, 4'h4 };        // normal operation 
wire [5*4-1:0] g_iQpDecrement_1 = {4'hf, 4'h0, 4'h0, 4'h1, 4'h1 };        // rcFullness >= 76
wire [5*4-1:0] g_iQpDecrement_2 = {4'he, 4'he, 4'h0, 4'h1, 4'h1 };        // rcFullness >= 88
wire [5*4-1:0] g_iQpDecrement_3 = {4'h1, 4'h1, 4'h2, 4'h4, 4'h4 };        // rcFullness <= 24
wire [5*4-1:0] g_iQpDecrement_4 = {4'h2, 4'h2, 4'h4, 4'h5, 4'h5 };        // rcFullness <= 12

wire [6*4-1:0] QpIncrementTable_0 = r_sliceHeight <=32 ? g_iQpIncrementSliceHeight16And32_0 :g_iQpIncrement_0;
wire [6*4-1:0] QpIncrementTable_1 = r_sliceHeight <=32 ? g_iQpIncrementSliceHeight16And32_1 :g_iQpIncrement_1;
wire [6*4-1:0] QpIncrementTable_2 = r_sliceHeight <=32 ? g_iQpIncrementSliceHeight16And32_2 :g_iQpIncrement_2;
wire [6*4-1:0] QpIncrementTable_3 = r_sliceHeight <=32 ? g_iQpIncrementSliceHeight16And32_3 :g_iQpIncrement_3;
wire [6*4-1:0] QpIncrementTable_4 = r_sliceHeight <=32 ? g_iQpIncrementSliceHeight16And32_4 :g_iQpIncrement_4;

wire [5*4-1:0] QpDecrementTable_0 = r_sliceHeight <=32 ? g_iQpDecrementSliceHeight16And32_0 :g_iQpDecrement_0;
wire [5*4-1:0] QpDecrementTable_1 = r_sliceHeight <=32 ? g_iQpDecrementSliceHeight16And32_1 :g_iQpDecrement_1;
wire [5*4-1:0] QpDecrementTable_2 = r_sliceHeight <=32 ? g_iQpDecrementSliceHeight16And32_2 :g_iQpDecrement_2;
wire [5*4-1:0] QpDecrementTable_3 = r_sliceHeight <=32 ? g_iQpDecrementSliceHeight16And32_3 :g_iQpDecrement_3;
wire [5*4-1:0] QpDecrementTable_4 = r_sliceHeight <=32 ? g_iQpDecrementSliceHeight16And32_4 :g_iQpDecrement_4;

always@(*)begin
  if(diffBits[8] | (~(|diffBits))) begin
    case(qpUpmode)
      3'h0: deltaQp = ~QpDecrementTable_0[(5-qpidx)*4-1-:4] + 1;
      3'h1: deltaQp = ~QpDecrementTable_1[(5-qpidx)*4-1-:4] + 1;
      3'h2: deltaQp = ~QpDecrementTable_2[(5-qpidx)*4-1-:4] + 1;
      3'h3: deltaQp = ~QpDecrementTable_3[(5-qpidx)*4-1-:4] + 1;
      3'h3: deltaQp = ~QpDecrementTable_3[(5-qpidx)*4-1-:4] + 1;
    default:deltaQp = ~QpDecrementTable_3[(5-qpidx)*4-1-:4] + 1;
    endcase
  end else begin
    case(qpUpmode)
      3'h0: deltaQp = QpIncrementTable_0[(6-qpidx)*4-1-:4];
      3'h1: deltaQp = QpIncrementTable_1[(6-qpidx)*4-1-:4];
      3'h2: deltaQp = QpIncrementTable_2[(6-qpidx)*4-1-:4];
      3'h3: deltaQp = QpIncrementTable_3[(6-qpidx)*4-1-:4];
      3'h3: deltaQp = QpIncrementTable_3[(6-qpidx)*4-1-:4];
    default:deltaQp = QpIncrementTable_3[(6-qpidx)*4-1-:4];
    endcase
  end
end
endmodule
