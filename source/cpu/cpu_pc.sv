//*****************************************************************************
// cpu_pc.sv
//
// This module is the program counter of cpu.
//
// The cpu_arithmetic included registers:
// PC
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 24, 2019     Initial Release
//
//*****************************************************************************

`ifdef SIM
`include "qwic51_include.vh"
`endif
module cpu_pc
(
   input                        CLK,

   input                        PC_PLUS,

   input  [`CPU_DATA_WIDTH-1:0] MEM_WR_DATA,
   output [`CPU_DATA_WIDTH-1:0] MEM_RD_DATA,
   input  [`CPU_ADDR_WIDTH-1:0] MEM_ADDR,
   input                        MEM_WR,
   input                        MEM_RD,

   output [`CPU_ROM_ADDWID-1:0] ROM_RD_ADDR
);

//*****************************************************************************
// Signals
//*****************************************************************************
reg  [`CPU_DATA_WIDTH-1:0]   mem_wr_pc_l_r = 0;
reg  [`CPU_DATA_WIDTH-1:0]   mem_wr_pc_h_r = 0;
reg  [`CPU_ROM_ADDWID-1:0]   rom_rd_addr_r = 0;
reg  [`CPU_DATA_WIDTH-1:0]   mem_rd_addr_r = 0;

//*****************************************************************************
// Processes
//*****************************************************************************
assign ROM_RD_ADDR = rom_rd_addr_r;
assign MEM_RD_DATA = mem_rd_addr_r;

// Memory R
// TODO
always @(posedge CLK)
begin
   if(MEM_WR)
   begin
      case(MEM_ADDR)
         PC_L_  : mem_wr_pc_l_r  <= MEM_WR_DATA;
         PC_H_  : mem_wr_pc_h_r  <= MEM_WR_DATA;
         default ;
      endcase
   end
   else if(MEM_RD)
   begin
      case(MEM_ADDR)
         PC_L_   : mem_rd_addr_r <= rom_rd_addr_r;
         default ;
      endcase
   end
end

// Setup mem_wr_pc_l_r 1 clock later get result.
always @(posedge CLK)
begin
   if(MEM_WR && MEM_ADDR == PC_L_)
      //rom_rd_addr_r <= {mem_wr_pc_h_r, MEM_WR_DATA}[`CPU_ROM_ADDWID-1:0];
      rom_rd_addr_r <= {mem_wr_pc_h_r, MEM_WR_DATA};
   else if(PC_PLUS)
      rom_rd_addr_r <= rom_rd_addr_r + 1;
end

endmodule
