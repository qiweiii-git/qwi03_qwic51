//*****************************************************************************
// cpu_io.sv
//
// This module is the IO control of cpu.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 28, 2019     Initial Release
//
//*****************************************************************************

`ifdef SIM
`include "qwic51_include.vh"
`endif
module cpu_io
(
   input                        CLK,

   input  [`CPU_DATA_WIDTH-1:0] MEM_WR_DATA,
   output [`CPU_DATA_WIDTH-1:0] MEM_RD_DATA,
   input  [`CPU_ADDR_WIDTH-1:0] MEM_ADDR,
   input                        MEM_WR,
   input                        MEM_RD,

   // IO
   output [`CPU_DATA_WIDTH-1:0] P0_OUT,
   output [`CPU_DATA_WIDTH-1:0] P1_OUT,
   output [`CPU_DATA_WIDTH-1:0] P2_OUT,
   output [`CPU_DATA_WIDTH-1:0] P3_OUT
);

//*****************************************************************************
// Parameters
//*****************************************************************************
enum {
   P0_REG = 0,
   P1_REG,
   P2_REG,
   P3_REG,
   REGS_CNT
} e_regs;

//*****************************************************************************
// Signals
//*****************************************************************************
reg  [`CPU_DATA_WIDTH-1:0] mem_rams [REGS_CNT-1:0];
reg  [`CPU_DATA_WIDTH-1:0] mem_rd_data_r;

//*****************************************************************************
// Processes
//*****************************************************************************
assign MEM_RD_DATA = mem_rd_data_r;

always @(posedge CLK)
begin
   if(MEM_WR)
   begin
      case(MEM_ADDR)
         P0 : mem_rams[P0_REG] <= MEM_WR_DATA;
         P1 : mem_rams[P1_REG] <= MEM_WR_DATA;
         P2 : mem_rams[P2_REG] <= MEM_WR_DATA;
         P3 : mem_rams[P3_REG] <= MEM_WR_DATA;
         default ;
      endcase
   end
   else if(MEM_RD)
   begin
      case(MEM_ADDR)
         P0 : mem_rd_data_r <= mem_rams[P0_REG];
         P1 : mem_rd_data_r <= mem_rams[P1_REG];
         P2 : mem_rd_data_r <= mem_rams[P2_REG];
         P3 : mem_rd_data_r <= mem_rams[P3_REG];
         default ;
      endcase
   end
end

assign P0_OUT = mem_rams[P0_REG];
assign P1_OUT = mem_rams[P1_REG];
assign P2_OUT = mem_rams[P2_REG];
assign P3_OUT = mem_rams[P3_REG];

endmodule
