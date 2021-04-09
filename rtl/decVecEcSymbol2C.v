module decVecEcSymbol2C #(parameter ssm_idx = 0)
(
input [127:0] suffix,
input [1:0] bitsReq,
output reg[7:0] symbol,
output reg[1:0] mask,
output [7:0] size,

output [8:0] src_0,
output [8:0] src_1,
output [8:0] src_2,
output [8:0] src_3
);


wire [2:0] vecGrk = 5;
wire [7:0] maxPrefix = ((1<<(bitsReq*4))-1) >>vecGrk;
wire [7:0] uiBits = suffix[127-:8];
reg [3:0] prefix_tmp;
always@(*)
begin
  prefix_tmp = 0;
  casez (uiBits)
    8'b0???_????: prefix_tmp = 0;
    8'b10??_????: prefix_tmp = 1;
    8'b110?_????: prefix_tmp = 2;
    8'b1110_????: prefix_tmp = 3;
    8'b1111_0???: prefix_tmp = 4;
    8'b1111_10??: prefix_tmp = 5;
    8'b1111_110?: prefix_tmp = 6;
    8'b1111_1110: prefix_tmp = 7;
    8'b1111_1111: prefix_tmp = 8;
    default:prefix_tmp = 0;
  endcase
end

wire [3:0] prefix = prefix_tmp > maxPrefix  ? maxPrefix : prefix_tmp;
wire [3:0] prefix_size = prefix+1;

wire [127:0] suffix_rm_prefix = suffix<<prefix_size;
wire [7:0] gf_suffix = suffix_rm_prefix[127-:5];//vecGrk];
wire [7:0] vecCodeNum = (prefix<<vecGrk) | gf_suffix;

