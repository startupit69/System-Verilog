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
	input lc3_word mem_wdata,
	input logic mem_write,
	input lc3b_mem_wmask mem_byte_enable,

	// output to the cpu
	output lc3_word mem_rdata,

	// input from physical mem
	input lc3b_block pmem_rdata,

	// output to physical mem
	output lc3b_block pmem_wdata,
	output lc3b_word pmem_address,

	//input from control
	/* muxes */
	input lc3b_index datawordmux_sel,
	input lc3b_index datawritemux_sel,
	input logic [1:0] membytemux_sel,
	input logic [1:0] datawaymux_sel,
	input logic [1:0] datainmux_sel,
	/* writes */
	input logic dataarr0_write,
	input logic dataarr1_write,
	input logic valid0_write,
	input logic valid1_write,
	input logic tag0_write,
	input logic tag1_write,
	input logic dirtyarr0_write,
	input logic dirtyarr1_write,

	input logic lru_write,
	input logic lru_in,

	//output to control
	/* used to determin hit in control*/
	output logic dirtyarr0_out,
	output logic dirtyarr1_out
	/* LRU stuff */
	output logic lru_out,
	output logic datawrite_decoder0,
	output logic datawrite_decoder1


);

/* internal signals */
lc3b_word membytemux_out;
lc3b_tag tag0_out;
lc3b_tag tag1_out;
lc3b_block data0_out;
lc3b_block data1_out;
lc3b_block datainmux_out;
lc3b_block datawaymux_out;
lc3b_block datawordmux_out;



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
array #(.width(10))tagarr0
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
	.datain(datainmux_out),
	.dataout(data0_out)
);
array #(.width(1))dirtyarr0
(
	.clk(clk),
	.write(dirtyarr0_write),
	.index(index),
	.datain(mem_write),
	.dataout(dirtyarr0_out)
);
comparator comp0
(
	.a(tag0_out),
	.b(tag),
	.f(cmp_tag0)
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
array #(.width(10))tagarr1
(
	.clk(clk),
	.write(tag1_write),
	.index(index),
	.datain(tag),
	.dataout(tag0_out)
);
array #(.width(128))dataarr1
(
	.clk(clk),
	.write(dataarr1_write),
	.index(index),
	.datain(datainmux_out),
	.dataout(data1_out)
);
array #(.width(1))dirtyarr1
(
	.clk(clk),
	.write(dirtyarr1_write),
	.index(index),
	.datain(mem_write),
	.dataout(dirtyarr1_out)
);
comparator comp1
(
	.a(tag1_out),
	.b(tag),
	.f(cmp_tag1)
);
/*======================================================*/
/* 					LRU LRU LRU LRU 					*/
/*======================================================*/
array #(.width(1)) lruarr
(
	.clk(clk),
	.write(lru_write),
	.index(index),
	.datain(lru_in),
	.dataout(lru_out)
);
decoder1 lrudecoder
(
	.in(lru_out),
	.out0(datawrite_decoder0),
	.out1(datawrite_decoder1)
);
/*======================================================*/
/* 					DATA OUT/IN MUXES					*/
/*======================================================*/
/* This mux determins which way to pull data from */
mux2 datawaymux
(
	.sel(datawaymux_sel),
	.a(data0_out),
	.b(data1_out),
	.f(datawaymux_out)
);
/* This mux determines which data goes into the array, either from physical memory or a new write */
mux2 datainmux
(
	.sel(datainmux_sel),
	.a(pmem_rdata),
	.b(datain_block),
	.f(datainmux_out)
);
/* Determines which byte to write to data 
 * If 0 go to idle state, DO NOT WRITE!
 */
mux4 membytemux
(
	.sel(membytemux_sel),
	.a(0),
	.b({8'b0, mem_wdata[7:0]}),
	.c({mem_wdata[15:8],8'b0}),
	.d(mem_wdata),
	.f(membytemux_out)
);
/* This mux determines which word from a block to output (16 bits) */
mux8 #(.width(16)) datawordmux
	.sel(datawritemux_sel),
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
mux8 #(.width(128)) datawritemux
(
	.sel(datawordmux_sel),
	.a({datawaymux_out[127:16], mem_wdata}),
	.b({datawaymux_out[127:32], mem_wdata, datawaymux_out[15:0]}),
	.c({datawaymux_out[127:48], mem_wdata, datawaymux_out[31:0]}),
	.d({datawaymux_out[127:64], mem_wdata, datawaymux_out[47:0]}),
	.e({datawaymux_out[127:80], mem_wdata, datawaymux_out[63:0]}),
	.f({datawaymux_out[127:96], mem_wdata, datawaymux_out[79:0]}),
	.g({datawaymux_out[127:112], mem_wdata, datawaymux_out[95:0]}),
	.h({mem_wdata, datawaymux_out[111:0]}),
	.out(datawordmux_out)
);

mux2 #(.width(16)) addressmux
(
	.sel(addressmux_sel),
	.a(/*tag[way n],4'b0*/),
	.b(mem_address),
	.f(pmem_address)

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
	.ishit1_out(ishit0_out),
);







endmodule : cache_datapath
