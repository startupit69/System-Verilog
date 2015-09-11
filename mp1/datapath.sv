import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
    input logic [1:0] pcmux_sel,
    input load_pc,
    input storemux_sel,
    input load_ir,
    input load_regfile,
    input load_mar,
    input load_mdr,
    input load_cc,
    input logic [1:0] alumux_sel,
    input logic [1:0] regfilemux_sel,
    input logic [1:0] marmux_sel,
    input mdrmux_sel,
    input lc3b_aluop aluop,
	input logic pcoffsetmux_sel,
	input logic [1:0] loadmux_sel,
    input logic maradjmux_sel,


    /* declare more ports here */
    input lc3b_word mem_rdata,
	 
	 /* outputs */
	output lc3b_opcode opcode,
	output lc3b_word mem_address,
	output lc3b_word mem_wdata,
	output logic branch_enable,
    output logic imm5_enable,
    output logic offset11_enable,
    output logic d_bit,
    output logic a_bit
);

/* declare internal signals */
	lc3b_word pcmux_out;
    lc3b_word pcoffsetmux_out;

	lc3b_word pc_out;
	lc3b_word br_add_out;
    lc3b_word jsr_add_out;
    lc3b_word pc_add_out;
	lc3b_word pc_plus2_out;
	lc3b_word adj9_out;
	lc3b_word adj6_out;
    lc3b_word adj11_out;
	lc3b_word marmux_out;
    lc3b_word imm5_sext_out;
    lc3b_word imm4_sext_out;
    lc3b_word loadmux_out;
    lc3b_word mem_wdata_zext_low;
    lc3b_word mem_wdata_zext_high;
    lc3b_word offset6_out;
    lc3b_word stb_add_out;
    lc3b_word maradjmux_out;
    lc3b_word trapvect8_zext_out;	

	lc3b_word mdrmux_out;
	lc3b_word sr1_out;
	lc3b_word sr2_out;
	lc3b_word alumux_out;

	lc3b_offset6 offset6;
	lc3b_offset9 offset9;
    lc3b_offset11 offset11;


    lc3b_imm5 imm5;
    lc3b_imm4 imm4;

	lc3b_word regfilemux_out;
	lc3b_word alu_out;
	lc3b_nzp gencc_out;
	lc3b_nzp cc_out;

	lc3b_reg sr1;
	lc3b_reg sr2;
	lc3b_reg dest;
	lc3b_reg storemux_out;

    lc3b_byte trapvect8;

/*
 * PC
 */
mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(pc_add_out),
    .c(sr1_out),
    .d(),
    .f(pcmux_out)
);

mux2 pcoffsetmux
(
    .sel(pcoffsetmux_sel),
    .a(adj9_out),
    .b(adj11_out),
    .f(pcoffsetmux_out)
);

register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

/* storemux with an instatiated width parameter */
mux2 #(.width(3)) storemux
(
    .sel(storemux_sel),
    .a(sr1),
    .b(dest),
    .f(storemux_out)
);

regfile regfile
(
    .clk(clk),
    .load(load_regfile),
    .in(regfilemux_out),
    .src_a(storemux_out),
    .src_b(sr2),
    .dest(dest),
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);

mux4 #(.width(16))regfilemux
(
    .sel(regfilemux_sel),
    .a(alu_out),
    .b(mem_wdata),
    .c(loadmux_out),
    .d(pc_out), 
    .f(regfilemux_out)
);


gencc gencc
(
    .in(regfilemux_out),
    .out(gencc_out)
);

register #(.width(3)) cc 
(
    .clk(clk),
    .load(load_cc),
    .in(gencc_out),
    .out(cc_out)
);

nzp_cmp ccc_comp
(
    .nzp_cc(cc_out),
    .nzp_br(dest),
    .br(branch_enable)   
);


mux4 loadmux
(
    .sel(loadmux_sel),
    .a(mem_wdata_zext_low),
    .b(mem_wdata_zext_high),
    .c(pc_add_out),
    .d(),
    .f(loadmux_out)
);

ir ir
(
    .clk(clk),
    .load(load_ir),
    .in(mem_wdata),
    .opcode(opcode),
    .dest(dest),
    .src1(sr1),
    .src2(sr2),
    .offset6(offset6),
    .offset9(offset9),
    .offset11(offset11),
    .imm4(imm4),
    .imm5(imm5),
    .imm5_enable(imm5_enable),
    .offset11_enable(offset11_enable),
    .d_bit(d_bit),
    .a_bit(a_bit),
    .trapvect8(trapvect8)
);

adj #(.width(11)) adj11
(
    .in(offset11),
    .out(adj11_out)
);

adj #(.width(9))adj9
(
    .in(offset9),
    .out(adj9_out)
);

adj #(.width(6)) adj6
(
	.in(offset6),
	.out(adj6_out)
);

sext #(.width(5)) imm5_sext
(
    .in(imm5),
    .out(imm5_sext_out)
);

sext #(.width(4)) imm4_sext
(
    .in(imm4),
    .out(imm4_sext_out)
);

sext #(.width(6)) offset6_sext
(
    .in(offset6),
    .out(offset6_out)
);


/* STB */ 
adder stb_add
(
    .a(offset6_out),
    .b(sr1_out),
    .f(stb_add_out)
);


adder pc_add
(
    .a(pc_out),
    .b(pcoffsetmux_out),
    .f(pc_add_out)
);

plus2 plus2
(
    .in(pc_out),
    .out(pc_plus2_out)
);


/* 
 * MEMORY MODULES!!!
 */
/* MAR */
mux4 marmux
(
    .sel(marmux_sel),
    .a(alu_out),
    .b(pc_out),
    .c(mem_wdata),
    .d(maradjmux_out),
    .f(marmux_out)
);
/* MAR */
register #(.width(16)) mar
(
    .clk(clk),
    .load(load_mar),
    .in(marmux_out),
    .out(mem_address)
);
/* MDR */
mux2 mdrmux
(
    .sel(mdrmux_sel),
    .a(alu_out),
    .b(mem_rdata),
    .f(mdrmux_out)
);
/* MDR */
register #(.width(16)) mdr
(
    .clk(clk),
    .load(load_mdr),
    .in(mdrmux_out),
    .out(mem_wdata)
);

/*
 * ALU ALU ALU ALU
 */
mux4 alumux
(
    .sel(alumux_sel),
    .a(sr2_out),
    .b(adj6_out),
    .c(imm5_sext_out),
    .d(imm4_sext_out),
    .f(alumux_out)
);
alu alu
(
    .aluop(aluop),
    .a(sr1_out),
    .b(alumux_out),
    .f(alu_out)
);


zext #(.width(8)) zextmem_low
(
    .in(mem_wdata[7:0]),
    .out(mem_wdata_zext_low)
);

zext #(.width(8)) zextmem_high
(
    .in(mem_wdata[15:8]),
    .out(mem_wdata_zext_high)
);


adjzext trapzext
(
    .in(trapvect8),
    .out(trapvect8_zext_out)
);

mux2 maradjmux
(
    .sel(maradjmux_sel),
    .a(trapvect8_zext_out),
    .b(stb_add_out),
    .f(maradjmux_out)
);


endmodule : datapath
