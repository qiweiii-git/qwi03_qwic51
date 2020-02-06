//*****************************************************************************
// qwic51.sv
//
// This module is the top level wrapper of qwic51.
//
// Change History:
//  VER.   Author         DATE              Change Description
//  0.1    Qiwei Wu       Nov. 30, 2019     Initial Release
//
//*****************************************************************************

`ifdef SIM
`include "qwic51_include.vh"
`endif
module qwic51
(
`ifdef SIM
   input             CPU_RESET,
`endif
   input             CLK,
   output [3:0]      LED
);

//*****************************************************************************
// Signals
//*****************************************************************************
wire [`CPU_DATA_WIDTH-1:0] cpu_ir_reg;
wire [`CPU_ROM_ADDWID-1:0] cpu_pc_addr;
wire [`CPU_DATA_WIDTH-1:0] cpu_p0_out;
wire [`CPU_DATA_WIDTH-1:0] cpu_p1_out;
wire [`CPU_DATA_WIDTH-1:0] cpu_p2_out;
wire [`CPU_DATA_WIDTH-1:0] cpu_p3_out;

wire                       clk_10m_fb;
wire                       clk_10m_bufg;
wire                       clk_10m;
wire                       clk_50m_bufg;

//*****************************************************************************
// Processes
//*****************************************************************************
assign LED[0]   = cpu_p0_out[0];
assign LED[3:1] = 3'b111;

//*****************************************************************************
// Maps
//*****************************************************************************
qwic51_core QWIC51_CORE
(
   .CPU_CLK     ( clk_10m_bufg ),
`ifdef SIM
   .CPU_RESET   ( CPU_RESET ),
`endif
   .CPU_IR_REG  ( cpu_ir_reg ),

   .CPU_PC_ADDR ( cpu_pc_addr ),
   .CPU_P0_OUT  ( cpu_p0_out ),
   .CPU_P1_OUT  ( cpu_p1_out ),
   .CPU_P2_OUT  ( cpu_p2_out ),
   .CPU_P3_OUT  ( cpu_p3_out )
);

qwic51_rom QWIC51_ROM
(
   .CPU_CLK     ( clk_10m_bufg ),

   .CPU_PC_ADDR ( cpu_pc_addr ),
   .CPU_IR_REG  ( cpu_ir_reg )
);

`ifdef SIM
assign clk_10m_bufg = CLK;
`else
BUFG CLK50M_BUFG
(
   .O           ( clk_50m_bufg ),
   .I           ( CLK )
);

BUFG CLK10M_BUFG
(
   .O           ( clk_10m_bufg ),
   .I           ( clk_10m )
);

MMCME2_BASE
#(
   .BANDWIDTH          ( "OPTIMIZED" ),
   .CLKFBOUT_MULT_F    ( 20.0 ),
   .CLKFBOUT_PHASE     ( 0.0 ),
   .CLKIN1_PERIOD      ( 20.0 ),
   // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
   .CLKOUT0_DIVIDE_F   ( 100.0 ),
   // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
   .CLKOUT0_DUTY_CYCLE ( 0.5 ),
   // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
   .CLKOUT0_PHASE      ( 0.0 ),
   .CLKOUT4_CASCADE    ( "FALSE" ),
   .DIVCLK_DIVIDE      ( 1 ),        
   .REF_JITTER1        ( 0.0 ),        
   .STARTUP_WAIT       ( "FALSE" )    
)
CLK10M_MMCM
(
   // Clock Outputs: 1-bit (each) output: User configurable clock outputs
   .CLKOUT0            ( clk_10m ),
   .CLKOUT0B           ( ),
   // Feedback Clocks: 1-bit (each) output: Clock feedback ports
   .CLKFBOUT           ( clk_10m_fb ),
   .CLKFBOUTB          ( ),
   // Status Ports: 1-bit (each) output: MMCM status ports
   .LOCKED             ( ),
   // Clock Inputs: 1-bit (each) input: Clock input
   .CLKIN1             ( clk_50m_bufg ),
   // Control Ports: 1-bit (each) input: MMCM control ports
   .PWRDWN             ( 1'b0 ),
   .RST                ( 1'b0 ),
   // Feedback Clocks: 1-bit (each) input: Clock feedback ports
   .CLKFBIN            ( clk_10m_fb )
);
`endif

endmodule
