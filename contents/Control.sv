// control decoder
module Control #(parameter opwidth = 3, mcodebits = 2)(
  input [8:0] instr,    // subset of machine code (any width you need)
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite, REGSrc, Cmpfl
  //output logic[opwidth-1:0] ALUOp
  );	   // for up to 8 ALU operations

  logic [1:0] Type, C_op;
  logic [2:0] A_op, M_op;
  logic V_op;

assign Type  = instr[8:7];
assign M_op = instr[6:4];
assign C_op = instr[6:5];
assign A_op = instr[6:4];
assign V_op = instr[6];

// do this one last. General overview of what to do for you.
always_comb begin
// defaults
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  REGSrc = 'b0;    //for reg 1: 3 or 2 for registers 
  Cmpfl = 'b0; //Compare flag - work in proress
  //ALUOp	    =   'b111; // y = a+0;
// sample values only -- use what you need
  if (Type == 2'b00) begin
      //Math
      case(M_op)
        'b000: begin // add
          RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
        end
        'b001: begin // subtract
          RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
        
        end
        'b010: begin // bitwise AND
          RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
        
        end
        'b011: begin // bitwise OR
          RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
        end
        'b100: begin // bitwise XOR
          RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
        end
        'b101: begin // left_shift
          RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
        end
        'b110: begin // right shift
          RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
        end
        'b111: begin // Not
          RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
        end
      endcase
  end
  if (Type == 2'b01) begin
    //Conditions //Ask how to show whether operand1 
    case(C_op)
      'b00: begin //bl
        RegDst 	=   'b0;   
        Branch 	=   'b1;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b01: begin //bg
        RegDst 	=   'b0;   
        Branch 	=   'b1;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b10: begin //bne
        RegDst 	=   'b0;   
        Branch 	=   'b1;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b11: begin //beq
        RegDst 	=   'b0;   
        Branch 	=   'b1;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
    endcase
  end
  if (Type == 2'b10) begin
    //Assignment
    case(A_op)
      'b000: begin  //li
        RegDst 	=   'b0;   
        Branch 	=   'b0;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b1;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b001: begin //none
        RegDst 	=   'b0;   
        Branch 	=   'b0;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b010: begin //load
        RegDst 	=   'b0;   
        Branch 	=   'b0;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b1;
        REGSrc = 'b1;
      end
      'b011: begin //store
        RegDst 	=   'b0;   
        Branch 	=   'b0;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b0;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b100: begin //cmp
        RegDst 	=   'b0;   
        Branch 	=   'b0;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b101: begin //no op
        RegDst 	=   'b0;   
        Branch 	=   'b0;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b0;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b110: begin //none
        RegDst 	=   'b0;   
        Branch 	=   'b0;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
      'b111: begin //none
        RegDst 	=   'b0;   
        Branch 	=   'b0;   
        MemWrite  =	'b0;   
        ALUSrc 	=	'b0;  
        RegWrite  =	'b1;  
        MemtoReg  =	'b0;
        REGSrc = 'b0;
      end
    endcase
  end
  if (Type == 2'b11) begin
    //Values
    case(V_op)
    //mov
      'b0: begin
        RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b1;
      end
      //jmp
      'b1: begin
        RegDst 	=   'b0;   
          Branch 	=   'b0;   
          MemWrite  =	'b0;   
          ALUSrc 	=	'b0;  
          RegWrite  =	'b1;  
          MemtoReg  =	'b0;
          REGSrc = 'b0;
      end
    endcase
  end
end
	
endmodule