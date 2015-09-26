

module cache_control
(
	input clk,
	//input from datapath
	input logic ishit0_out,
	input logic ishit1_out,
	input logic dirtyarr0_out,
	input logic dirtyarr1_out,
	input logic lru_out,

	//output to datapath
	/*muxes*/
	output logic datainmux_sel,
	output logic [1:0] addressmux_sel,
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
	output logic pmem_write,
	output logic pmem_read,
	
	/* control <- pmem */
	input logic pmem_resp,
	
	/* control -> cpu */
	output logic mem_resp,
	
	/* cpu <- control */
	input logic mem_read,
	input logic mem_write 
);


enum int unsigned {
    /* List of states */
    s_idle,
    s_evict,
    s_replace

} state, next_state;

always_comb
begin : state_actions
	datainmux_sel = 1'b0;
	dataarr1_write = 0;
	dataarr0_write = 0;
	valid0_write = 0;
	valid1_write = 0;
	tag0_write = 0;
	tag1_write = 0;
	dirtyarr0_write = 0;
	dirtyarr1_write = 0;
	pmem_write = 0;
	addressmux_sel = 2'b00;
	mem_resp = 0;
	pmem_read = 0;
	lru_write = 0;


	case(state)
		s_idle:begin
			/* handle the hits here */
			if(mem_read && (ishit0_out || ishit1_out) )
			begin
				//read hit
				mem_resp = 1; //signal data is ready
				lru_write = 1; // update LRU
			end
			else if(mem_write && (ishit0_out || ishit1_out))
			begin
				//write
				// TODO LRU SHOULD ONLY BE WRITTEN TO IN IDLE
				datainmux_sel = 1; //signal our mux to take the superconstructor word 
				lru_write = 1; // update LRU
				if(ishit0_out)
				begin
					//load way 0
					dirtyarr0_write = 1;
					tag0_write = 1;
					valid0_write = 1;
					dataarr0_write = 1;
					
				end
				else
				begin
					//load way 1					
					dirtyarr1_write = 1;
					tag1_write = 1;
					valid1_write = 1;
					dataarr1_write = 1;
				end
			end
		end

		s_evict:begin
			/* writing cache to physical memory */
			// choose which address to write to
			// TODO LRU SHOULD ONLY BE WRITTEN TO IN IDLE
			if(lru_out)
			begin
				//way 1
				addressmux_sel = 2'b10;
			end
			else
			begin
				//way 1
				addressmux_sel = 2'b01;
			end
			pmem_write = 1;

		end

		s_replace:begin
			/* misses */
			// default datainmux_sel = 0
			//only for write_miss. read_miss will not update dirty bit
			pmem_read = 1; // tell physical memory we are trying to read
			if(lru_out)
			begin
				//prep way 1
				dirtyarr1_write = 1;
				tag1_write = 1;
				valid1_write = 1;
				dataarr1_write = 1;
			end
			else
			begin
				//prep way 0
				dirtyarr0_write = 1;
				tag0_write = 1;
				valid0_write = 1;
				dataarr0_write = 1;
			end
		end

	endcase
end

always_comb
begin : next_state_logic
	next_state = state;

	case(state)
		s_idle:begin
			if((ishit0_out || ishit1_out) || (!mem_write && !mem_read)) 
				next_state = s_idle;
			else
			begin
				//miss
				if((lru_out && dirtyarr1_out) || (!lru_out && dirtyarr0_out))
					next_state = s_evict;
				else
					next_state = s_replace;
			end
		end
			
		s_replace:begin
			if(!pmem_resp)
				next_state = s_replace;
			else
				next_state = s_idle;
		end
		
		s_evict:begin
			if(!pmem_resp)
				next_state = s_evict;
			else
				next_state = s_replace;
		end
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_control