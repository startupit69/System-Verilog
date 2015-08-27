import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
    input pcmux_sel,
    input load_pc,
    input storemux_sel,
    input load_ir,
    input load_regfile,
    input load_mar,
    input load_mdr,
    input load_cc,
    input pcmux_sel,
    input storemux_sel,
    input alumux_sel,
    input regfilemux_sel,
    input marmux_sel,
    input mdrmux_sel,

    /* declare more ports here */
    lc3b_word mem_rdata
);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word mem_wdata;

lc3b_word regfilemux_out;
lc3b_word alu_out;
lc3b_nzp gencc_out;
lc3b_nzp cc_out;

lc3b_reg sr1;
lc3b_reg dest;
lc3b_reg storemux_out;

logic br_enable;


/*
 * PC
 */
mux2 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .f(pcmux_out)
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
    .src_a(sr1),
    .src_b(sr2),
    .dest(dest),
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);

mux2 #(.width(16))regfilemux_out
(
    .sel(regfilemux_sel),
    .a(alu_out),
    .b(mem_wdata),
    .f(regfilemux_out)
);

gencc gencc
(
    .input(regfilemux_out),
    .output(gencc_out)
);

register #(parameter width = 16) cc 
(
    .clk(clk),
    .load(load_cc),
    .in(gencc_out),
    .out(cc_out)
);

nzp_cmp ccc_comp
(
    .nzp_cc(cc_out),
    .nzp_to_cmp(dest),
    .branch_enable(branch_enable)   
);


endmodule : datapath
