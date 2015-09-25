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

cache_controller cache_controller
(
	/* control -> datapath */
	/* mux sel*/
	.datawordmux_sel(datawordmux_sel),
	.datawritemux_sel(datawritemux_sel),
	.membytemux_sel(membytemux_sel),
	.datawaymux_sel(datawaymux_sel),
	.datainmux_sel(datainmux_sel),
	/* loads */  
	.dataarr0_write(dataarr0_write),
	.dataarr1_write(dataarr1_write),
	.valid0_write(valid0_write),
	.valid1_write(valid1_write),
	.tag0_write(tag0_write),
	.tag1_write(tag1_write),
	.dirtyarr0_write(dirtyarr0_write),
	.dirtyarr1_write(dirtyarr1_write),
	.lru_write(lru_write),
	/* data for loads */
	.lru_in(lru_in),

	/* control <- datapath */
	/* outputs for state logic */
	.dirtyarr0_out(dirtyarr0_out),
	.dirtyarr1_out(dirtyarr1_out),
	.lru_out(lru_out),
	.datawrite_decoder0(datawrite_decoder0),
	.datawrite_decoder1(datawrite_decoder1),
	.ishit0_out(ishit0_out),
	.ishit1_out(ishit1_out),

	/* control -> pmem */
	.pmem_write(pmem_write)
);

cache_datapath cache_datapath
(
	/* internal signals */
	/* control -> datapath */
	/* muxes */
	.datawordmux_sel(datawordmux_sel),
	.datawritemux_sel(datawritemux_sel),
	.membytemux_sel(membytemux_sel),
	.datawaymux_sel(datawaymux_sel),
	.datainmux_sel(datainmux_sel),
	/* load signals */
	/* control -> datapath */
	.dataarr0_write(dataarr0_write),
	.dataarr1_write(dataarr1_write),
	.valid0_write(valid0_write),
	.valid1_write(valid1_write),
	.tag0_write(tag0_write),
	.tag1_write(tag1_write),
	.dirtyarr0_write(dirtyarr0_write),
	.dirtyarr1_write(dirtyarr1_write),
	.lru_write(lru_write),
	/* datas */
	/* inputs */
	.lru_in(lru_in),
	/* outputs */
	/* control <- datapath */
	.dirtyarr0_out(dirtyarr0_out),
	.dirtyarr1_out(dirtyarr1_out),
	.lru_out(lru_out),
	.datawrite_decoder0(datawrite_decoder0),
	.datawrite_decoder1(datawrite_decoder1),
	.ishit0_out(ishit0_out),
	.ishit1_out(ishit1_out),

	/* pmem signals */
	.pmem_rdata(pmem_rdata),
	.pmem_wdata(pmem_wdata),
	.pmem_address(pmem_address),

	/* cpu signals */
	.mem_address(mem_address),
	.offset(mem_address[4:1]),
	.index(mem_address[7:4]),
	.tag(mem_address[15:8]), //fix this, cant count
	.mem_wdata(mem_wdata),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_rdata(mem_rdata)
);

endmodule : cache