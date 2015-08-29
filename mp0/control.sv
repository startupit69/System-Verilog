import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
    /* Input and output port declarations */
    input clk,
    input lc3b_word mem_rdata,


    /* Control to Datapath */
    output logic load_pc,
    output logic load_ir,
    output logic load_regfile,
    output logic load_mar,
    output logic load_mdr,
    output logic load_cc,
    output logic pcmux_sel,
    output logic storemux_sel,
    output logic regfilemux_sel,
    output logic marmux_sel,
    output logic mdrmux_sel,
    output logic alumux_sel,
    output lc3b_aluop aluop,

    /* Datapath to Control */
	input logic branch_enable,
	input lc3b_opcode opcode,

	/* Control to Memory */
	output logic mem_read,
	output logic mem_write,
	output lc3b_mem_wmask mem_byte_enable

	/* Memory to Control */
	input mem_resp,
);

enum int unsigned {
    /* List of states */
    fetch1,
    fetch2,
    fetch3,
    decode,
    s_add,
    s_and,
    s_not,
    s_br,
    s_br_taken,
    calc_addr,
    s_ldr1,
    s_ldr2,
    s_str1,
    s_str2

} state, next_states;

always_comb
begin : state_actions
    /* Default output assignments */
    /* Actions for each state */
    load_pc = 1'b0;
    load_ir = 1'b0;
    load_regfile = 1'b0;
   	load_mar = 1'b0;
  	load_mdr = 1'b0;
    load_cc = 1'b0;
    pcmux_sel = 1'b0;
    storemux_sel = 1'b0;
    alumux_sel = 1'b0;
    regfilemux_sel = 1'b0;
    marmux_sel = 1'b0;
    mdrmux_sel = 1'b0;
    aluop = alu_add;
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_byte_enable = 2'b11;

    case(state)
     		fetch1:begin
     			/* MAR <= PC */
     			marmux_sel = 1;
     			load_mar = 1;
     			/* PC <= PC+2 */
     			pcmux_sel = 0;
     			load_pc = 1;
     		end

     		fetch2:begin
     			/* Read memory */
     			mem_read = 1;
     			mdrmux_sel = 1;
     			load_mdr = 1;
     		end

     		fetch3:begin
     			/* Load IR */
     			load_ir = 1;
     		end
     		decode: /* do nothing */

     		s_add:begin
     			/* state for add */
     			/* DR <= SRA + SRB */
     			aluop = alu_add;
     			load_regfile = 1;
     			regfilemux_sel = 0;
     			load_cc = 1;
     		end

     		s_and:begin
     			/* state for and */
     			/* DR <= SRA AND SRB */
     			aluop = alu_and;
     			load_regfile = 1;
     			regfilemux_sel = 0;
     			load_cc = 1;
     		end

     		s_not:begin
     			/* state for not */
     			/* DR <= !SRA */
     			aluop = alu_not;
     			load_regfile = 1;
     			load_cc = 1;
     		end

     		s_br:/*do nothing */ 
     		s_br_taken:begin
     			pcmux_sel = 1;
     			load_pc = 1;	
     		end

     		calc_addr:begin
     			alumux_sel = 1;
     			aluop = alu_add;
     			load_mar = 1;
     		end

     		s_ldr1:begin
     			mdrmux_sel = 1;
     			load_mdr = 1;
     			mem_read = 1;
     		end
     		s_ldr2:begin
     			regfilemux_sel = 1;
     			load_regfile = 1;
     			load_cc = 1;
     		end

     		s_str1:begin
     			storemux_sel = 1;
     			aluop = alu_pass;
     			load_mdr = 1;
     		end

     		s_str2:begin
     			mem_write = 1;
     		end 

     		default: /*do nothing */
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
     case(state)
     	fetch1:next_state = fetch2;
     	fetch2:if(mem_resp)next_state = fetch3;
   		fetch3:next_state = decode;
   		decode:begin
   			case(opcode)
   				op_add:next_state = s_add;
				op_and:next_state = s_and;
				op_br: next_state = s_br;
				op_jmp:next_state = s_jmp; 
				op_jsr:next_state = s_jsr;
				op_ldb:next_state = s_ldb;
				op_ldi:next_state = s_ldi;
				op_ldr:next_state = calc_addr;
				op_lea:next_state = s_lea;
				op_not:next_state = s_not;
				op_rti:next_state = s_rti;
				op_shf:next_state = s_shf;
				op_stb:next_state = s_stb;
				op_sti:next_state = s_sti;
				op_str:next_state = calc_addr;
				op_trap:next_state = s_trap;
   		end
   		s_add:next_state = fetch1;
   		s_and:next_state = fetch1;
   		s_not:next_state = fetch1;
   		s_br:begin 
   			if(branch_enable) 
   				next_state = s_br_taken;
   			else
   				next_state = fetch1;
   		end
   		s_br_taken:next_state = fetch1;
   		calc_addr:begin
   			if(opcode == op_ldr)
   				next_state = s_ldr1;
   			else
   				next_state = s_str1;
   		end
   		s_ldr1:if(mem_resp) next_state = s_ldr2;
   		s_ldr2:next_state = fetch1;
   		s_str1:next_state = s_str2;
   		s_str2:if(mem_resp) next_state = fetch1;
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : control
