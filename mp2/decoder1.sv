import lc3b_types::*;
module decoder1
(
	input in,
	output out0,
	output out1,
);

always_comb
begin

    if (in){
        out1 = 1;
    	out0 = 0;
    }else{
   		out1 = 0;
    	out0 = 1;
    }
end


endmodule : decoder1