module decEcg_allGroups #(parameter ssm_idx = 0,comp=0)
(
  input [127:0] suffix,
  input         mode_XFM,
  output [7:0]  size
  

);

wire [7:0] numbits0;
wire [7:0] numbits1;
wire [7:0] numbits2;
wire [7:0] numbits3;

parameter kEcXfm = 0;
parameter kEcBP = 1;
wire [3:0]m_modeType = 1;
wire [3:0] numBitsLastSigPos = 4;
wire isCompSkip = ssm_idx>1 ? suffix[127]: 0;
reg  [3:0] lastSigPos;
wire [127:0] suffix_rm_compSkip = ssm_idx>1 ? {suffix[126:0],1'b0} : suffix;
always@(*)
begin
  if(mode_XFM & m_modeType==kEcXfm & ~isCompSkip)
    case(numBitsLastSigPos)
      4'h2: lastSigPos = suffix_rm_compSkip[127-:2];
      4'h3: lastSigPos = suffix_rm_compSkip[127-:3];
      4'h4: lastSigPos = suffix_rm_compSkip[127-:4];
      default :lastSigPos = 0;
    endcase
   else
      lastSigPos = 15;
end

reg [2:0]ecNumSample0;
reg [2:0]ecNumSample1;
reg [2:0]ecNumSample2;
wire [3:0]ecNumSample3;
wire [3:0]ecSt0=m_modeType==kEcXfm ? 4 : 0;
wire [3:0]ecSt1=m_modeType==kEcXfm ? 1 : 4;
wire [3:0]ecSt2=m_modeType==kEcXfm ? 9 : 8;
wire [3:0]ecSt3=m_modeType==kEcXfm ? 0 : 12;
wire [3:0]ecEd0=ecSt0 + ecNumSample0;
wire [3:0]ecEd0=ecSt1 + ecNumSample1;
wire [3:0]ecEd0=ecSt2 + ecNumSample2;
wire [3:0]ecEd0=ecSt3 + ecNumSample3;
wire [3*16-1:0]xfmEcgMappingLstSigPos0 = {3'h0,3'h0,3'h0,3'h0,3'h1,3'h2,3'h3,3'h4, 3'h5,3'h5,3'h5,3'h5,3'h5,3'h5,3'h5,3'h5};
wire [3*16-1:0]xfmEcgMappingLstSigPos1 = {3'h0,3'h1,3'h2,3'h3,3'h3,3'h3,3'h3,3'h3, 3'h3,3'h3,3'h3,3'h3,3'h3,3'h3,3'h3,3'h3};
wire [3*16-1:0]xfmEcgMappingLstSigPos2 = {3'h0,3'h0,3'h0,3'h0,3'h0,3'h0,3'h0,3'h0, 3'h0,3'h1,3'h2,3'h3,3'h4,3'h5,3'h7,3'h7};
wire [2:0]xfmEcgMappingLstSigPos3 = 1;
//assign ecNumSample0 = xfmEcgMappingLstSigPos0[lastSigPos*3];
//assign ecNumSample1 = xfmEcgMappingLstSigPos1[lastSigPos*3];
//assign ecNumSample2 = xfmEcgMappingLstSigPos2[lastSigPos*3];
assign ecNumSample3 = m_modeType == kEcBP ? 4 : 1;

wire ecgDataActive0 = |ecNumSample0 ;
wire ecgDataActive1 = |ecNumSample1 ;
wire ecgDataActive2 = |ecNumSample2 ;
wire ecgDataActive3 = |ecNumSample3 ;
always@(*)
begin
  if(m_modeType == kEcBP)begin
  case(lastSigPos)
    4'h0: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-01)-1:(15-00)*3];
    4'h1: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-02)-1:(15-01)*3];
    4'h2: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-03)-1:(15-02)*3];
    4'h3: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-04)-1:(15-03)*3];
    4'h4: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-05)-1:(15-04)*3];
    4'h5: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-06)-1:(15-05)*3];
    4'h6: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-07)-1:(15-06)*3];
    4'h7: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-08)-1:(15-07)*3];
    4'h8: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-09)-1:(15-08)*3];
    4'h9: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-10)-1:(15-09)*3];
    4'ha: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-11)-1:(15-10)*3];
    4'hb: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-12)-1:(15-11)*3];
    4'hc: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-13)-1:(15-12)*3];
    4'hd: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-14)-1:(15-13)*3];
    4'he: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-15)-1:(15-14)*3];
    4'hf: ecNumSample0 = xfmEcgMappingLstSigPos0[3*(17-16)-1:(15-15)*3];
  endcase
  end else begin
     ecNumSample0 = 4;
  end
end
always@(*)
begin
  if(m_modeType == kEcBP)begin
  case(lastSigPos)
    4'h0: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-01)-1:(15-00)*3];
    4'h1: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-02)-1:(15-01)*3];
    4'h2: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-03)-1:(15-02)*3];
    4'h3: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-04)-1:(15-03)*3];
    4'h4: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-05)-1:(15-04)*3];
    4'h5: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-06)-1:(15-05)*3];
    4'h6: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-07)-1:(15-06)*3];
    4'h7: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-08)-1:(15-07)*3];
    4'h8: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-09)-1:(15-08)*3];
    4'h9: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-10)-1:(15-09)*3];
    4'ha: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-11)-1:(15-10)*3];
    4'hb: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-12)-1:(15-11)*3];
    4'hc: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-13)-1:(15-12)*3];
    4'hd: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-14)-1:(15-13)*3];
    4'he: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-15)-1:(15-14)*3];
    4'hf: ecNumSample1 = xfmEcgMappingLstSigPos1[3*(17-16)-1:(15-15)*3];
  endcase
  end else begin
     ecNumSample1 = 4;
  end
end
always@(*)
begin
  if(m_modeType == kEcBP)begin
  case(lastSigPos)
    4'h0: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-01)-1:(15-00)*3];
    4'h1: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-02)-1:(15-01)*3];
    4'h2: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-03)-1:(15-02)*3];
    4'h3: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-04)-1:(15-03)*3];
    4'h4: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-05)-1:(15-04)*3];
    4'h5: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-06)-1:(15-05)*3];
    4'h6: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-07)-1:(15-06)*3];
    4'h7: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-08)-1:(15-07)*3];
    4'h8: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-09)-1:(15-08)*3];
    4'h9: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-10)-1:(15-09)*3];
    4'ha: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-11)-1:(15-10)*3];
    4'hb: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-12)-1:(15-11)*3];
    4'hc: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-13)-1:(15-12)*3];
    4'hd: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-14)-1:(15-13)*3];
    4'he: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-15)-1:(15-14)*3];
    4'hf: ecNumSample2 = xfmEcgMappingLstSigPos2[3*(17-16)-1:(15-15)*3];
  endcase
  end else begin
     ecNumSample2 = 4;
  end
end



wire [6:0] m_signBitValid_ecg0;
wire [6:0] m_signBitValid_ecg1;
wire [6:0] m_signBitValid_ecg2;
wire [6:0] m_signBitValid_ecg3;


wire[127:0] suffix_rm_LSigPos = m_modeType==kEcXfm ? {suffix_rm_compSkip[127-4:0],4'b0} : suffix_rm_compSkip;

wire [8:0]coeff_ec0_0;
wire [8:0]coeff_ec0_1;
wire [8:0]coeff_ec0_2;
wire [8:0]coeff_ec0_3;
wire [8:0]coeff_ec0_4;
wire [8:0]coeff_ec0_5;
wire [8:0]coeff_ec0_6;
wire [8:0]coeff_ec1_0;
wire [8:0]coeff_ec1_1;
wire [8:0]coeff_ec1_2;
wire [8:0]coeff_ec1_3;
wire [8:0]coeff_ec1_4;
wire [8:0]coeff_ec1_5;
wire [8:0]coeff_ec1_6;
wire [8:0]coeff_ec2_0;
wire [8:0]coeff_ec2_1;
wire [8:0]coeff_ec2_2;
wire [8:0]coeff_ec2_3;
wire [8:0]coeff_ec2_4;
wire [8:0]coeff_ec2_5;
wire [8:0]coeff_ec2_6;
wire [8:0]coeff_ec3_0;
wire [8:0]coeff_ec3_1;
wire [8:0]coeff_ec3_2;
wire [8:0]coeff_ec3_3;
wire [8:0]coeff_ec3_4;
wire [8:0]coeff_ec3_5;
wire [8:0]coeff_ec3_6;
parseEcg #(.ssm_idx(ssm_idx),.ecg_idx(0),.modeType(kEcBP))u_parseEcg0 //decodeOneGroup
(
  .mode_XFM   (mode_XFM),
  .suffix    (mode_XFM ? suffix_rm_LSigPos : 0),
  .ecNumSample(ecNumSample0),
  .m_signBitValid    (m_signBitValid_ecg0),
//  .suffix_left(suffix_rmc0),
  .numbits(numbits0),
  .coeff_0(coeff_ec0_0),
  .coeff_1(coeff_ec0_1),
  .coeff_2(coeff_ec0_2),
  .coeff_3(coeff_ec0_3),
  .coeff_4(coeff_ec0_4),
  .coeff_5(coeff_ec0_5),
  .coeff_6(coeff_ec0_6)
);

wire[127:0] suffix_rm_ecg0 = suffix_rm_LSigPos<<numbits0;//{suffix[127-28:0],28'b0};
parseEcg #(.ssm_idx(ssm_idx),.ecg_idx(1),.modeType(kEcBP))u_parseEcg1
(
  .mode_XFM   (mode_XFM),
  .suffix    (mode_XFM ? suffix_rm_ecg0 : 0),
  .ecNumSample(ecNumSample1),
  .m_signBitValid    (m_signBitValid_ecg1),
//  .suffix_left(suffix_rmc0),
  .numbits(numbits1),
  .coeff_0(coeff_ec1_0),
  .coeff_1(coeff_ec1_1),
  .coeff_2(coeff_ec1_2),
  .coeff_3(coeff_ec1_3),
  .coeff_4(coeff_ec1_4),
  .coeff_5(coeff_ec1_5),
  .coeff_6(coeff_ec1_6)
);

wire[127:0] suffix_rm_ecg1 = suffix_rm_ecg0<<numbits1;
parseEcg #(.ssm_idx(ssm_idx),.ecg_idx(2),.modeType(kEcBP))u_parseEcg2
(
  .mode_XFM   (mode_XFM),
  .suffix    (mode_XFM ? suffix_rm_ecg1 : 0),
  .ecNumSample(ecNumSample2),
  .m_signBitValid    (m_signBitValid_ecg2),
//  .suffix_left(suffix_rmc0),
  .numbits(numbits2),
  .coeff_0(coeff_ec2_0),
  .coeff_1(coeff_ec2_1),
  .coeff_2(coeff_ec2_2),
  .coeff_3(coeff_ec2_3),
  .coeff_4(coeff_ec2_4),
  .coeff_5(coeff_ec2_5),
  .coeff_6(coeff_ec2_6)
);

wire[127:0] suffix_rm_ecg2 = suffix_rm_ecg1<<numbits2;
parseEcg #(.ssm_idx(ssm_idx),.ecg_idx(3),.modeType(kEcBP))u_parseEcg3
(
  .mode_XFM   (mode_XFM),
  .suffix    (mode_XFM ? suffix_rm_ecg2 : 0),
  .ecNumSample(ecNumSample3),
  .m_signBitValid    (m_signBitValid_ecg3),
//  .suffix_left(suffix_rmc0),
  .numbits(numbits3),
  .coeff_0(coeff_ec3_0),
  .coeff_1(coeff_ec3_1),
  .coeff_2(coeff_ec3_2),
  .coeff_3(coeff_ec3_3),
  .coeff_4(coeff_ec3_4),
  .coeff_5(coeff_ec3_5),
  .coeff_6(coeff_ec3_6)
);

wire[127:0] suffix_rm_ecg = suffix_rm_ecg2<<numbits3;
wire[6:0] sign_bits_ec0;
wire[6:0] sign_bits_ec1;
wire[6:0] sign_bits_ec2;
wire[6:0] sign_bits_ec3;
wire [2:0] signBitVld_num_ec0; 
wire [2:0] signBitVld_num_ec1; 
wire [2:0] signBitVld_num_ec2; 
wire [2:0] signBitVld_num_ec3; 

parse_signbits_ec  u_parse_signbits_ec3 (
    .suffix                  ( suffix_rm_ecg          [127:0] ),
    .m_signBitValid          ( m_signBitValid_ecg3  [6:0]   ),

    .signBitVld_num          ( signBitVld_num_ec3     ),
    .signBit                 ( sign_bits_ec3           )
);
wire[127:0] suffix_for_ec1 = suffix_rm_ecg<<signBitVld_num_ec3;
parse_signbits_ec  u_parse_signbits_ec1 (
    .suffix                  ( suffix_for_ec1          [127:0] ),
    .m_signBitValid          ( m_signBitValid_ecg1  [6:0]   ),

    .signBitVld_num          ( signBitVld_num_ec1     ),
    .signBit                 ( sign_bits_ec1           )
);
//`parse_signbits_ec(suffix_rm_ecg,m_signBitValid_ecg1,sign_bits_ec1,signBitVld_num_ec1);

wire[127:0] suffix_for_ec0 = suffix_for_ec1<<signBitVld_num_ec1;
parse_signbits_ec  u_parse_signbits_ec0 (
    .suffix                  ( suffix_for_ec0          [127:0] ),
    .m_signBitValid          ( m_signBitValid_ecg0  [6:0]   ),

    .signBitVld_num          ( signBitVld_num_ec0     ),
    .signBit                 ( sign_bits_ec0           )
);
//`parse_signbits_ec(suffix_for_ec0,m_signBitValid_ecg0,sign_bits_ec0,signBitVld_num_ec0);

wire[127:0] suffix_for_ec2 = suffix_for_ec0<<signBitVld_num_ec0;
parse_signbits_ec  u_parse_signbits_ec2 (
    .suffix                  ( suffix_for_ec2          [127:0] ),
    .m_signBitValid          ( m_signBitValid_ecg2  [6:0]   ),

    .signBitVld_num          ( signBitVld_num_ec2     ),
    .signBit                 ( sign_bits_ec2           )
);

wire[6:0] ec3_coeff_vld=7'b0000001;
reg[6:0] ec1_coeff_vld;
reg[6:0] ec0_coeff_vld;
reg[6:0] ec2_coeff_vld;
always@(*)
begin
  case(ecNumSample1)
    3'd0: ec1_coeff_vld = 7'b0000000;
    3'd1: ec1_coeff_vld = 7'b0000001;
    3'd2: ec1_coeff_vld = 7'b0000011;
    3'd3: ec1_coeff_vld = 7'b0000111;
    3'd4: ec1_coeff_vld = 7'b0001111;
    3'd5: ec1_coeff_vld = 7'b0011111;
    3'd6: ec1_coeff_vld = 7'b0111111;
    3'd7: ec1_coeff_vld = 7'b1111111;
  endcase
end
always@(*)
begin
  case(ecNumSample0)
    3'd0: ec0_coeff_vld = 7'b0000000;
    3'd1: ec0_coeff_vld = 7'b0000001;
    3'd2: ec0_coeff_vld = 7'b0000011;
    3'd3: ec0_coeff_vld = 7'b0000111;
    3'd4: ec0_coeff_vld = 7'b0001111;
    3'd5: ec0_coeff_vld = 7'b0011111;
    3'd6: ec0_coeff_vld = 7'b0111111;
    3'd7: ec0_coeff_vld = 7'b1111111;
  endcase
end
always@(*)
begin
  case(ecNumSample2)
    3'd0: ec2_coeff_vld = 7'b0000000;
    3'd1: ec2_coeff_vld = 7'b0000001;
    3'd2: ec2_coeff_vld = 7'b0000011;
    3'd3: ec2_coeff_vld = 7'b0000111;
    3'd4: ec2_coeff_vld = 7'b0001111;
    3'd5: ec2_coeff_vld = 7'b0011111;
    3'd6: ec2_coeff_vld = 7'b0111111;
    3'd7: ec2_coeff_vld = 7'b1111111;
  endcase
end



wire [8:0]sm_coeff_ec0_0 = ~ec0_coeff_vld[0] ? 0 : sign_bits_ec0[0] ? {1'b1,~coeff_ec0_0+1'b1}: coeff_ec0_0;
wire [8:0]sm_coeff_ec0_1 = ~ec0_coeff_vld[1] ? 0 : sign_bits_ec0[1] ? {1'b1,~coeff_ec0_1+1'b1}: coeff_ec0_1;
wire [8:0]sm_coeff_ec0_2 = ~ec0_coeff_vld[2] ? 0 : sign_bits_ec0[2] ? {1'b1,~coeff_ec0_2+1'b1}: coeff_ec0_2;
wire [8:0]sm_coeff_ec0_3 = ~ec0_coeff_vld[3] ? 0 : sign_bits_ec0[3] ? {1'b1,~coeff_ec0_3+1'b1}: coeff_ec0_3;
wire [8:0]sm_coeff_ec0_4 = ~ec0_coeff_vld[4] ? 0 : sign_bits_ec0[4] ? {1'b1,~coeff_ec0_4+1'b1}: coeff_ec0_4;
wire [8:0]sm_coeff_ec0_5 = ~ec0_coeff_vld[5] ? 0 : sign_bits_ec0[5] ? {1'b1,~coeff_ec0_5+1'b1}: coeff_ec0_5;
wire [8:0]sm_coeff_ec0_6 = ~ec0_coeff_vld[6] ? 0 : sign_bits_ec0[6] ? {1'b1,~coeff_ec0_6+1'b1}: coeff_ec0_6;
wire [8:0]sm_coeff_ec1_0 = ~ec1_coeff_vld[0] ? 0 : sign_bits_ec1[0] ? {1'b1,~coeff_ec1_0+1'b1}: coeff_ec1_0;
wire [8:0]sm_coeff_ec1_1 = ~ec1_coeff_vld[1] ? 0 : sign_bits_ec1[1] ? {1'b1,~coeff_ec1_1+1'b1}: coeff_ec1_1;
wire [8:0]sm_coeff_ec1_2 = ~ec1_coeff_vld[2] ? 0 : sign_bits_ec1[2] ? {1'b1,~coeff_ec1_2+1'b1}: coeff_ec1_2;
wire [8:0]sm_coeff_ec1_3 = ~ec1_coeff_vld[3] ? 0 : sign_bits_ec1[3] ? {1'b1,~coeff_ec1_3+1'b1}: coeff_ec1_3;
wire [8:0]sm_coeff_ec1_4 = ~ec1_coeff_vld[4] ? 0 : sign_bits_ec1[4] ? {1'b1,~coeff_ec1_4+1'b1}: coeff_ec1_4;
wire [8:0]sm_coeff_ec1_5 = ~ec1_coeff_vld[5] ? 0 : sign_bits_ec1[5] ? {1'b1,~coeff_ec1_5+1'b1}: coeff_ec1_5;
wire [8:0]sm_coeff_ec1_6 = ~ec1_coeff_vld[6] ? 0 : sign_bits_ec1[6] ? {1'b1,~coeff_ec1_6+1'b1}: coeff_ec1_6;
wire [8:0]sm_coeff_ec2_0 = ~ec2_coeff_vld[0] ? 0 : sign_bits_ec2[0] ? {1'b1,~coeff_ec2_0+1'b1}: coeff_ec2_0;
wire [8:0]sm_coeff_ec2_1 = ~ec2_coeff_vld[1] ? 0 : sign_bits_ec2[1] ? {1'b1,~coeff_ec2_1+1'b1}: coeff_ec2_1;
wire [8:0]sm_coeff_ec2_2 = ~ec2_coeff_vld[2] ? 0 : sign_bits_ec2[2] ? {1'b1,~coeff_ec2_2+1'b1}: coeff_ec2_2;
wire [8:0]sm_coeff_ec2_3 = ~ec2_coeff_vld[3] ? 0 : sign_bits_ec2[3] ? {1'b1,~coeff_ec2_3+1'b1}: coeff_ec2_3;
wire [8:0]sm_coeff_ec2_4 = ~ec2_coeff_vld[4] ? 0 : sign_bits_ec2[4] ? {1'b1,~coeff_ec2_4+1'b1}: coeff_ec2_4;
wire [8:0]sm_coeff_ec2_5 = ~ec2_coeff_vld[5] ? 0 : sign_bits_ec2[5] ? {1'b1,~coeff_ec2_5+1'b1}: coeff_ec2_5;
wire [8:0]sm_coeff_ec2_6 = ~ec2_coeff_vld[6] ? 0 : sign_bits_ec2[6] ? {1'b1,~coeff_ec2_6+1'b1}: coeff_ec2_6;
wire [8:0]sm_coeff_ec3_0 = ~ec3_coeff_vld[0] ? 0 : sign_bits_ec3[0] ? {1'b1,~coeff_ec3_0+1'b1}: coeff_ec3_0;
wire [8:0]sm_coeff_ec3_1 = ~ec3_coeff_vld[1] ? 0 : sign_bits_ec3[1] ? {1'b1,~coeff_ec3_1+1'b1}: coeff_ec3_1;
wire [8:0]sm_coeff_ec3_2 = ~ec3_coeff_vld[2] ? 0 : sign_bits_ec3[2] ? {1'b1,~coeff_ec3_2+1'b1}: coeff_ec3_2;
wire [8:0]sm_coeff_ec3_3 = ~ec3_coeff_vld[3] ? 0 : sign_bits_ec3[3] ? {1'b1,~coeff_ec3_3+1'b1}: coeff_ec3_3;
wire [8:0]sm_coeff_ec3_4 = ~ec3_coeff_vld[4] ? 0 : sign_bits_ec3[4] ? {1'b1,~coeff_ec3_4+1'b1}: coeff_ec3_4;
wire [8:0]sm_coeff_ec3_5 = ~ec3_coeff_vld[5] ? 0 : sign_bits_ec3[5] ? {1'b1,~coeff_ec3_5+1'b1}: coeff_ec3_5;
wire [8:0]sm_coeff_ec3_6 = ~ec3_coeff_vld[6] ? 0 : sign_bits_ec3[6] ? {1'b1,~coeff_ec3_6+1'b1}: coeff_ec3_6;

wire [9*16-1:0] sm_coeff_fifo_ec3 =  {sm_coeff_ec3_0,sm_coeff_ec3_1,sm_coeff_ec3_2,sm_coeff_ec3_3,sm_coeff_ec3_4,sm_coeff_ec3_5,sm_coeff_ec3_6,{9{9'b0}}};
wire [9*16-1:0] sm_coeff_fifo_ec1 =  {sm_coeff_ec1_0,sm_coeff_ec1_1,sm_coeff_ec1_2,sm_coeff_ec1_3,sm_coeff_ec1_4,sm_coeff_ec1_5,sm_coeff_ec1_6,{9{9'b0}}};
wire [9*16-1:0] sm_coeff_fifo_ec0 =  {sm_coeff_ec0_0,sm_coeff_ec0_1,sm_coeff_ec0_2,sm_coeff_ec0_3,sm_coeff_ec0_4,sm_coeff_ec0_5,sm_coeff_ec0_6,{9{9'b0}}};
wire [9*16-1:0] sm_coeff_fifo_ec2 =  {sm_coeff_ec2_0,sm_coeff_ec2_1,sm_coeff_ec2_2,sm_coeff_ec2_3,sm_coeff_ec2_4,sm_coeff_ec2_5,sm_coeff_ec2_6,{9{9'b0}}};
wire [9*16-1:0] sm_coeff_fifo = sm_coeff_fifo_ec3 | sm_coeff_fifo_ec1>> ecNumSample3*9 | sm_coeff_fifo_ec0>> (ecNumSample3 + ecNumSample1) *9  | sm_coeff_fifo_ec2>> (ecNumSample3 + ecNumSample1+ ecNumSample0) *9 ; 

wire [8:0] coeff_0   = sm_coeff_fifo[16*9-1:15*9];
wire [8:0] coeff_1   = sm_coeff_fifo[15*9-1:14*9];
wire [8:0] coeff_2   = sm_coeff_fifo[14*9-1:13*9];
wire [8:0] coeff_3   = sm_coeff_fifo[13*9-1:12*9];
wire [8:0] coeff_4   = sm_coeff_fifo[12*9-1:11*9];
wire [8:0] coeff_5   = sm_coeff_fifo[11*9-1:10*9];
wire [8:0] coeff_6   = sm_coeff_fifo[10*9-1:09*9];
wire [8:0] coeff_7   = sm_coeff_fifo[09*9-1:08*9];
wire [8:0] coeff_8   = sm_coeff_fifo[08*9-1:07*9];
wire [8:0] coeff_9   = sm_coeff_fifo[07*9-1:06*9];
wire [8:0] coeff_10  = sm_coeff_fifo[06*9-1:05*9];
wire [8:0] coeff_11  = sm_coeff_fifo[05*9-1:04*9];
wire [8:0] coeff_12  = sm_coeff_fifo[04*9-1:03*9];
wire [8:0] coeff_13  = sm_coeff_fifo[03*9-1:02*9];
wire [8:0] coeff_14  = sm_coeff_fifo[02*9-1:01*9];
wire [8:0] coeff_15  = sm_coeff_fifo[01*9-1:00*9];


assign coef_size = (ssm_idx > 1 ? 1:0) + numBitsLastSigPos + numbits0 + numbits1
                   +numbits2 + numbits3+signBitVld_num_ec3+signBitVld_num_ec1
                   +signBitVld_num_ec0+signBitVld_num_ec2;
  
endmodule
