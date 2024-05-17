//go from instr_rom to decoder to control and reg file
module decoder(
    input clk,
    input rst,
    input instruction_decode_en,

    //to reg file
    output   [7:0] data_in,
)

endmodule