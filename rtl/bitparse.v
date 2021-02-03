module bitparse

(

input clk,

input rstn,



output codec_data_rd_en,

input [127:0] codec_data



);



wire [7:0] m_seMaxSize= 128;

wire [7:0] ssm0_fullness;

reg [7:0] ssm0_fullness_ff;

wire [7:0] ssmFunnelShiterSize = 255;//2*m_seMaxSize -1;

reg [254:0] shifter0;

reg wr_shifter0;



assign ssm0_fullness = wr_shifter0 ? ssm0_fullness_ff + 128 : ssm0_fullness_ff;



always@(posedge clk or negedge rstn)

  if(~rstn)

    ssm0_fullness_ff <= 0;

  else if(wr_shifter0)

    ssm0_fullness_ff <= ssm0_fullness;



always@(posedge clk or negedge rstn)

  if(~rstn)

    wr_shifter0 <= 0;

  else if(ssm0_fullness < m_seMaxSize)

    wr_shifter0 <= 1;

  else

    wr_shifter0 <= 0;



always@(posedge clk or negedge rstn)

  if(~rstn)

    shifter0 <= 0;

  else if(wr_shifter0)

    if(ssm0_fullness_ff==0)

      shifter0 <= {codec_data,127'b0};

    else

      shifter0 <= {shifter0[254:128],codec_data};



assign codec_data_rd_en = wr_shifter0;





wire rd_shifter_rqst =1;

reg [127:0] shifter_out;

always@(posedge clk or negedge rstn)

  if(~rstn)

    shifter_out <= 0;

  else if(ssm0_fullness_ff !=0 & rd_shifter_rqst)

    shifter_out <= shifter0[254:127];



wire [2:0] mode_header_bits;

//mode header

parameter MPP =2;

wire sameFlag = shifter_out[127];

wire [1:0] tmp = shifter_out[126:125];

wire [1:0] MPPF_BPSkip = {1'b0,shifter_out[124]};

wire [1:0] prevMode = 0;

wire [1:0] modeNxt = sameFlag ? prevMode : (&tmp ? MPPF_BPSkip : tmp);



assign mode_header_bits = 1 + (sameFlag ? 0 : (&tmp ? 3 : 2));



//flatness header

wire flatnessFlag = &tmp ? shifter_out[123] : shifter_out[124];

wire [1:0] flatnessType = flatnessFlag ?(&tmp ? shifter_out[122:121] :shifter_out[123:122] ) : 0;

wire [2:0] flatness_header_bits = 1 + (flatnessFlag ? 2 : 0); 



wire [1:0] m_origSrcCsc = 0;

wire mppDecCsc = shifter_out[127-(flatness_header_bits+mode_header_bits)];

parameter Ycbcr = 2;

parameter Ycocg = 1;

parameter Rgb = 0;

reg [1:0] m_nxtBlkCsc;

always@(*)begin

  if(modeNxt==MPP)begin

    if(m_origSrcCsc == Ycbcr) m_nxtBlkCsc = Ycbcr;

    else m_nxtBlkCsc = mppDecCsc ? Ycocg : Rgb;

  end

  else begin

    m_nxtBlkCsc = 0;

  end

end

wire csc_bits = m_origSrcCsc == Ycbcr ? 0 : 1;



//parse stepSize

wire [3:0] m_bitDepth = 8;

wire [2:0] numBits = m_bitDepth > 8 ? 4 : 3;

wire [2:0] nxtBlkStepSize = shifter_out[127-(flatness_header_bits+mode_header_bits + csc_bits) : 127-(flatness_header_bits+mode_header_bits + csc_bits)-2];

wire [2:0] stepSize_bits = numBits;



endmodule
