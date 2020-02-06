//*****************************************************************************
// qwic51_instructdefs.vh
//
// This module is the instruct defines of qwic51.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 24, 2019     Initial Release
//
//*****************************************************************************
`include "qwic51_defs.vh"

localparam [`CPU_DATA_WIDTH-1:0] MOV     = 'b0001_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] SETB    = 'b0010_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] CLR     = 'b0011_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] AJMP    = 'b0100_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] DJNZ    = 'b0101_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] RET     = 'b0111_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] LCALL   = 'b1000_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] NOP     = 'b1111_xxxx;


//localparam [`CPU_DATA_WIDTH-1:0] MOV_A   = 'b0001_0010;
//localparam [`CPU_DATA_WIDTH-1:0] MOV_Rn  = 'b0001_1xxx;

localparam RESET_CTRL  = 8'b0000_0000;
localparam SETB_CTRL   = 8'b0010_0000;
localparam CLR_CTRL    = 8'b0011_0000;
localparam AJMP_CTRL   = 8'b0100_0000;
localparam MOV_CTRL    = 8'b0001_0000;
localparam DJNZ_CTRL   = 8'b0101_0000;
localparam LCALL_CTRL  = 8'b1000_0000;
localparam RET_CTRL    = 8'b0111_0000;
localparam NOP_CTRL    = 8'b1111_0000;
