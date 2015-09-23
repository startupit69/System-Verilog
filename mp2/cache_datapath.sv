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
	//inputs from cpu
	input lc3b_word mem_address,
	input lc3b_index index,
	input lc3b_offset3 offset,
	input lc3_word mem_wdata,
	input logic mem_read,
	input logic mem_write,
	input lc3b_mem_wmask mem_byte_enable,

	// output to the cpu
	output lc3_word mem_rdata,

	// input from physical mem
	input lc3b_block pmem_rdata,


	// output to physical mem
	output lc3b_block pmem_wdata

);

/* internal signals */
lc3b_word membytemux_out;




/*======================================================*/
/* 					WAY0 WAY0 WAY0 WAY0 				*/
/*======================================================*/
array #(.width(1))validarr0
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
array #(.width(10))tagarr0
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
array #(.width(128))dataarr0
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
array #(.width(1))dirtyarr0
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
comparator comp0
(
	.a(),
	.b(),
	.f()
);
/*======================================================*/
/* 					WAY1 WAY1 WAY1 WAY1 				*/
/*======================================================*/
array #(.width(1))validarr1
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
array #(.width(10))tagarr1
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
array #(.width(128))dataarr1
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
array #(.width(1))dirtyarr1
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
comparator comp1
(
	.a(),
	.b(),
	.f()
);
/*======================================================*/
/* 					LRU LRU LRU LRU 					*/
/*======================================================*/
array #(.width(1)) lruarr
(
	.clk(),
	.write(),
	.index(),
	.datain(),
	.dataout()
);
decoder1 lrudecoder
(
	.in(),
	.out0(),
	.out1()
);
/*======================================================*/
/* 					DATA OUT/IN MUXES					*/
/*======================================================*/
/* This mux determins which way to pull data from */
mux2 datawaymux
(
	.sel(),
	.a(),
	.b(),
	.f()
);
/* This mux determines which data goes into the array, either from physical memory or a new write */
mux2 datainmux
(
	.sel(),
	.a(),
	.b(),
	.f()
);

/* Determines which byte to write to data 
 * If 0 go to idle state, DO NOT WRITE!
 */
mux4 membytemux
(
	.sel(mem_byte_enable),
	.a(0),
	.b({8'b0, mem_wdata[7:0]}),
	.c({mem_wdata[15:8],8'b0}),
	.d(mem_wdata),
	.f(membytemux_out)
);

/* This mux determines which word from a block to output (16 bits) */
mux8 #(.width(16)) datawordmux
(
	.sel(),
	.a(),
	.b(),
	.c(),
	.d(),
	.e(),
	.f(),
	.g(),
	.h(),
	.out()
);
/* This mux determines which constructed block to write to an array*/
mux8 #(.width(128)) datawritemux
(
	.sel(),
	.a(),
	.b(),
	.c(),
	.d(),
	.e(),
	.f(),
	.g(),
	.h(),
	.out()
);








endmodule : cache_datapath
