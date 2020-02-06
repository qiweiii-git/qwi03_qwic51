
`ifdef SIM
`include "qwic51_include.vh"
`endif
`timescale 1ns/1ns
module t();

reg        CPU_CLK = 1;
reg        CPU_RESET = 1;

initial #200 CPU_RESET = 0;
always  #10  CPU_CLK = ~CPU_CLK;//10M

qwic51 u_qwic51
(
`ifdef SIM
   .CPU_RESET   ( CPU_RESET ),
`endif
   .CLK         ( CPU_CLK ),
   .LED         ( )
);

endmodule
