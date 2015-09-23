import lc3b_types::*;
module comparator #(parameter width = 128)
(
	input a,
	input b,
	output f
);

always_comb
begin
	if(a == b)
		f = 1;
	else
		f = 0;
end

endmodule : comparator
