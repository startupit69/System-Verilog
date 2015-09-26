import lc3b_types::*;

module hitbox
(		
	input lc3b_tag tag0_out,
	input lc3b_tag tag1_out,
	input lc3b_tag tag,
	input logic valid0_out,
	input logic valid1_out,
	output logic ishit0_out,
	output logic ishit1_out
);

logic tag0_cmp;
logic tag1_cmp;

always_comb
	begin
		if(tag == tag0_out && valid0_out)
		begin
			ishit0_out = 1;
			ishit1_out = 0;
		end
		else if(tag == tag1_out && valid1_out)
		begin
			ishit1_out = 1;
			ishit0_out = 0;
		end
		else
		begin
			ishit1_out = 0;
			ishit0_out = 0;
		end
	end
endmodule : hitbox