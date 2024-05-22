// sample top level design
// have a testbench and top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		  // from RegFile
              muxB, 
			  rslt,               // alu output
        regfile_dat,
        mux_dat_in,
              immed;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
        regdt,
		sc_clr,
		sc_en,
        MemWrite,
        MemtoReg,
        Cmpfl,
        ALUSrc,
        test,
        Beq,
        Bne,
        Bl,
        Bg,
        Jump,
        REGSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire        [1:0] Type, cmp_src;
  wire        [2:0] M_op;
  wire        [1:0] C_op;
  wire        [2:0] A_op;
  wire              V_op;
  wire[8:0]   mach_code;          // machine code
  wire[5:0]   how_high;
  wire[2:0] rd_addrA, rd_adrB, mux_addrA, mux_addrB;    // address pointers to reg_file
  wire[1:0] rd_addrA_M_A, rd_addrB_M_A; //M and A registers

assign sc_clr = reset; //might need to change to control file

assign how_high = Cmpfl? {1'b0, mach_code[4:0]} :  mach_code[5:0];

// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .reljump_en (relj),
		 .absjump_en (absj),
		 .target           ,
		 .prog_ctr,
     .Beq,
     .Bne,
     .Bl,
     .Bg,
     .test,
     .Jump,
     .cmp_src        );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (how_high),
         .target          );   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control ctl1(.instr(mach_code),
  .RegDst  (regdt), 
  .Branch  (relj)  , 
  .MemWrite , 
  .ALUSrc   , 
  .REGSrc   ,
  .Cmpfl    ,
  .RegWrite   , 
  .Jump    ,    
  .MemtoReg(MemtoReg),
  .Beq, //put these in pc and result to see if they match 
  .Bne,
  .Bl,
  .Bg
  //.ALUOp()
  );

  //INSTRUCTION DECODERS
  assign rd_addrB = mach_code[2:0];
  assign rd_addrA = mach_code[5:3];
  //assign alu_cmd  = mach_code[8:6];

  
  assign Type = mach_code[8:7];
  assign M_op = mach_code[6:4];
  assign C_op = mach_code[6:5];
  assign A_op = mach_code[6:4];
  assign V_op = mach_code[6];
  assign rd_addrA_M_A = mach_code[3:2]; // for math and assignment registers
  assign rd_addrB_M_A = mach_code[1:0]; // for math and assignment registers
  assign immed = mach_code[3:0];


  //maybe mux for addrA and rd_addrA_M_A assign muxB = ALUSrc? rd_addrA : rd_addrA_M_A;
  assign mux_addrA = REGSrc? rd_addrA : {1'b0, rd_addrA_M_A }; //changes whether 
  assign mux_addrB = REGSrc? rd_addrB : {1'b0, rd_addrB_M_A };

  assign mux_dat_in = MemtoReg? regfile_dat : rslt; //output of regfile or rslt
  //assign mux_addr_reg = MemtoReg? regfile_dat : rslt; //output of regfile or rslt
  


  reg_file #(.pw(3)) rf1(
              //.dat_in(regfile_dat),	   // loads, most ops
              .dat_in(mux_dat_in),
              .ALUSrc (ALUSrc),
              .immed (immed),
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(mux_addrA),
              .rd_addrB(mux_addrB),
              .wr_addr (mux_addrB),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 

  assign muxB = ALUSrc? immed : datB;

  alu alu1(
     //.alu_cmd(),
     .Type(Type),
     .M_op(M_op),
     .C_op(C_op),
     .A_op(A_op),
     .V_op(V_op),
     .inA    (datA),
		 .inB    (muxB),
		 .sc_i   (sc_in),   // output from sc register
		 .rslt       ,
		 .sc_o   (sc_o), // input to sc register
		 .pari,  
     .zero,
     .cmp_src );  

  dat_mem dm1(.dat_in(datB)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (datA),
             .dat_out(regfile_dat));

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 128;
 
endmodule