import lc3b_types::*;

module cache_control
(
	//input from datapath
	input logic ishit0_out,
	input logic ishit1_out,
	input logic dirtyarr0_out,
	input logic dirtyarr1_out,
	input logic datawrite_decoder0,
	input logic datawrite_decoder1,
	input logic lru_out,

	//output to datapath
	/*muxes*/
	output lc3b_index datawordmux_sel,
	output lc3b_index datawritemux_sel,
	output logic [1:0] membytemux_sel,
	output logic [1:0] datawaymux_sel,
	output logic [1:0] datainmux_sel,
	/*write*/
	output logic dataarr0_write,
	output logic dataarr1_write,
	output logic valid0_write,
	output logic valid1_write,
	output logic tag0_write,
	output logic tag1_write,
	output logic dirtyarr0_write,
	output logic dirtyarr1_write,
	output logic lru_write,

	/* control->pmem */
	output logic pmem_write

);


enum int unsigned {
    /* List of states */
    s_idle,
    s_hit,
    s_replace

} state, next_state;

always_comb
begin : state_actions

	datawordmux_sel = 3'b000;
	datawritemux_sel = 3'b000;
	membytemux_sel = 2'b00;
	datawaymux_sel = 2'b00;
	datainmux_sel = 2'b00;

	case(state)
		s_idle:begin
			/* do nothing */
		end

		s_hit:begin

		end

		s_replace:begin
			pmem_write
		end
	endcase
end

always_comb
begin : next_state_logic
	next_state = state;

	case(state)
		s_idle:begin
			if(ishit0_out == 1 || ishit0_out == 1)
				next_state = s_hit;
			else

		end
		s_evict:begin
			
		end
		s_replace:begin

		end
		s_hit:begin

		end
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_control