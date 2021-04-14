`timescale 1ns/1ps

module tb;

bit clk;

bit rstn;

initial begin

  forever #10ns clk = ~clk; 

end



initial begin

 rstn = 1'b0; 

 #20ns;

 rstn = 1'b1; 

 #4us;

 $stop;

end



bit [127:0] codec_data;
bit [127:0] codec_data_ssm1;
bit [127:0] codec_data_ssm2;
bit [127:0] codec_data_ssm3;

bit codec_data_rd_en;
bit codec_data_rd_en_ssm1;
bit codec_data_rd_en_ssm2;
bit codec_data_rd_en_ssm3;
bit start_dec;
bit start_dec_ff;
bit start_dec_ff1;
initial begin
  #1us;
  @(posedge clk) start_dec <= 1;
//  @(posedge clk) start_dec_ff = 1;
//  @(posedge clk) start_dec_ff1 = 1;
end

always@(posedge clk)
  start_dec_ff <= start_dec;

wire [7:0] mpp_qres_ssm0 [0:16-1];
reg  [7:0] mpp_qres_ssm0_ff [0:16-1];
wire [7:0] mpp_qres_ssm1 [0:16-1];
wire [7:0] mpp_qres_ssm2 [0:16-1];
wire [7:0] mpp_qres_ssm3 [0:16-1];

wire modeNxt_XFM;
wire modeNxt_BP;
wire [3:0] use2x2;
wire [3:0] modeNxt_Mpp_stepsize;
bitparse #(.ssm_idx(0)) u_bitparse(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec),
  .codec_data_rd_en (codec_data_rd_en),

  .codec_data       (codec_data),

  .modeNxt_XFM      (modeNxt_XFM),
  .modeNxt_BP       (modeNxt_BP),
  .use2x2           (use2x2),
  .modeNxt_Mpp_stepsize(modeNxt_Mpp_stepsize),
  .pnxtBlkQuant(mpp_qres_ssm0)

);
bitparse_ssm123 #(.ssm_idx(1)) u_bitparse_ssm1(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec_ff),
  .codec_data_rd_en (codec_data_rd_en_ssm1),

  .codec_data       (codec_data_ssm1),

  .modeNxt_XFM      (modeNxt_XFM),
  .modeNxt_BP       (modeNxt_BP),
  .use2x2           (use2x2[1]),
  .modeNxt_Mpp_stepsize(modeNxt_Mpp_stepsize),

  .pnxtBlkQuant(mpp_qres_ssm1)
);
bitparse_ssm123 #(.ssm_idx(2)) u_bitparse_ssm2(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec_ff),
  .codec_data_rd_en (codec_data_rd_en_ssm2),

  .codec_data       (codec_data_ssm2),

  .modeNxt_XFM      (modeNxt_XFM),
  .modeNxt_BP       (modeNxt_BP),
  .use2x2           (use2x2[2]),
  .modeNxt_Mpp_stepsize(modeNxt_Mpp_stepsize),

  .pnxtBlkQuant(mpp_qres_ssm2)
);

bitparse_ssm123 #(.ssm_idx(3)) u_bitparse_ssm3(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec_ff),
  .codec_data_rd_en (codec_data_rd_en_ssm3),

  .codec_data       (codec_data_ssm3),

  .modeNxt_XFM      (modeNxt_XFM),
  .modeNxt_BP       (modeNxt_BP),
  .use2x2           (use2x2[3]),
  .modeNxt_Mpp_stepsize(modeNxt_Mpp_stepsize),

  .pnxtBlkQuant(mpp_qres_ssm3)
);

always@(posedge clk)
  mpp_qres_ssm0_ff <= mpp_qres_ssm0;
decMpp  u_decMpp (
    .clk     (clk),
    .rstn     (rstn),
    .blk_vld         ( start_dec_ff),
    .mpp_qres_ssm0   ( mpp_qres_ssm0_ff ),
    .mpp_qres_ssm1   ( mpp_qres_ssm1 ),
    .mpp_qres_ssm2   ( mpp_qres_ssm2 ),
    .mpp_qres_ssm3   ( mpp_qres_ssm3 )
);




  

reg [127:0] codec_bits[0:100];

initial begin

$readmemh("./bits.bits",codec_bits);

end



bit [7:0] codec_rd_addr;
bit [2:0] rd_en_num;
assign rd_en_num =  codec_data_rd_en + codec_data_rd_en_ssm1 + codec_data_rd_en_ssm2 + codec_data_rd_en_ssm3;
always@(posedge clk or negedge rstn)
  if(~rstn)
    codec_rd_addr <= 0;
  else if(rd_en_num==4)
    codec_rd_addr <= codec_rd_addr + 4;
  else if(rd_en_num==3)
    codec_rd_addr <= codec_rd_addr + 3;
  else if(rd_en_num==2)
    codec_rd_addr <= codec_rd_addr + 2;
  else if(rd_en_num==1)
    codec_rd_addr <= codec_rd_addr + 1;

always@(*)
begin
  if(codec_data_rd_en)
  codec_data = codec_bits[codec_rd_addr];

  if(codec_data_rd_en & codec_data_rd_en_ssm1)
    codec_data_ssm1 = codec_bits[codec_rd_addr+1];
  else if(codec_data_rd_en_ssm1)
    codec_data_ssm1 = codec_bits[codec_rd_addr];

  if(codec_data_rd_en & codec_data_rd_en_ssm1& codec_data_rd_en_ssm2)
    codec_data_ssm2 = codec_bits[codec_rd_addr+2];
  else if((codec_data_rd_en ^ codec_data_rd_en_ssm1)& codec_data_rd_en_ssm2)
    codec_data_ssm2 = codec_bits[codec_rd_addr+1];
  else if(codec_data_rd_en_ssm2)
    codec_data_ssm2 = codec_bits[codec_rd_addr+0];

  if(codec_data_rd_en & codec_data_rd_en_ssm1& codec_data_rd_en_ssm2& codec_data_rd_en_ssm3)
    codec_data_ssm3 = codec_bits[codec_rd_addr+3];
  else if((codec_data_rd_en+codec_data_rd_en_ssm1+ codec_data_rd_en_ssm2)==2 & codec_data_rd_en_ssm3)
    codec_data_ssm3 = codec_bits[codec_rd_addr+2];
  else if((codec_data_rd_en+codec_data_rd_en_ssm1+ codec_data_rd_en_ssm2)==1 & codec_data_rd_en_ssm3)
    codec_data_ssm3 = codec_bits[codec_rd_addr+1];
  else 
    codec_data_ssm3 = codec_bits[codec_rd_addr+0];


//  if(codec_data_rd_en)

//    codec_rd_addr = codec_rd_addr + 1;

end



initial begin

    $fsdbDumpfile("test.fsdb");

    $fsdbDumpvars(0,tb);

    $fsdbDumpMDA(0, tb);

end



endmodule;
