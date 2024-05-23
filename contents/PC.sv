// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
		reljump_en,             // rel. jump enable
        absjump_en,				// abs. jump enable
        Bl,
        Bg,
        Bne,
        Beq,
        Jump,
  input [1:0] cmp_src,
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr,
  output logic test
);

  always_ff @(posedge clk)
    if(reset) begin
	    prog_ctr <= '0;
      test <= '0;
    end else if(reljump_en) begin
      if(cmp_src == 2'b10 && Bl == 'b1) begin
        prog_ctr <= prog_ctr + target;
      end else if(cmp_src == 2'b01 && Bg == 'b1) begin
        prog_ctr <= prog_ctr + target;
        test = 1;
      end else if(cmp_src == 2'b11 && Bne == 'b1) begin
        prog_ctr <= prog_ctr + target;
      end else if(cmp_src == 2'b00 && Beq == 'b1) begin
        prog_ctr <= prog_ctr + target;
      end else if(Jump == 1'b1) begin
        prog_ctr <= prog_ctr + target;
        test = 1;
      end
	  //prog_ctr <= prog_ctr + target;
    end else if(absjump_en) begin
	    prog_ctr <= target;
    end else begin
	    prog_ctr <= prog_ctr + 'b1;
    end

endmodule