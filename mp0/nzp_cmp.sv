import lc3b_types::*;
/**
 * module nzp_cmp
 * Description: this module takes in a 16 bit word and determines if it is negative, zero, or positive.
 * Inputs: 	n - negative flag
 *				z - zero flag
 * 			p - positive flag
 * Outputs: br - branch enable output
 */
module nzp_cmp()
(
	input lc3b_word word_to_cmp,
	input logic n, z, p,
	output br
);

always_comb
begin 
	if((n == 1 and word_to_cmp[15] == 1) or 
		(z == 1 and word_to_cmp == 0'16b) or 
		(p == 1 and word_to_cmp[15] == 0))
	{
		br = 1;
	}else{
		br = 0;
	}
end
endmodule:nzp_cmp
	
