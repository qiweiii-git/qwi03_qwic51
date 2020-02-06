//*****************************************************************************
// qwic51_memdefs.vh
//
// This module is the memory defines of qwic51.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 24, 2019     Initial Release
//
//*****************************************************************************

//*****************************************************************************
// RAMs On Chip(256KB)
//*****************************************************************************
// Lower-128KB
// 0x00-0x1F
localparam
   WORKREG1 = 'h0,
   WORKREG2 = 'h8,
   WORKREG3 = 'h10,
   WORKREG4 = 'h18;

localparam
   REGR0 = 0,
   REGR1 = 1,
   REGR2 = 2,
   REGR3 = 3,
   REGR4 = 4,
   REGR5 = 5,
   REGR6 = 6,
   REGR7 = 7;

// 0x20-0x7F
// General MEM

// Upper-128KB SFR
localparam
   P0    = 'h80,
   SP_   = 'h81,
   DPL_  = 'h82,
   DPH_  = 'h83,
   PCON_ = 'h87,
   TCON  = 'h88,
   TMOD_ = 'h89,
   TL0_  = 'h8A,
   TL1_  = 'h8B,
   TH0_  = 'h8C,
   TH1_  = 'h8D,
   P1    = 'h90,
   SCON  = 'h98,
   SBUF_ = 'h99,
   P2    = 'hA0,
   IE    = 'hA8,
   P3    = 'hB0,
   IP    = 'hB8,
   PSW   = 'hD0,
   ACC   = 'hE0,
   B     = 'hF0;

localparam
   TMP1_ = 'hC0,
   ALU_  = 'hC1,
   PC_L_ = 'hCA,
   PC_H_ = 'hCB;



