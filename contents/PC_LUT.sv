//Program counter Lookup table for relative jmps
module PC_LUT #(parameter D=12)(
  input       [ 5:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
    0: target = -66;   // go back 66 spaces
	1: target = 73;   // go ahead 73 spaces
	2: target = -10;   // go back 10 spaces   1111_1111_1111
	3: target = 59;   // go ahead 59 spaces
	4: target = 8;   // go ahead 8 spaces
	5: target = 4;   // go ahead 4 spaces
	6: target = -84;   // go back 84 spaces
	7: target = 7;   // go ahead 7 spaces
	8: target = 6;   // go ahead 6 spaces
	default: target = 'b0;  // hold PC  
  endcase

endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
