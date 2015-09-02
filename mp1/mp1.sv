import lc3b_types::*;

module mp1
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
	logic pcmux_sel;
	logic storemux_sel;
	logic regfilemux_sel;
	logic marmux_sel;
	logic mdrmux_sel;
	logic alumux_sel;
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
	.imm11_enable(imm11_enable)
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
	.imm11_enable(imm11_enable)
);

endmodule : mp1
