// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input [1:0] Type,
  input        [2:0] M_op,
  input        [1:0] C_op,
  input        [2:0] A_op,
  input              V_op,
  input [7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero      // NOR (output)
);

//add different types with their math instructions such as mov and cmp. cmp should subtract one from the other and 
//from their you can see how to implement that for the branches
always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  zero = !rslt;
  pari = ^rslt;
  if (Type == 2'b00) begin
      //Math
      case(M_op)
        3'b000: // add 2 8-bit unsigned; automatically makes carry-out
          {sc_o,rslt} = inA + inB + sc_i;
	      3'b001: // subtract
          {sc_o,rslt} = inA - inB + sc_i; //subtract fix needed
        3'b010: // bitwise AND (mask) 
          rslt = inA & inB;  //fix needed
        3'b011: // bitwise OR 
          rslt = inA | inB;
	      3'b100: // bitwise XOR
          rslt = inA ^ inB;
	      3'b101: // left_shift // right shift (alternative syntax -- works like left shift
          {sc_o,rslt} = {inA, sc_i};
	      3'b110: // right shift (alternative syntax -- works like left shift
	        {rslt,sc_o} = {sc_i,inA};
	      3'b111: // Not
	        rslt = !inA;
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
      'b100: //Cmp
        {sc_o,rslt} = inA - inB + sc_i;
    endcase
  end
  if (Type == 2'b11) begin
    //Values
    case(V_op)
    //mov
      'b0: //mov
        rslt = inA;
    endcase
  end
  /*
  case(alu_cmd)
    3'b000: // add 2 8-bit unsigned; automatically makes carry-out
      {sc_o,rslt} = inA + inB + sc_i;
	3'b001: // subtract
    {sc_o,rslt} = inA - inB + sc_i;
    3'b010: // bitwise AND (mask) 
    rslt = inA & inB;
    3'b011: // bitwise OR
    rslt = inA | inB;
	3'b100: // bitwise XOR
    rslt = inA ^ inB;
	3'b101: // left_shift // right shift (alternative syntax -- works like left shift
    {sc_o,rslt} = {inA, sc_i};
	3'b110: // right shift (alternative syntax -- works like left shift
	  {rslt,sc_o} = {sc_i,inA};
	3'b111: // Not
	  rslt = !inA;
  endcase
  */
  
end
   
endmodule