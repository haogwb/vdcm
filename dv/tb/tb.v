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

 #2us;

 $stop;

end



bit [127:0] codec_data;

bit codec_data_rd_en;
bit start_dec;
initial begin
  #1us;
  @(posedge clk) start_dec = 1;
end
bitparse u_bitparse(

  .clk     (clk),

  .rstn     (rstn),
  .start_dec (start_dec),
  .codec_data_rd_en (codec_data_rd_en),

  .codec_data       (codec_data)

);

  

reg [127:0] codec_bits[0:20];

initial begin

$readmemh("./bits.bits",codec_bits);

end



bit [7:0] codec_rd_addr;

always@(posedge clk or negedge rstn)
  if(~rstn)
    codec_rd_addr <= 0;
  else if(codec_data_rd_en)
    codec_rd_addr <= codec_rd_addr + 1;

always@(*)
begin

  codec_data = codec_bits[codec_rd_addr];

//  if(codec_data_rd_en)

//    codec_rd_addr = codec_rd_addr + 1;

end



initial begin

    $fsdbDumpfile("test.fsdb");

    $fsdbDumpvars(0,tb);

    $fsdbDumpMDA(0, tb);

end



endmodule;
