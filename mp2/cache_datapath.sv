import lc3b_types::*;


/* CHANGES FROM DATAPATH !!! 
 * TODO DONT FORGET!!!
 * Mem_byte_enables determines which byte we will write.
 * We will put a mux with mem_byte enable that determines which byte to write
 * before we construct our 128bit block
 */ 

 // TODO TODO TODO TODO
 /* RESET TIMING STUFF DO MP0 AGAIN PRETTY MUCH */
module cache_datapath
(
	input clk,

	//inputs from cpu
	input lc3b_word mem_address,
	input lc3b_index index,
	input lc3b_offset3 offset,
	input lc3b_tag tag,
	input lc3b_word mem_wdata,
	input logic mem_write,
	input lc3b_mem_wmask mem_byte_enable,

	// output to the cpu
	output lc3b_word mem_rdata,

	// input from physical mem
	input lc3b_block pmem_rdata,

	// output to physical mem
	output lc3b_word pmem_address,
	output lc3b_block pmem_wdata,

	//input from control
	/* muxes */
	input logic datainmux_sel,
	input logic [1:0] addressmux_sel,
	
	/* writes */
	input logic dataarr0_write,
	input logic dataarr1_write,
	input logic valid0_write,
	input logic valid1_write,
	input logic tag0_write,
	input logic tag1_write,
	input logic dirtyarr0_write,
	input logic dirtyarr1_write,

	//output to control
	/* used to determin hit in control*/
	output logic dirtyarr0_out,
	output logic dirtyarr1_out,
	output logic ishit0_out,
	output logic ishit1_out,
	/* LRU stuff */
	output logic lru_out

);

/* internal signals */
lc3b_word membytemux_out;
lc3b_tag tag0_out;
lc3b_tag tag1_out;
lc3b_block data0_out;
lc3b_block data1_out;
lc3b_block datawaymux_out;
lc3b_block datablock_out;
logic lru_write;
lc3b_block superblockconstructor_out;
logic valid0_out;
logic valid1_out;

assign lru_write = ishit1_out || ishit0_out;


/*======================================================*/
/* 					WAY0 WAY0 WAY0 WAY0 				*/
/*======================================================*/
array #(.width(1))validarr0
(
	.clk(clk),
	.write(valid0_write),
	.index(index),
	.datain(1'b1),
	.dataout(valid0_out)
);
array #(.width(9))tagarr0
(
	.clk(clk),
	.write(tag0_write),
	.index(index),
	.datain(tag),
	.dataout(tag0_out)
);
array #(.width(128))dataarr0
(
	.clk(clk),
	.write(dataarr0_write),
	.index(index),
	.datain(datablock_out),
	.dataout(data0_out)
);
array #(.width(1))dirtyarr0
(
	.clk(clk),
	.write(dirtyarr0_write && ~ishit0_out),
	.index(index),
	.datain(mem_write),
	.dataout(dirtyarr0_out)
);
/*======================================================*/
/* 					WAY1 WAY1 WAY1 WAY1 				*/
/*======================================================*/
array #(.width(1))validarr1
(
	.clk(clk),
	.write(valid1_write),
	.index(index),
	.datain(1'b1),
	.dataout(valid1_out)
);
array #(.width(9))tagarr1
(
	.clk(clk),
	.write(tag1_write),
	.index(index),
	.datain(tag),
	.dataout(tag1_out)
);
array #(.width(128))dataarr1
(
	.clk(clk),
	.write(dataarr1_write),
	.index(index),
	.datain(datablock_out),
	.dataout(data1_out)
);
array #(.width(1))dirtyarr1
(
	.clk(clk),
	.write(dirtyarr1_write && ~ishit1_out),
	.index(index),
	.datain(mem_write),
	.dataout(dirtyarr1_out)
);
/*======================================================*/
/* 					LRU LRU LRU LRU 					*/
/*======================================================*/
array #(.width(1)) lruarr
(
	.clk(clk),
	.write(lru_write),
	.index(index),
	.datain(~ishit1_out),
	.dataout(lru_out)
);

/*======================================================*/
/* 					DATA OUT/IN MUXES					*/
/*======================================================*/
/* This mux determins which way to pull data from */
mux2 #(.width(128)) datawaymux
(
	.sel(ishit1_out),
	.a(data0_out),
	.b(data1_out),
	.f(datawaymux_out)
);
/* This mux determines which data goes into the array or out to physical memory, either from physical memory or a new write */
mux2 #(.width(128)) datainmux
(
	.sel(datainmux_sel),
	.a(pmem_rdata),
	.b(superblockconstructor_out),
	.f(datablock_out)
);

/* This mux determines which word from a block to output (16 bits) */
mux8 #(.width(16)) datawordmux
(
	.sel(offset),
	.a(datawaymux_out[15:0]),
	.b(datawaymux_out[31:16]),
	.c(datawaymux_out[47:32]),
	.d(datawaymux_out[63:48]),
	.e(datawaymux_out[79:64]),
	.f(datawaymux_out[95:80]),
	.g(datawaymux_out[111:96]),
	.h(datawaymux_out[127:112]),
	.out(mem_rdata)
);
/* This mux determines which constructed block to write to an array*/
superblockconstructor superblockconstructor
(
	.sel(offset),
	.mem_byte_enable(mem_byte_enable),
	.block(datawaymux_out),
	.word(mem_wdata),
	.out(superblockconstructor_out)
);

mux4 #(.width(16)) addressmux
(
	.sel(addressmux_sel),
	.a(mem_address),
	.b({tag0_out, index, 4'b0}),
	.c({tag1_out, index, 4'b0}),
	.d(),
	.f(pmem_address)
);

mux2 #(.width(128)) pmemwritemux
(
	.sel(~lru_out),
	.a(data0_out),
	.b(data1_out),
	.f(pmem_wdata)
);



/*======================================================*/
/* 					CALC HIT CALC HIT				*/
/*======================================================*/
hitbox hitbox
(
	.tag0_out(tag0_out),
	.tag1_out(tag1_out),
	.tag(tag),
	.valid0_out(valid0_out),
	.valid1_out(valid1_out),
	.ishit0_out(ishit0_out),
	.ishit1_out(ishit1_out)
);







endmodule : cache_datapath