wire [4*16-1:0] vec_2c_bitsReq_1_luma_inv  = { 4'h2, 4'h1, 4'h8, 4'h4, 4'h3, 4'h5, 4'h10, 4'h12, 4'h9, 4'h6, 4'h7, 4'h11, 4'h14, 4'h13, 4'h15, 4'h0 };
wire [4*16-1:0] vec_2c_bitsReq_1_chroma_inv ={ 4'h2, 4'h1, 4'h4, 4'h8, 4'h3, 4'h12, 4'h5, 4'h10, 4'h6, 4'h9, 4'h15, 4'h7, 4'h11, 4'h13, 4'h14, 4'h0 } ;
wire [256*8-1:0]vec_2c_bitsReq_2_luma_inv={ 8'h1, 8'h4, 8'h64, 8'h16, 8'h68, 8'h17, 8'h5, 8'h80, 8'h65, 8'h20, 8'h193, 8'h67, 8'h52, 8'h28, 8'h49, 8'h19, 8'h196, 8'h76, 8'h7, 8'h13, 8'h8, 8'h2, 8'h208, 8'h112, 8'h32, 8'h128, 8'h69, 8'h21, 8'h84, 8'h81, 8'h71, 8'h14, 8'h31, 8'h50, 8'h53, 8'h241, 8'h23, 8'h92, 8'h79, 8'h29, 8'h244, 8'h83, 8'h11, 8'h197, 8'h209, 8'h200, 8'h115, 8'h212, 8'h205, 8'h116, 8'h113, 8'h140, 8'h66, 8'h224, 8'h61, 8'h35, 8'h124, 8'h55, 8'h77, 8'h220, 8'h72, 8'h176, 8'h199, 8'h132, 8'h129, 8'h36, 8'h33, 8'h18, 8'h211, 8'h24, 8'h9, 8'h6, 8'h85, 8'h96, 8'h44, 8'h56, 8'h144, 8'h194, 8'h131, 8'h10, 8'h34, 8'h136, 8'h245, 8'h95, 8'h203, 8'h62, 8'h160, 8'h119, 8'h215, 8'h125, 8'h221, 8'h78, 8'h188, 8'h73, 8'h27, 8'h114, 8'h87, 8'h30, 8'h47, 8'h117, 8'h97, 8'h228, 8'h75, 8'h227, 8'h177, 8'h206, 8'h133, 8'h93, 8'h248, 8'h59, 8'h37, 8'h88, 8'h127, 8'h180, 8'h225, 8'h213, 8'h70, 8'h148, 8'h242, 8'h223, 8'h82, 8'h25, 8'h236, 8'h247, 8'h179, 8'h141, 8'h216, 8'h22, 8'h99, 8'h45, 8'h210, 8'h120, 8'h57, 8'h201, 8'h135, 8'h39, 8'h100, 8'h147, 8'h253, 8'h143, 8'h40, 8'h145, 8'h156, 8'h54, 8'h198, 8'h108, 8'h130, 8'h254, 8'h251, 8'h202, 8'h250, 8'h239, 8'h191, 8'h184, 8'h58, 8'h161, 8'h229, 8'h91, 8'h121, 8'h109, 8'h26, 8'h94, 8'h46, 8'h163, 8'h74, 8'h118, 8'h181, 8'h226, 8'h172, 8'h139, 8'h164, 8'h86, 8'h217, 8'h151, 8'h43, 8'h214, 8'h103, 8'h137, 8'h157, 8'h38, 8'h98, 8'h101, 8'h232, 8'h104, 8'h89, 8'h149, 8'h134, 8'h231, 8'h123, 8'h189, 8'h126, 8'h178, 8'h222, 8'h183, 8'h187, 8'h152, 8'h41, 8'h142, 8'h146, 8'h246, 8'h219, 8'h111, 8'h238, 8'h249, 8'h237, 8'h175, 8'h90, 8'h159, 8'h165, 8'h42, 8'h138, 8'h190, 8'h235, 8'h153, 8'h186, 8'h168, 8'h162, 8'h170, 8'h102, 8'h230, 8'h234, 8'h167, 8'h150, 8'h105, 8'h185, 8'h218, 8'h174, 8'h155, 8'h110, 8'h171, 8'h173, 8'h122, 8'h158, 8'h182, 8'h233, 8'h107, 8'h154, 8'h106, 8'h166, 8'h169, 8'h255, 8'h63, 8'h207, 8'h15, 8'h243, 8'h51, 8'h195, 8'h3, 8'h252, 8'h60, 8'h204, 8'h12, 8'h240, 8'h48, 8'h192, 8'h0 } ;
wire [256*8-1:0]vec_2c_bitsReq_2_chroma_inv={ 8'h4, 8'h1, 8'h64, 8'h16, 8'h5, 8'h80, 8'h17, 8'h68, 8'h65, 8'h20, 8'h67, 8'h52, 8'h28, 8'h193, 8'h13, 8'h76, 8'h7, 8'h112, 8'h208, 8'h49, 8'h19, 8'h196, 8'h2, 8'h8, 8'h128, 8'h32, 8'h85, 8'h21, 8'h69, 8'h81, 8'h84, 8'h10, 8'h14, 8'h11, 8'h79, 8'h53, 8'h224, 8'h176, 8'h50, 8'h241, 8'h244, 8'h31, 8'h200, 8'h29, 8'h83, 8'h197, 8'h92, 8'h160, 8'h209, 8'h71, 8'h115, 8'h205, 8'h116, 8'h55, 8'h140, 8'h35, 8'h220, 8'h95, 8'h245, 8'h77, 8'h113, 8'h66, 8'h24, 8'h36, 8'h6, 8'h129, 8'h211, 8'h124, 8'h23, 8'h212, 8'h199, 8'h56, 8'h194, 8'h61, 8'h34, 8'h9, 8'h203, 8'h144, 8'h96, 8'h18, 8'h136, 8'h62, 8'h44, 8'h132, 8'h131, 8'h33, 8'h72, 8'h250, 8'h227, 8'h221, 8'h119, 8'h188, 8'h175, 8'h254, 8'h251, 8'h59, 8'h78, 8'h206, 8'h248, 8'h239, 8'h27, 8'h228, 8'h191, 8'h47, 8'h177, 8'h236, 8'h143, 8'h242, 8'h58, 8'h202, 8'h179, 8'h114, 8'h93, 8'h223, 8'h39, 8'h170, 8'h117, 8'h30, 8'h141, 8'h247, 8'h225, 8'h213, 8'h127, 8'h253, 8'h216, 8'h54, 8'h70, 8'h75, 8'h87, 8'h180, 8'h172, 8'h133, 8'h99, 8'h90, 8'h165, 8'h37, 8'h201, 8'h82, 8'h163, 8'h238, 8'h88, 8'h145, 8'h46, 8'h26, 8'h74, 8'h156, 8'h100, 8'h187, 8'h226, 8'h215, 8'h25, 8'h161, 8'h184, 8'h125, 8'h91, 8'h94, 8'h139, 8'h97, 8'h164, 8'h181, 8'h40, 8'h229, 8'h130, 8'h135, 8'h120, 8'h57, 8'h108, 8'h148, 8'h73, 8'h22, 8'h234, 8'h198, 8'h45, 8'h210, 8'h171, 8'h147, 8'h217, 8'h174, 8'h118, 8'h38, 8'h186, 8'h137, 8'h98, 8'h157, 8'h235, 8'h152, 8'h219, 8'h190, 8'h231, 8'h178, 8'h103, 8'h232, 8'h237, 8'h142, 8'h189, 8'h138, 8'h89, 8'h43, 8'h249, 8'h126, 8'h153, 8'h149, 8'h162, 8'h42, 8'h101, 8'h102, 8'h183, 8'h111, 8'h86, 8'h246, 8'h222, 8'h123, 8'h168, 8'h159, 8'h109, 8'h151, 8'h121, 8'h134, 8'h214, 8'h218, 8'h104, 8'h41, 8'h122, 8'h146, 8'h230, 8'h155, 8'h105, 8'h150, 8'h167, 8'h173, 8'h233, 8'h185, 8'h110, 8'h158, 8'h182, 8'h107, 8'h169, 8'h154, 8'h106, 8'h166, 8'h255, 8'h63, 8'h207, 8'h15, 8'h243, 8'h51, 8'h195, 8'h3, 8'h252, 8'h60, 8'h204, 8'h12, 8'h240, 8'h48, 8'h192, 8'h0 } ; 

