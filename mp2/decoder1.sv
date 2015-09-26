import lc3b_types::*;
module decoder1
(
	input logic in,
	output logic out0,
	output logic out1
);

always_comb
begin
    if (in)
    begin
        out1 = 1'b1;
    	out0 = 1'b0;
    end
    else
    begin
   		out1 = 1'b0;
    	out0 = 1'b1;
    end
end


endmodule : decoder1