import lc3b_types::*;

module cache
(
	input clk,
	//input from cpu
	input mem_read,
	input mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	input lc3b_word mem_address,
	input lc3b_word mem_wdata,

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
logic datainmux_sel;
logic [1:0] addressmux_sel;
 
logic dataarr0_write;
logic dataarr1_write;
logic valid0_write;
logic valid1_write;
logic tag0_write;
logic tag1_write;
logic dirtyarr0_write;
logic dirtyarr1_write;

logic dirtyarr0_out;
logic dirtyarr1_out;

logic lru_out;

logic ishit0_out;
logic ishit1_out;

cache_control cache_control
(
	.clk(clk),
	/* control -> datapath */
	/* mux sel*/
	.datawordmux_sel(datawordmux_sel),
	.datawritemux_sel(datawritemux_sel),
	.membytemux_sel(membytemux_sel),
	.datawaymux_sel(datawaymux_sel),
	.datainmux_sel(datainmux_sel),
	.addressmux_sel(addressmux_sel),
	/* loads */  
	.dataarr0_write(dataarr0_write),
	.dataarr1_write(dataarr1_write),
	.valid0_write(valid0_write),
	.valid1_write(valid1_write),
	.tag0_write(tag0_write),
	.tag1_write(tag1_write),
	.dirtyarr0_write(dirtyarr0_write),
	.dirtyarr1_write(dirtyarr1_write),
	
	/* control <- datapath */
	/* outputs for state logic */
	.dirtyarr0_out(dirtyarr0_out),
	.dirtyarr1_out(dirtyarr1_out),
	.lru_out(lru_out),
	.ishit0_out(ishit0_out),
	.ishit1_out(ishit1_out),

	/* control -> pmem */
	.pmem_write(pmem_write),
	.pmem_read(pmem_read),
	
	/* pmem <- control */
	.pmem_resp(pmem_resp),
	
	/* control -> cpu */
	.mem_resp(mem_resp)
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
	.addressmux_sel(addressmux_sel),
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

	/* outputs */
	/* control <- datapath */
	.dirtyarr0_out(dirtyarr0_out),
	.dirtyarr1_out(dirtyarr1_out),
	.lru_out(lru_out),
	.ishit0_out(ishit0_out),
	.ishit1_out(ishit1_out),

	/* pmem signals */
	.pmem_rdata(pmem_rdata),
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata),
	
	/* cpu signals */
	.mem_address(mem_address),
	.offset(mem_address[3:1]),
	.index(mem_address[6:4]),
	.tag(mem_address[15:7]), //fix this, cant count
	.mem_wdata(mem_wdata),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_rdata(mem_rdata)
);

endmodule : cache