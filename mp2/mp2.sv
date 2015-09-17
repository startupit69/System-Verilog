import lc3b_types::*;

module mp2
(
	/* TODO MAKE TYPES */
	input logic clk,
	/* mem signals */
	input pmem_resp,
	input [127:0] pmem_rdata,
	output pmem_read,
	output pmem_write,
	output [15:0] pmem_address,
	output [127:0] pmem_wdata
);

cpu cpu
(

);

cache cache
(

);

endmodule : mp2

