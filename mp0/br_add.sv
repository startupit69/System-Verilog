import lc3b_types::*;
/**
 * module branch_target_adder
 * Description: computes the branch target address
 * Inputs: 	pc_out - PC value
 *			ajd9 - offset to sign extend and add to PC
 * Outputs: br_add_out - address computed
 */
 
module br_add
(
	input lc3b_word pc_out,
	input lc3b_word adj9_out,
	output lc3b_word br_add_out
);

always_comb
begin
	/* PC←PC + SEXT(IR[8:0] « 1); */
	br_add_out = pc_out + adj9_out; 
end
endmodule:br_add