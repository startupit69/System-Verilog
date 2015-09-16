/**
 * @module mux2
 * Description: this module declares a 2 input mux
 * Parameters: width - specifies the width of the mux, default is 16 bits.
 * Inputs: 	a - input signal
 *				b - input signal	
 *				sel - determins which input to output
 * Outputs: f - output signal from the 2 input mux.
 */
module mux2 #(parameter width = 16)
(
	input sel,
	input [width-1:0] a, b,
	output logic [width-1:0] f
);

always_comb
begin
	if(sel == 0)
		f = a;
	else
		f =b;
end
endmodule:mux2