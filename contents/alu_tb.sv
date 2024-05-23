module alu_tb;

  // Inputs
  reg [2:0] alu_cmd;
  reg [1:0] Type;
  reg [2:0] M_op;
  reg [1:0] C_op;
  reg [2:0] A_op;
  reg V_op;
  reg [7:0] inA, inB;
  reg sc_i;

  // Outputs
  wire [7:0] rslt;
  wire sc_o;
  wire pari;
  wire zero;

  // Instantiate the alu module
  alu dut (
    //.alu_cmd(alu_cmd),
    .Type(Type),
    .M_op(M_op),
    .C_op(C_op),
    .A_op(A_op),
    .V_op(V_op),
    .inA(inA),
    .inB(inB),
    .sc_i(sc_i),
    .rslt(rslt),
    .sc_o(sc_o),
    .pari(pari),
    .zero(zero)
  );

  // Clock generation
  reg clk;
  always #5 clk = ~clk;

  // Testbench logic
  initial begin
    // Initialize inputs
    alu_cmd = 3'b000;
    Type = 2'b00;
    M_op = 3'b000;
    C_op = 2'b00;
    A_op = 2'b00;
    V_op = 1'b0;
    inA = 8'b00000000;
    inB = 8'b00000000;
    sc_i = 1'b0;

    // Apply stimulus
    #10;
    //alu_cmd = 3'b001;
    M_op = 3'b001;
    inA = 8'b00000001;
    inB = 8'b00000001;
    #10;
    //alu_cmd = 3'b010;
    M_op = 3'b010;
    inA = 8'b10101010;
    inB = 8'b01010101;
    #10;
    //alu_cmd = 3'b011;
    M_op = 3'b011;
    inA = 8'b10101010;
    inB = 8'b01010101;
    #10;
    //alu_cmd = 3'b100;
    M_op = 3'b100;
    inA = 8'b00000001;
    inB = 8'b00000001;
    #10;
    //alu_cmd = 3'b101;
    M_op = 3'b101;
    inA = 8'b00000001;
    inB = 8'b00000011;
    #10;
    //alu_cmd = 3'b110;
    M_op = 3'b110;
    inA = 8'b00000001;
    inB = 8'b00001001;
    #10;
    //alu_cmd = 3'b111;
    M_op = 3'b111;
    inA = 8'b00000001;
    #10;
    Type = 2'b11;
    M_op = 3'b111;
    V_op = 1'b0;
    inA = 8'b00001111;
    #10;

    // End simulation
    $finish;
  end

  // Monitor outputs
  always @(posedge clk) begin
    $display("rslt = %b, sc_o = %b, pari = %b, zero = %b", rslt, sc_o, pari, zero);
  end

endmodule