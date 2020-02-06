//*****************************************************************************
// qwic51_core.sv
//
// This module is the top wrapper of qwic51_core.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 28, 2019     Initial Release
//
//*****************************************************************************

`ifdef SIM
`include "qwic51_include.vh"
`endif
module qwic51_core
(
   input                        CPU_CLK,
   input                        CPU_RESET,
   input  [`CPU_DATA_WIDTH-1:0] CPU_IR_REG,

   output [`CPU_ROM_ADDWID-1:0] CPU_PC_ADDR,
   output [`CPU_DATA_WIDTH-1:0] CPU_P0_OUT,
   output [`CPU_DATA_WIDTH-1:0] CPU_P1_OUT,
   output [`CPU_DATA_WIDTH-1:0] CPU_P2_OUT,
   output [`CPU_DATA_WIDTH-1:0] CPU_P3_OUT
);

//*****************************************************************************
// Signals
//*****************************************************************************
wire [`CPU_DATA_WIDTH-1:0] mem_wr_data;
wire [`CPU_DATA_WIDTH-1:0] mem_rd_data;
wire [`CPU_ADDR_WIDTH-1:0] mem_addr;
wire                       mem_wr;
wire                       mem_rd;
wire                       pc_plus;
wire [`CPU_DATA_WIDTH-1:0] io_rd_data;
wire [`CPU_DATA_WIDTH-1:0] pc_rd_data;
wire [`CPU_DATA_WIDTH-1:0] ar_rd_data;

//*****************************************************************************
// Processes
//*****************************************************************************

//*****************************************************************************
// Maps
//*****************************************************************************
cpu_instr_dec CPU_DECODER
(
   .CLK              ( CPU_CLK ),      // input 
   .RESET            ( CPU_RESET ),    // input 

   .PC_PLUS          ( pc_plus ),      // output
   .IR_REG           ( CPU_IR_REG ),   // input 

   .MEM_WR_DATA      ( mem_wr_data ),  // output
   .MEM_RD_DATA      ( mem_rd_data ),  // input 
   .MEM_ADDR         ( mem_addr ),     // output
   .MEM_WR           ( mem_wr ),       // output
   .MEM_RD           ( mem_rd )        // output
);

cpu_ram CPU_RAM
(
   .CLK               ( CPU_CLK ),     // input 

   .MEM_WR_DATA       ( mem_wr_data ), // input 
   .MEM_RD_DATA       ( mem_rd_data ), // output 
   .MEM_ADDR          ( mem_addr ),    // input 
   .MEM_WR            ( mem_wr ),      // input 
   .MEM_RD            ( mem_rd ),      // input 

   .IO_RD_DATA        ( io_rd_data ),  // input
   .PC_RD_DATA        ( pc_rd_data ),  // input
   .AR_RD_DATA        ( ar_rd_data )   // input
);

cpu_io CPU_IO
(
   .CLK               ( CPU_CLK ),     // input 

   .MEM_WR_DATA       ( mem_wr_data ), // input
   .MEM_RD_DATA       ( io_rd_data ),  // output
   .MEM_ADDR          ( mem_addr ),    // input
   .MEM_WR            ( mem_wr ),      // input
   .MEM_RD            ( mem_rd ),      // input

   .P0_OUT            ( CPU_P0_OUT ),  // output
   .P1_OUT            ( CPU_P1_OUT ),  // output
   .P2_OUT            ( CPU_P2_OUT ),  // output
   .P3_OUT            ( CPU_P3_OUT )   // output
);

cpu_pc CPU_PC
(
   .CLK               ( CPU_CLK ),     // input 

   .PC_PLUS           ( pc_plus ),     // input

   .MEM_WR_DATA       ( mem_wr_data ), // input
   .MEM_RD_DATA       ( pc_rd_data ),  // output
   .MEM_ADDR          ( mem_addr ),    // input
   .MEM_WR            ( mem_wr ),      // input
   .MEM_RD            ( mem_rd ),      // input

   .ROM_RD_ADDR       ( CPU_PC_ADDR )  // output
);

cpu_arithmetic CPU_ARITHMETIC
(
   .CLK               ( CPU_CLK ),     // input 

   .MEM_WR_DATA       ( mem_wr_data ), // input
   .MEM_RD_DATA       ( ar_rd_data ),  // output
   .MEM_ADDR          ( mem_addr ),    // input
   .MEM_WR            ( mem_wr ),      // input
   .MEM_RD            ( mem_rd )       // input
);

endmodule
