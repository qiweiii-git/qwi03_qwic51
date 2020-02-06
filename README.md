## Change Log
- 2019.12.04
- 1.0版本发布

#1.0版本更新
## qwic51系统
### CPU
- 支持8种指令的指令系统cpu_instr_dec。
localparam [`CPU_DATA_WIDTH-1:0] MOV     = 'b0001_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] SETB    = 'b0010_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] CLR     = 'b0011_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] AJMP    = 'b0100_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] DJNZ    = 'b0101_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] RET     = 'b0111_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] LCALL   = 'b1000_xxxx;
localparam [`CPU_DATA_WIDTH-1:0] NOP     = 'b1111_xxxx;

- 运算器cpu_arithmetic。
运算器主要执行+ - * /等运算操作，需要指令系统识别到指令后，将相应数据写入ACC或TMP，并操作ALU寄存器执行相应运算操作。
localparam [`CPU_DATA_WIDTH-1:0] ARITH_ADD   = 'b0000_0001;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_SUB   = 'b0000_0010;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_MUL   = 'b0000_0011;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_DIV   = 'b0000_0100;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_PLUS  = 'b0000_1000;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_DEC   = 'b0000_1001;

localparam [`CPU_DATA_WIDTH-1:0] ARITH_AND   = 'b0001_0000;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_OR    = 'b0001_0001;
localparam [`CPU_DATA_WIDTH-1:0] ARITH_XOR   = 'b0001_0010;

- IO控制cpu_io。
IO控制主要控制P0，P1，P2，P3寄存器。

- 程序计数器cpu_pc。
程序计数器根据指令系统读取1条指令后的发起的PC_PLUS信号进行+1操作，指令系统可对PC的值进行赋值，实现跳转，在LCALL、RET等指令是常用到。

- 片内存储器cpu_ram。
片内存储器主要存储IO、PC、ACC、TMP等以外的寄存器，用于指令系统操作。

### 程序存储器
- 指令内存映射qwic51_rom。
该部分代码主要存放机器能识别的代码，如MOV首先需要翻译成0b00010000，并在接下来的1个地址空间内存放操作的地址，再接下来的1个地址空间内存放操作的数据，这样才能被指令系统cpu_instr_dec正确识别。
翻译指令需要手动翻译，如MOV R0 #2需要被翻译成：
00H:0b00010000
01H:R0地址
02H:2

### 系统时钟
系统时钟为10MHz，通过50MHz分频得到。