always@(*)
begin
  case(bitsReq)
    2'd1: symbol = ssm_idx==1 ? vec_2c_bitsReq_1_luma_inv[(16-vecCodeNum)*4-1-:4] : vec_2c_bitsReq_1_chroma_inv[(16-vecCodeNum)*4-1-:4];
    2'd2: symbol = ssm_idx==1 ? vec_2c_bitsReq_2_luma_inv[(256-vecCodeNum)*8-1-:8] : vec_2c_bitsReq_2_chroma_inv[(256-vecCodeNum)*8-1-:8];
  endcase
end
always@(*)
begin
  case(bitsReq)
    2'd1: mask=1;
    2'd2: mask=3;
  endcase
end


wire [7:0] thresh = 1<<(bitsReq -1);
wire [7:0] offset = (1<<bitsReq);
wire[8:0]field_0 = (symbol >> (bitsReq*3)) & mask;
wire[8:0]field_1 = (symbol >> (bitsReq*2)) & mask;
wire[8:0]field_2 = (symbol >> (bitsReq*1)) & mask;
wire[8:0]field_3 = (symbol >> (bitsReq*0)) & mask;
assign src_0 = field_0 < thresh ? field_0 : field_0-offset;
assign src_1 = field_1 < thresh ? field_1 : field_1-offset;
assign src_2 = field_2 < thresh ? field_2 : field_2-offset;
assign src_3 = field_3 < thresh ? field_3 : field_3-offset;

assign size = prefix_size + vecGrk;

endmodule
