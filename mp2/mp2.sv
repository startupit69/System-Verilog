import lc3b_types::*;

module mp2
(
	input logic clk,
	/* mem signals */
	input pmem_resp,
	input [127:0] pmem_rdata,
	output pmem_read,
	output pmem_write,
	output [15:0] pmem_address,
	output [127:0] pmem_wdata
);

logic mem_resp;
lc3b_word mem_rdata;
logic mem_read;
logic mem_write;
logic [1:0] mem_byte_enable;
lc3b_word mem_wdata;
lc3b_word mem_address;


cpu cpu
( 
	.clk(clk),
	.mem_resp(mem_resp),
	.mem_rdata(mem_rdata),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_address(mem_address),
	.mem_wdata(mem_wdata)
);

cache cache
(
	.clk(clk),
	.mem_resp(mem_resp),
	.mem_rdata(mem_rdata),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	//physical memory
	.pmem_resp(pmem_resp),
	.pmem_rdata(pmem_rdata),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata)
);

endmodule : mp2

