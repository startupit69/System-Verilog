import lc3b_types::*;

module mp2
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);


/* internal signals */

	/* Control to Datapath */
	logic load_pc;
	logic load_ir;
	logic load_regfile;
	logic load_mar;
	logic load_mdr;
	logic load_cc;
	
	logic [1:0] pcmux_sel;
	logic storemux_sel;
	logic [1:0] regfilemux_sel;
	logic [1:0] marmux_sel;
	logic mdrmux_sel;
	logic [1:0] alumux_sel;
	logic pcoffsetmux_sel;
	logic [1:0] loadmux_sel;
	logic maradjmux_sel;
	logic offset11_enable;
	logic d_bit;
	logic a_bit;
	
	lc3b_aluop aluop;



	/* Datapath to Control */
	lc3b_opcode opcode;
	logic branch_enable;
	logic imm5_enable;
	logic imm11_enable;

/* Instantiate MP 0 top level blocks here */
datapath datapath
(
	.clk(clk),
	.pcmux_sel(pcmux_sel),
	.load_pc(load_pc),
	.load_ir(load_ir),
	.load_regfile(load_regfile),
	.load_mar(load_mar),
	.load_mdr(load_mdr),
	.load_cc(load_cc),
	.storemux_sel(storemux_sel),
	.alumux_sel(alumux_sel),
	.regfilemux_sel(regfilemux_sel),
	.marmux_sel(marmux_sel),
	.mdrmux_sel(mdrmux_sel),
	.opcode(opcode),
	.aluop(aluop),
	.mem_rdata(mem_rdata),
	.mem_wdata(mem_wdata),
	.mem_address(mem_address),
	.branch_enable(branch_enable),
	.imm5_enable(imm5_enable),
	.pcoffsetmux_sel(pcoffsetmux_sel),
	.loadmux_sel(loadmux_sel),
	.maradjmux_sel(maradjmux_sel),
	.offset11_enable(offset11_enable),
	.d_bit(d_bit),
	.a_bit(a_bit)
);

control control
(
	.clk(clk),
	.load_pc(load_pc),
	.load_ir(load_ir),
	.load_regfile(load_regfile),
	.load_mar(load_mar),
	.load_mdr(load_mdr),
	.load_cc(load_cc),
	.pcmux_sel(pcmux_sel),
	.storemux_sel(storemux_sel),
	.alumux_sel(alumux_sel),
	.regfilemux_sel(regfilemux_sel),
	.marmux_sel(marmux_sel),
	.mdrmux_sel(mdrmux_sel),
	.opcode(opcode),
	.aluop(aluop),
	.mem_rdata(mem_rdata),
	.mem_byte_enable(mem_byte_enable),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_resp(mem_resp),
	.branch_enable(branch_enable),
	.imm5_enable(imm5_enable),
	.mem_byte(mem_address[0]),
	.loadmux_sel(loadmux_sel),
	.pcoffsetmux_sel(pcoffsetmux_sel),
	.maradjmux_sel(maradjmux_sel),
	.offset11_enable(offset11_enable),
	.d_bit(d_bit),
	.a_bit(a_bit)
);

endmodule : mp2
