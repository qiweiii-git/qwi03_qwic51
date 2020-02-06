
; BEGIN
       ORG 0000H
       AJMP MAIN
       ORG 0050H
MAIN  :CLR P0.0
       LCALL DELAY
       AJMP L1
L1    :SETB P0.0
       LCALL DELAY
       AJMP MAIN

;delay 180ms in 10M clock
DELAY :MOV R0, #240
L3    :MOV R1, #240
L4    :NOP
       DJNZ R1, L4
       DJNZ R0, L3
       RET
; END

; ROM define
localparam MAIN   = 8'h50;
localparam L1     = 8'h56;
localparam DELAY  = 8'h60;
localparam L3     = 8'h63;
localparam L4     = 8'h66;

; ROM mapping
8'h00    : RESET_CTRL
8'h01    : AJMP_CTRL
8'h02    : MAIN
MAIN     : CLR_CTRL + 0'b0000
MAIN + 1 : P0
MAIN + 2 : LCALL_CTRL
MAIN + 3 : DELAY
MAIN + 4 : AJMP_CTRL
MAIN + 5 : L1
L1       : SETB_CTRL + 0'b0000
L1 + 1   : P0
L1 + 2   : LCALL_CTRL
L1 + 3   : DELAY
L1 + 4   : AJMP_CTRL
L1 + 5   : MAIN

DELAY     : MOV_CTRL
DELAY + 1 : WORKREG1 + 0
DELAY + 2 : 200
L3        : MOV_CTRL
L3 + 1    : WORKREG1 + 1
L3 + 2    : 12
L4        : NOP_CTRL
L4 + 1    : DJNZ_CTRL
L4 + 2    : WORKREG1 + 1
L4 + 3    : L4
L4 + 4    : DJNZ_CTRL
L4 + 5    : WORKREG1 + 0
L4 + 6    : L3
L4 + 7    : RET_CTRL






