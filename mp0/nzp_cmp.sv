import lc3b_types::*;
/**
 * module nzp_cmp
 * Description: this module takes in a 16 bit word and determines if it is negative, zero, or positive.
 * Inputs: 	n - negative flag
 *				z - zero flag
 * 			p - positive flag
 * Outputs: br - branch enable output
 */
module nzp_cmp
(
	input lc3b_nzp nzp_cc,
	input lc3b_nzp nzp_br,
	output br
);

always_comb
begin 
	if(nzp_cc & nzp_br)
		br = 1;
	else
		br = 0;
end
endmodule:nzp_cmp
	
