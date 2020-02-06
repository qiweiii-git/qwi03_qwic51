//*****************************************************************************
// qwic51_rom.sv
//
// This module is the instruction ROM of qwic51.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 30, 2019     Initial Release
//
//*****************************************************************************

`ifdef SIM
`include "qwic51_include.vh"
`endif
module qwic51_rom
(
   input                        CPU_CLK,

   input  [`CPU_ROM_ADDWID-1:0] CPU_PC_ADDR,
   output [`CPU_DATA_WIDTH-1:0] CPU_IR_REG
);

//*****************************************************************************
// Parameters
//*****************************************************************************
localparam MAIN   = 8'h50;
localparam L1     = 8'h56;
localparam DELAY  = 8'h60;
localparam L3     = 8'h63;
localparam L4     = 8'h66;


localparam R0     = WORKREG1 + 0;
localparam R1     = WORKREG1 + 1;

//*****************************************************************************
// Signals
//*****************************************************************************
reg  [`CPU_DATA_WIDTH-1:0] cpu_ir_reg_r;

//*****************************************************************************
// Processes
//*****************************************************************************
assign CPU_IR_REG = cpu_ir_reg_r;

always @(posedge CPU_CLK)
begin
   case(CPU_PC_ADDR)
         8'h00    : cpu_ir_reg_r <= RESET_CTRL;
         8'h01    : cpu_ir_reg_r <= AJMP_CTRL;
         8'h02    : cpu_ir_reg_r <= MAIN;
         MAIN     : cpu_ir_reg_r <= CLR_CTRL + 'b0000;
         MAIN + 1 : cpu_ir_reg_r <= P0;
         MAIN + 2 : cpu_ir_reg_r <= LCALL_CTRL;
         MAIN + 3 : cpu_ir_reg_r <= DELAY;
         MAIN + 4 : cpu_ir_reg_r <= AJMP_CTRL;
         MAIN + 5 : cpu_ir_reg_r <= L1;
         L1       : cpu_ir_reg_r <= SETB_CTRL + 'b0000;
         L1 + 1   : cpu_ir_reg_r <= P0;
         L1 + 2   : cpu_ir_reg_r <= LCALL_CTRL;
         L1 + 3   : cpu_ir_reg_r <= DELAY;
         L1 + 4   : cpu_ir_reg_r <= AJMP_CTRL;
         L1 + 5   : cpu_ir_reg_r <= MAIN;

         DELAY     : cpu_ir_reg_r <= MOV_CTRL;
         DELAY + 1 : cpu_ir_reg_r <= R0;
         DELAY + 2 : cpu_ir_reg_r <= 240;
         L3        : cpu_ir_reg_r <= MOV_CTRL;
         L3 + 1    : cpu_ir_reg_r <= R1;
         L3 + 2    : cpu_ir_reg_r <= 240;
         L4        : cpu_ir_reg_r <= NOP_CTRL;
         L4 + 1    : cpu_ir_reg_r <= DJNZ_CTRL;
         L4 + 2    : cpu_ir_reg_r <= R1;
         L4 + 3    : cpu_ir_reg_r <= L4;
         L4 + 4    : cpu_ir_reg_r <= DJNZ_CTRL;
         L4 + 5    : cpu_ir_reg_r <= R0;
         L4 + 6    : cpu_ir_reg_r <= L3;
         L4 + 7    : cpu_ir_reg_r <= RET_CTRL;
      default : cpu_ir_reg_r <= NOP_CTRL;
   endcase
end

endmodule
