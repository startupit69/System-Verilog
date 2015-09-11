import lc3b_types::*;

module ir
(
    input clk,
    input load,
    input lc3b_word in,
    output lc3b_opcode opcode,
    output lc3b_reg dest, src1, src2,
    output lc3b_offset6 offset6,
    output lc3b_offset9 offset9,
    output lc3b_offset11 offset11,
    output lc3b_imm5 imm5,
    output logic imm5_enable,
    output logic offset11_enable,
    output lc3b_byte trapvect8,
    output logic a_bit,
    output logic d_bit
);

lc3b_word data;

always_ff @(posedge clk)
begin
    if (load == 1)
    begin
        data = in;
    end
end

always_comb
begin
    opcode = lc3b_opcode'(data[15:12]);

    if(opcode == op_jsr || opcode == op_trap)
        dest = 3'b111;
    else
        dest = data[11:9];
    src1 = data[8:6];
    src2 = data[2:0];

    offset6 = data[5:0];
    offset9 = data[8:0];
    offset11 = data[10:0];

    imm5 = data[4:0];
    imm5_enable = data[5];
    offset11_enable = data[11];

    trapvect8 = data[7:0];
    a_bit = data[4];
    d_bit = data[5];

end

endmodule : ir
