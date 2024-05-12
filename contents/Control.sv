// control decoder
module Control #(parameter opwidth = 3, mcodebits = 2)(
  input [8:0] instr,    // subset of machine code (any width you need)
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

assign Type  = instr[8:7];
assign M_op = instr[6:4];
assign C_op = instr[6:5];
assign A_op = instr[6:4];
assign V_op = instr[6]

// do this one last. General overview of what to do for you.
always_comb begin
// defaults
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	    =   'b111; // y = a+0;
// sample values only -- use what you need
  if (Type == 2'b00) begin
      //Math
      case(M_op)
        'b000: begin
        
        end
      endcase
  end
  if (Type == 2'b01) begin
    //Conditions
    case(C_op)
      'b00: begin
        
      end
    endcase
  end
  if (Type == 2'b10) begin
    //Assignment
    case(A_op)
      'b000: begin
        
      end
    endcase
  end
  if (Type == 2'b11) begin
    //Values
    case(V_op)
    //mov
      'b0: begin
        
      end
      //jmp
      'b1: begin
        
      end
    endcase
  end
end
	
endmodule