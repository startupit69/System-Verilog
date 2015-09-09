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
    output logic [1:0] pcmux_sel,
	 output logic pcoffsetmux_sel,
    output logic storemux_sel,
    output logic [1:0] regfilemux_sel,
    output logic marmux_sel,
    output logic mdrmux_sel,
    output logic [1:0] alumux_sel,
    output lc3b_aluop aluop,
	 output logic destmux_sel,

    /* Datapath to Control */
	input logic branch_enable,
	input lc3b_opcode opcode,
   input logic imm5_enable,
   input logic offset11_enable,

	/* Control to Memory */
	output logic mem_read,
	output logic mem_write,
	output lc3b_mem_wmask mem_byte_enable,

	/* Memory to Control */
	input mem_resp
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
    s_str2,
	s_lea,
	s_jmp,
	s_jsr1,
	s_jsr2,
    s_jsr3

} state, next_state;

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
    pcmux_sel = 2'b00;
    storemux_sel = 1'b0;
    alumux_sel = 2'b00;
	 pcoffsetmux_sel = 1'b0;
    regfilemux_sel = 2'b00;
    marmux_sel = 1'b0;
    mdrmux_sel = 1'b0;
    aluop = alu_add;
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_byte_enable = 2'b11;
    destmux_sel = 1'b0;

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
     		decode: /* do nothing */;

     		s_add:begin
     			/* state for add */
     			/* DR <= SRA + SRB */
     			aluop = alu_add;
     			load_regfile = 1;
     			regfilemux_sel = 0;
     			load_cc = 1;
            if(imm5_enable)
					alumux_sel = 2'b10;
     		end

     		s_and:begin
     			/* state for and */
     			/* DR <= SRA AND SRB */
     			aluop = alu_and;
     			load_regfile = 1;
            regfilemux_sel = 0;
     			load_cc = 1;
            if(imm5_enable)
					alumux_sel = 2'b10;
     		end

     		s_not:begin
     			/* state for not */
     			/* DR <= !SRA */
     			aluop = alu_not;
     			load_regfile = 1;
     			load_cc = 1;
     		end

     		s_br:/*do nothing */ ;
     		s_br_taken:begin
                pcoffsetmux_sel = 1'b0;
     			pcmux_sel = 2'b01;
     			load_pc = 1;	
     		end

     		calc_addr:begin
     			alumux_sel = 2'b01;
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
            
			s_jmp:begin
                //todo
                pcmux_sel = 2'b10;
                load_pc = 1;
                storemux_sel = 1'b0;
			end

            s_jsr1:begin
                //R7 <= PC
                destmux_sel = 1'b1;
                regfilemux_sel = 2'b11;
                load_regfile = 1;
            end

            s_jsr2:begin
                /* PC = PC + offset11 */
                load_pc = 1;
                pcoffsetmux_sel  = 1;
                pcmux_sel  = 2'b10;
            end

            s_jsr3:begin
                /* PC = BaseR */
                pcmux_sel = 2'b10;
                load_pc = 1;
                storemux_sel = 1'b0;
            end
			
            s_lea:begin
                regfilemux_sel = 2'b10;
                load_regfile = 1;
            end
     	
            default: /*do nothing */;
	endcase
end

always_comb
begin : next_state_logic
		next_state = state;
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
					op_ldr:next_state = calc_addr;
					op_not:next_state = s_not;
					op_str:next_state = calc_addr;
					op_br:next_state = s_br;
					op_jmp:next_state = s_jmp;
					op_jsr:next_state = s_jsr1;
					op_lea:next_state = s_lea;
				default: /* do nothing */; 
			endcase
   		end
   		s_add:next_state = fetch1;
   		s_and:next_state = fetch1;
   		s_not:next_state = fetch1;
			s_jmp:next_state = fetch1;
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
		s_lea:next_state = fetch1;

        s_jsr1:begin
            if(offset11_enable) 
                next_state = s_jsr2;
            else
                next_state = s_jsr3;
        end
		default: next_state = fetch1;
		
		endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : control
