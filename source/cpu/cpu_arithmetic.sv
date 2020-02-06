//*****************************************************************************
// cpu_arithmetic.sv
//
// This module is the arithmetic unit of cpu.
//
// The cpu_arithmetic included registers:
// ACC, TMP1, B, ALU, PSW
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 24, 2019     Initial Release
//
//*****************************************************************************

`ifdef SIM
`include "qwic51_include.vh"
`endif
module cpu_arithmetic
(
   input                        CLK,

   input  [`CPU_DATA_WIDTH-1:0] MEM_WR_DATA,
   output [`CPU_DATA_WIDTH-1:0] MEM_RD_DATA,
   input  [`CPU_ADDR_WIDTH-1:0] MEM_ADDR,
   input                        MEM_WR,
   input                        MEM_RD
);

//*****************************************************************************
// Parameters
//*****************************************************************************
enum {
   ACC_REG  = 0,
   TMP1_REG = 1,
   B_REG    = 2,
   ALU_REG  = 3,
   PSW_REG  = 4,
   REGS_CNT
} e_regs;

//*****************************************************************************
// Signals
//*****************************************************************************
reg  [`CPU_DATA_WIDTH-1:0] mem_rams [REGS_CNT-1:0];
reg  [`CPU_DATA_WIDTH-1:0] mem_rd_data_r;
reg                        alu_req;

//*****************************************************************************
// Processes
//*****************************************************************************
assign MEM_RD_DATA = mem_rd_data_r;

// Memory RW
always @(posedge CLK)
begin
   if(MEM_RD)
   begin
      case(MEM_ADDR)
         ACC   : mem_rd_data_r <= mem_rams[ACC_REG];
         B     : mem_rd_data_r <= mem_rams[B_REG];
         PSW   : mem_rd_data_r <= mem_rams[PSW_REG];
         default ;
      endcase
   end
end

// Setup mem_rams[ALU_REG] 2 clock later calculate result.
always @(posedge CLK)
begin
   if(MEM_WR && MEM_ADDR == ALU_)
      alu_req <= 1'b1;
   else
      alu_req <= 1'b0;
end

always @(posedge CLK)
begin
   if(MEM_WR)
   begin
      case(MEM_ADDR)
         ACC   : mem_rams[ACC_REG]  <= MEM_WR_DATA;
         TMP1_ : mem_rams[TMP1_REG] <= MEM_WR_DATA;
         B     : mem_rams[B_REG]    <= MEM_WR_DATA;
         ALU_  : mem_rams[ALU_REG]  <= MEM_WR_DATA;
         default ;
      endcase
   end
   else if(alu_req)
   begin
      casex(mem_rams[ALU_REG])
         ARITH_ADD   : mem_rams[ACC_REG] <= mem_rams[ACC_REG] + mem_rams[TMP1_REG];
         ARITH_SUB   : mem_rams[ACC_REG] <= mem_rams[ACC_REG] - mem_rams[TMP1_REG];
         ARITH_MUL   : mem_rams[ACC_REG] <= mem_rams[ACC_REG] * mem_rams[TMP1_REG];
         ARITH_DIV   : mem_rams[ACC_REG] <= mem_rams[ACC_REG] / mem_rams[TMP1_REG];
         ARITH_PLUS  : mem_rams[ACC_REG] <= mem_rams[ACC_REG] + 1;
         ARITH_DEC   : mem_rams[ACC_REG] <= mem_rams[ACC_REG] - 1;
         ARITH_AND   : mem_rams[ACC_REG] <= mem_rams[ACC_REG] & mem_rams[TMP1_REG];
         ARITH_OR    : mem_rams[ACC_REG] <= mem_rams[ACC_REG] | mem_rams[TMP1_REG];
         ARITH_XOR   : mem_rams[ACC_REG] <= mem_rams[ACC_REG] ^ mem_rams[TMP1_REG];
         default ;
      endcase
   end
end

endmodule
