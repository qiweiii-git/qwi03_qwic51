//*****************************************************************************
// cpu_ram.sv
//
// This module is the RAMs control of cpu.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 28, 2019     Initial Release
//
//*****************************************************************************

`ifdef SIM
`include "qwic51_include.vh"
`endif
module cpu_ram
(
   input                        CLK,

   input  [`CPU_DATA_WIDTH-1:0] MEM_WR_DATA,
   output [`CPU_DATA_WIDTH-1:0] MEM_RD_DATA,
   input  [`CPU_ADDR_WIDTH-1:0] MEM_ADDR,
   input                        MEM_WR,
   input                        MEM_RD,

   input  [`CPU_DATA_WIDTH-1:0] IO_RD_DATA,
   input  [`CPU_DATA_WIDTH-1:0] PC_RD_DATA,
   input  [`CPU_DATA_WIDTH-1:0] AR_RD_DATA
);

//*****************************************************************************
// Parameters
//*****************************************************************************
enum {
   IO,
   PC,
   AR,
   GENERAL,
   RAMS_NUM
} e_rams;

//*****************************************************************************
// Signals
//*****************************************************************************
reg  [`CPU_DATA_WIDTH-1:0] ram [0:2**`CPU_RAM_ADDWID-1];
reg  [`CPU_DATA_WIDTH-1:0] ram_rd_data;
reg  [`CPU_RAM_ADDWID-1:0] ram_wr_addr;
reg                        ram_wr;
reg  [`CPU_RAM_ADDWID-1:0] ram_rd_addr;
reg  [RAMS_NUM-1:0]        ram_rd;

//*****************************************************************************
// Processes
//*****************************************************************************
assign ram_wr_addr = MEM_ADDR;
assign ram_rd_addr = MEM_ADDR;

// RAM write
always @(posedge CLK)
begin
   if(MEM_WR)
      ram[ram_wr_addr] <= MEM_WR_DATA;
end

// RAM read
always @(posedge CLK)
begin
   if(MEM_RD)
      ram_rd_data <= ram[ram_rd_addr];
end

always @(*)
begin
   // IO read
   if(ram_rd_addr == P0 || ram_rd_addr == P1 || ram_rd_addr == P2 || ram_rd_addr == P3)
      ram_rd <= 1'b1 << IO;
   // PC read
   else if(ram_rd_addr == PC_L_ || ram_rd_addr == PC_H_)
      ram_rd <= 1'b1 << PC;
   // Arithmetic read
   else if(ram_rd_addr == ACC || ram_rd_addr == B || ram_rd_addr == PSW)
      ram_rd <= 1'b1 << AR;
   // General RAM read
   else
      ram_rd <= 1'b1 << GENERAL;
end

assign MEM_RD_DATA = (ram_rd[IO])?      IO_RD_DATA  :
                     (ram_rd[PC])?      PC_RD_DATA  :
                     (ram_rd[AR])?      AR_RD_DATA  :
                     (ram_rd[GENERAL])? ram_rd_data : 0;

endmodule
