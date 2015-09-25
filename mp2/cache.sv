import lc3b_types::*;

module cache
(
	//input from cpu
	input mem_read,
	input mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	input lc3b_word mem_address,
	input lc3b_wor mem_wdata,

	//output to cpu
	output lc3b_word mem_rdata,
	output mem_resp,

	//input from pmem
	input pmem_resp,
	input pmem_rdata,

	//output to pmem
	output pmem_read,
	output pmem_write,
	output lc3b_word pmem_address,
	output lc3b_block pmem_wdata

);

//internal cache signals
lc3b_index datawordmux_sel;
lc3b_index datawritemux_sel;
logic [1:0] membytemux_sel;
logic [1:0] datawaymux_sel;
logic [1:0] datainmux_sel;

logic dataarr0_write;
logic dataarr1_write;
logic valid0_write;
logic valid1_write;
logic tag0_write;
logic tag1_write;
logic dirtyarr0_write;
logic dirtyarr1_write;
logic lru_write;
logic lru_in;

logic dirtyarr0_out;
logic dirtyarr1_out;

logic lru_out;
logic datawrite_decoder0;
logic datawrite_decoder1;

logic ishit0_out;
logic ishit1_out;

assign pmem_address = mem_address;

cache_controller cache_controller
(
	.datawordmux_sel(datawordmux_sel),
	.datawritemux_sel(datawritemux_sel),
	.membytemux_sel(membytemux_sel),
	.datawaymux_sel(datawaymux_sel),
	.datainmux_sel(datainmux_sel),
	.dataarr0_write(dataarr0_write),
	.dataarr1_write(dataarr1_write),
	.valid0_write(valid0_write),
	.valid1_write(valid1_write),
	.tag0_write(tag0_write),
	.tag1_write(tag1_write),
	.dirtyarr0_write(dirtyarr0_write),
	.dirtyarr1_write(dirtyarr1_write),
	.lru_write(lru_write),
	.lru_in(lru_in),
	.dirtyarr0_write(dirtyarr0_write),
	.dirtyarr1_write(dirtyarr1_write),
	.lru_out(lru_out),
	.datawrite_decoder0(datawrite_decoder0),
	.datawrite_decoder1(datawrite_decoder1),
	.ishit0_out(ishit0_out),
	.ishit1_out(ishit1_out)
);

cache_datapath cache_datapath
(
	.datawordmux_sel(datawordmux_sel),
	.datawritemux_sel(datawritemux_sel),
	.membytemux_sel(membytemux_sel),
	.datawaymux_sel(datawaymux_sel),
	.datainmux_sel(datainmux_sel),
	.dataarr0_write(dataarr0_write),
	.dataarr1_write(dataarr1_write),
	.valid0_write(valid0_write),
	.valid1_write(valid1_write),
	.tag0_write(tag0_write),
	.tag1_write(tag1_write),
	.dirtyarr0_write(dirtyarr0_write),
	.dirtyarr1_write(dirtyarr1_write),
	.lru_write(lru_write),
	.lru_in(lru_in),
	.dirtyarr0_write(dirtyarr0_write),
	.dirtyarr1_write(dirtyarr1_write),
	.lru_out(lru_out),
	.datawrite_decoder0(datawrite_decoder0),
	.datawrite_decoder1(datawrite_decoder1),
	.ishit0_out(ishit0_out),
	.ishit1_out(ishit1_out)
);

endmodule : cache