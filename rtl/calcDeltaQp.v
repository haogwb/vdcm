module calcDeltaQp
(
input [15:0] m_rcFullness,
input [8:0] diffBits
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
  if(diffBits[8]) begin
     if(absdiff < g_qpIndexThresholdNegative[4*7-1-:7])
       qpidx = 0;
     else if(absdiff < g_qpIndexThresholdNegative[3*7-1-:7])
       qpidx = 1;
     else if(absdiff < g_qpIndexThresholdNegative[2*7-1-:7])
       qpidx = 2;
     else if(absdiff < g_qpIndexThresholdNegative[1*7-1-:7])
       qpidx = 3;
     else 
       qpidx = 0;
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
       qpidx = 0;
  end
end


wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_0 = { 4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5 };// normal operation 
wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_1 = { 4'd1, 4'd3, 4'd5, 4'd6, 4'd6, 4'd6 };// rcFullness >= 76
wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_2 = { 4'd2, 4'd4, 4'd5, 4'd6, 4'd7, 4'd7 };// rcFullness >= 88
wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_3 = { 4'hF, 4'h0, 4'h1, 4'h1, 4'h2, 4'h2 };    // rcFullness <= 24
wire [6*4-1:0] g_iQpIncrementSliceHeight16And32_4 = { 4'hE, 4'hF, 4'hf, 4'h0, 4'h1, 4'h1 };    // rcFullness <= 12
};

wire [6*4-1:0] g_iQpIncrement_0 = { 4'h0, 4'h1, 4'h2, 4'h3, 4'h4, 4'h5 };    // normal operation 
wire [6*4-1:0] g_iQpIncrement_1 = { 4'h1, 4'h2, 4'h3, 4'h5, 4'h5, 4'h6 },    // rcFullness >= 76
wire [6*4-1:0] g_iQpIncrement_2 = { 4'h2, 4'h3, 4'h4, 4'h6, 4'h7, 4'h7 },    // rcFullness >= 88
wire [6*4-1:0] g_iQpIncrement_3 = { 4'hf, 4'h0, 4'h1, 4'h1, 4'h2, 4'h2 },    // rcFullness <= 24
};

wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_0 = { 4'h0, 4'h1, 4'h2, 4'h3, 4'h4 };        // normal operation 
wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_1 = { 4'hf, 4'h0, 4'h0, 4'h1, 4'h1 },        // rcFullness >= 76
wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_2 = { 4'he, 4'he, 4'h0, 4'h1, 4'h1 },        // rcFullness >= 88
wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_3 = { 4'h1, 4'h1, 4'h2, 4'h4, 4'h4 },        // rcFullness <= 24
wire [5*4-1:0] g_iQpDecrementSliceHeight16And32_4 = { 4'h2, 4'h2, 4'h4, 4'h5, 4'h5 },        // rcFullness <= 12

const Int g_iQpDecrement[5][5] = {
    { 0, 1, 2, 3, 4 },        // normal operation 
    { -1, 0, 0, 1, 1 },        // rcFullness >= 76
    { -2, -2, 0, 1, 1 },        // rcFullness >= 88
    { 1, 1, 2, 4, 4 },        // rcFullness <= 24
    { 2, 2, 4, 5, 5 },        // rcFullness <= 12
};
endmodule
