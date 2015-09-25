import lc3b_types::*;

module hitbox
(		
	input lc3b_tag tag0_out,
	input lc3b_tag tag1_out,
	input lc3b_tag tag,
	input logic valid0_out,
	input logic valid1_out,
	output logic ishit0_out,
	output logic ishit1_out,
);

always_comb
begin
	if(tag == tag0_out && valid0_out)
		ishit0_out = 1;
	if(tag == tag1_out && valid1_out)
		ishit1_out = 1;
end
endmodule : hitbox