//*****************************************************************************
// qwic51_arithmeticdefs.vh
//
// This module is the arithmetic defines of qwic51.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 24, 2019     Initial Release
//
//*****************************************************************************
`include "qwic51_defs.vh"

localparam [`CPU_DATA_WIDTH-1:0] ARITH_ADD   = 'b0000_0001;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_SUB   = 'b0000_0010;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_MUL   = 'b0000_0011;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_DIV   = 'b0000_0100;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_PLUS  = 'b0000_1000;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_DEC   = 'b0000_1001;

localparam [`CPU_DATA_WIDTH-1:0] ARITH_AND   = 'b0001_0000;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_OR    = 'b0001_0001;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_XOR   = 'b0001_0010;

// TODO:
localparam [`CPU_DATA_WIDTH-1:0] ARITH_SHIFT = 'b1xxx_xxxx;
