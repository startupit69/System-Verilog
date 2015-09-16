import lc3b_types::*;
/**
 * module branch_target_adder
 * Description: computes the branch target address
 * Inputs: 	pc_out - PC value
 *			ajd9 - offset to sign extend and add to PC
 * Outputs: br_add_out - address computed
 */
 
module adder
(
	input lc3b_word a,
	input lc3b_word b,
	output lc3b_word f
);

always_comb
begin
	/* PC←PC + SEXT(IR[8:0] « 1); */
	f = a + b; 
end
endmodule:adder