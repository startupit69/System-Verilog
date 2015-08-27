import lc3b_types::*;
/**
 * module sext
 * Description: sign extends input signal
 * Inputs: in - input signal to extend 
 * Outputs: out - signal extended
 * References: http://stackoverflow.com/questions/4176556/how-to-sign-extend-a-number-in-verilog
 */

module sext #(parameter width = 16)
(
	input [width-1:0] in,
	output lc3b_word out
);

assign out = {16-width-1{in[width-1]}, in[width-1:0]};