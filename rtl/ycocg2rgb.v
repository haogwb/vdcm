module ycocg2rgb #(parameter BPC=8)
(

  input [BPC-1:0]  y,
  input [BPC+1-1:0]  co,
  input [BPC+1-1:0]  cg,

  output [BPC-1:0] r,
  output [BPC-1:0] g,
  output [BPC-1:0] b
);

wire [BPC+1-1:0] temp;
assign temp = {1'b0,y} - {cg[BPC+1-1],cg[BPC+1-1:1]};
wire [BPC+2-1:0] cscg = {cg[BPC+1-1],cg} + {temp[BPC+1-1],temp};
wire [BPC+2-1:0] cscb =  {temp[BPC+1-1],temp} - {{2{co[BPC+1-1]}},co[BPC+1-1:1]};
wire [BPC+2-1:0] cscr =  cscb + {co[BPC+1-1],co};

assign r = cscr[BPC+2-1] ? 0 : cscr[BPC+2-2] ? {BPC{1'b1}}: cscr[BPC-1:0];
assign g = cscg[BPC+2-1] ? 0 : cscg[BPC+2-2] ? {BPC{1'b1}}: cscg[BPC-1:0];
assign b = cscb[BPC+2-1] ? 0 : cscb[BPC+2-2] ? {BPC{1'b1}}: cscb[BPC-1:0];


endmodule
