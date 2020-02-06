//*****************************************************************************
// cpu_instr_dec.sv
//
// This module is the instruction decoder of cpu.
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
module cpu_instr_dec
(
   input                        CLK,
   input                        RESET,

   // TODO: implement
   output                       PC_PLUS,
   input  [`CPU_DATA_WIDTH-1:0] IR_REG,

   output [`CPU_DATA_WIDTH-1:0] MEM_WR_DATA,
   input  [`CPU_DATA_WIDTH-1:0] MEM_RD_DATA,
   output [`CPU_ADDR_WIDTH-1:0] MEM_ADDR,
   output                       MEM_WR,
   output                       MEM_RD
);

//*****************************************************************************
// Parameters
//*****************************************************************************
enum logic [3:0] {
   IDLE,        // Idle state
   INSTR_FETCH, // Fetch instrucion state
   INSTR_DEC,   // Decode instruction state
   AL_PROC,     // Arithmetic & Logical process state
   IO_COMM,     // IO communicate state
   PC_JUMP,     // PC jump state
   WAIT         // Wait for done
} dec_state_n, dec_state_c;

enum logic [3:0] {
   GET_VALUE,
   WR_ACC,
   WR_TMP,
   WR_ALU,
   RD_ACC,
   WR_SRC,
   AL_PC_JUMP,
   AL_DONE
} al_state;

//*****************************************************************************
// Signals
//*****************************************************************************
reg                        pc_plus_r;
reg  [`CPU_DATA_WIDTH-1:0] ir_reg_r;
reg  [`CPU_DATA_WIDTH-1:0] ir_data_r;
reg                        al_proc_req;
reg                        al_proc_done;
reg                        pc_jump_req;
reg                        pc_jump_done;
reg                        io_comm_req;
reg                        io_comm_done;
reg                        al_pc_jump_req;
reg  [`CPU_ADDR_WIDTH-1:0] addr_comm;
reg  [`CPU_ADDR_WIDTH-1:0] al_addr;
reg  [`CPU_ADDR_WIDTH-1:0] addr_comm_al;
reg  [`CPU_DATA_WIDTH-1:0] data_comm;
reg  [`CPU_DATA_WIDTH-1:0] addr_shift;
reg  [`CPU_DATA_WIDTH-1:0] al_data;
reg  [`CPU_DATA_WIDTH-1:0] al_pc_jump_data;
reg                        req_addr;
reg                        req_data;
reg  [1:0]                 pc_calc_delay;
reg  [1:0]                 al_delay;
reg                        al_wr;
reg                        al_rd;
reg                        pc_wr_req;
reg                        pc_rd_req;
reg                        pc_rd_first;
reg  [`CPU_DATA_WIDTH-1:0] pc_capt;
reg                        acc_rdy;
reg                        tmp_rdy;
reg                        alu_rdy;
reg                        al_done;
reg                        wr_comm;
reg                        rd_comm;

//*****************************************************************************
// Processes
//*****************************************************************************
assign MEM_WR      = wr_comm;
assign MEM_RD      = rd_comm;
assign MEM_ADDR    = addr_comm;
assign MEM_WR_DATA = data_comm;

assign PC_PLUS = pc_plus_r;

always @(posedge CLK or posedge RESET)
begin
   if(RESET)
      pc_plus_r <= 0;
   else if(dec_state_n == INSTR_FETCH)
      pc_plus_r <= 1'b1;
   else
      pc_plus_r <= 0;
end

// STEP1
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
      dec_state_c <= IDLE;
   else
      dec_state_c <= dec_state_n;
end

// STEP2
always @(*)
begin
   case(dec_state_c)
      IDLE:
      begin
         dec_state_n = INSTR_FETCH;
      end

      INSTR_FETCH:
      begin
         dec_state_n = INSTR_DEC;
      end

      INSTR_DEC:
      begin
         if(pc_jump_req)
            dec_state_n = PC_JUMP;
         else if(io_comm_req)
            dec_state_n = IO_COMM;
         else if(al_proc_req)
            dec_state_n = AL_PROC;
         else
            dec_state_n = IDLE;
      end

      AL_PROC:
      begin
         if(al_proc_done)
         begin
            if(al_pc_jump_req)
               dec_state_n = IO_COMM;
            else
               dec_state_n = WAIT;
         end
         else
            dec_state_n = AL_PROC;
      end

      IO_COMM:
      begin
         if(io_comm_done)
            dec_state_n = WAIT;
         else
            dec_state_n = IO_COMM;
      end

      PC_JUMP:
      begin
         if(pc_jump_done)
            dec_state_n = WAIT;
         else
            dec_state_n = PC_JUMP;
      end

      WAIT: dec_state_n = IDLE;

      default: dec_state_n = IDLE;
   endcase
end

// STEP3
// Instruction Reg capture
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
      ir_reg_r <= 0;
   else if(dec_state_n == INSTR_FETCH && !req_addr && !req_data)
      ir_reg_r <= IR_REG;
end

always @(posedge CLK or posedge RESET)
begin
   if(RESET)
      ir_data_r <= 0;
   else if(dec_state_n == INSTR_FETCH)
      ir_data_r <= IR_REG;
end

// Require address or data from ROM
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
   begin
      req_addr <= 0;
      req_data <= 0;
   end
   else if(dec_state_c == INSTR_FETCH)
   begin
      if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == MOV[`CPU_DATA_WIDTH-1-:4])
      begin
         req_addr <= ~req_addr;
         req_data <= req_addr;
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == SETB[`CPU_DATA_WIDTH-1-:4])
      begin
         req_addr <= ~req_addr;
         req_data <= 0;
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == CLR[`CPU_DATA_WIDTH-1-:4])
      begin
         req_addr <= ~req_addr;
         req_data <= 0;
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == AJMP[`CPU_DATA_WIDTH-1-:4])
      begin
         req_addr <= ~req_addr;
         req_data <= 0;
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == DJNZ[`CPU_DATA_WIDTH-1-:4])
      begin
         req_addr <= ~req_addr;
         req_data <= req_addr;
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == LCALL[`CPU_DATA_WIDTH-1-:4])
      begin
         req_addr <= ~req_addr;
         req_data <= 0;
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == RET[`CPU_DATA_WIDTH-1-:4])
      begin
         req_addr <= 0;
         req_data <= 0;
      end
      else
      begin
         req_addr <= 0;
         req_data <= 0;
      end
   end
   //else if(dec_state_n == INSTR_DEC)
   else if(pc_jump_req || io_comm_req || al_proc_req)
   begin
      req_addr <= 0;
      req_data <= 0;
   end
end

// Instruction decoder
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
   begin
      addr_comm   <= 0;
      data_comm   <= 0;
      addr_shift  <= 0;
   end
   else if(dec_state_n == INSTR_DEC)
   begin
      if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == MOV[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
            addr_comm <= ir_data_r;
         else if(req_data)
            data_comm <= ir_data_r;
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == SETB[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
         begin
            addr_comm <= ir_data_r;
            data_comm <= 1 << addr_shift;
         end
         else
            addr_shift <= ir_reg_r[3:0];
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == CLR[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
         begin
            addr_comm <= ir_data_r;
            data_comm <= 0 << addr_shift;
         end
         else
            addr_shift <= ir_reg_r[3:0];
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == AJMP[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
         begin
            addr_comm <= PC_L_;
            data_comm <= ir_data_r;
         end
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == DJNZ[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
            addr_comm <= ir_data_r;
         else if(req_data)
            data_comm <= ir_data_r;
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == LCALL[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
         begin
            addr_comm <= PC_L_;
            data_comm <= ir_data_r;
         end
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == RET[`CPU_DATA_WIDTH-1-:4])
      begin
         addr_comm <= PC_L_;
         data_comm <= pc_capt;
      end
   end
   else if(dec_state_c == AL_PROC)
   begin
      if(al_pc_jump_req)
      begin
         addr_comm <= PC_L_;
         data_comm <= al_pc_jump_data;
      end
      else
      begin
         addr_comm <= al_addr;
         data_comm <= al_data;
      end
   end
end

// Require generate
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
   begin
      al_proc_req <= 0;
      pc_jump_req <= 0;
      io_comm_req <= 0;
   end
   else if(dec_state_n == INSTR_DEC)
   begin
      if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == MOV[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_data)
         begin
            al_proc_req <= 1'b0;
            pc_jump_req <= 1'b0;
            io_comm_req <= 1'b1;
         end
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == SETB[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
         begin
            al_proc_req <= 1'b0;
            pc_jump_req <= 1'b0;
            io_comm_req <= 1'b1;
         end
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == CLR[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
         begin
            al_proc_req <= 1'b0;
            pc_jump_req <= 1'b0;
            io_comm_req <= 1'b1;
         end
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == AJMP[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
         begin
            al_proc_req <= 1'b0;
            pc_jump_req <= 1'b1;
            io_comm_req <= 1'b0;
         end
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == DJNZ[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_data)
         begin
            al_proc_req <= 1'b1;
            pc_jump_req <= 1'b0;
            io_comm_req <= 1'b0;
         end
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == LCALL[`CPU_DATA_WIDTH-1-:4])
      begin
         if(req_addr)
         begin
            al_proc_req <= 1'b0;
            pc_jump_req <= 1'b1;
            io_comm_req <= 1'b0;
         end
      end
      else if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == RET[`CPU_DATA_WIDTH-1-:4])
      begin
         al_proc_req <= 1'b0;
         pc_jump_req <= 1'b1;
         io_comm_req <= 1'b0;
      end
      else/* if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == NOP[`CPU_DATA_WIDTH-1-:4])*/
      begin
         al_proc_req <= 1'b0;
         pc_jump_req <= 1'b0;
         io_comm_req <= 1'b0;
      end
   end
   else
   begin
      al_proc_req <= 0;
      pc_jump_req <= 0;
      io_comm_req <= 0;
   end
end

// Arithmetic & Logical process
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
   begin
      acc_rdy <= 0;
      tmp_rdy <= 0;
      alu_rdy <= 0;
      al_done <= 0;
   end
   else if(dec_state_n == AL_PROC && dec_state_c != AL_PROC)
   begin
      if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == DJNZ[`CPU_DATA_WIDTH-1-:4])
      begin
         al_state        <= GET_VALUE;
         addr_comm_al    <= addr_comm;
         al_pc_jump_data <= data_comm;
         al_pc_jump_req  <= 1'b0;
         al_delay       <= 0;
      end
   end
   else if(dec_state_c == AL_PROC)
   begin
      if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == DJNZ[`CPU_DATA_WIDTH-1-:4])
      begin
         case(al_state)
            GET_VALUE:
            begin
               al_wr       <= 1'b0;
               al_rd       <= 1'b1;
               al_addr     <= addr_comm_al;
               al_data     <= 0;

               al_state <= WR_ACC;
               al_delay <= 0;
            end

            WR_ACC:
            begin
               al_rd    <= 1'b0;
               al_delay <= al_delay + 1;

               if(&al_delay[1:0])
               begin
                  al_wr    <= 1'b1;
                  al_addr  <= ACC;
                  al_data  <= MEM_RD_DATA;
                  al_state <= WR_TMP;
               end
            end

            WR_TMP:
            begin
               al_delay <= 0;
               al_wr    <= 1'b1;
               al_rd    <= 1'b0;
               al_addr  <= TMP1_;
               al_data  <= 1;
               al_state <= WR_ALU;
            end

            WR_ALU:
            begin
               al_delay <= 0;
               al_wr    <= 1'b1;
               al_rd    <= 1'b0;
               al_addr  <= ALU_;
               al_data  <= ARITH_SUB;
               al_state <= RD_ACC;
            end

            RD_ACC:
            begin
               al_wr    <= 1'b0;
               al_delay <= al_delay + 1;

               if(&al_delay[1])
               begin
                  al_rd    <= 1'b1;
                  al_addr  <= ACC;
                  al_data  <= 0;
                  al_state <= WR_SRC;
                  al_delay <= 0;
               end
            end

            WR_SRC:
            begin
               al_rd    <= 1'b0;
               al_delay <= al_delay + 1;

               if(&al_delay[1:0])
               begin
                  al_wr    <= 1'b1;
                  al_addr  <= addr_comm_al;
                  al_data  <= MEM_RD_DATA;
                  al_delay <= 0;

                  if(MEM_RD_DATA != 0)
                     al_state <= AL_PC_JUMP;
                  else
                     al_state <= AL_DONE;
               end
            end

            AL_PC_JUMP:
            begin
               al_wr          <= 1'b0;
               al_rd          <= 1'b0;
               al_addr        <= 0;
               al_data        <= 0;
               al_delay       <= 0;
               al_state       <= AL_DONE;
               al_pc_jump_req <= 1'b1;
            end

            AL_DONE:
            begin
               al_wr          <= 1'b0;
               al_rd          <= 1'b0;
               al_addr        <= 0;
               al_data        <= 0;
               al_delay       <= 0;

               al_state       <= AL_DONE;
            end

            default ;
         endcase
      end
   end
   else
   begin
      al_wr          <= 1'b0;
      al_rd          <= 1'b0;
      al_addr        <= 0;
      al_data        <= 0;
      al_delay       <= 0;

      al_state        <= GET_VALUE;
      al_pc_jump_req  <= 1'b0;
   end
end

// AL process done
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
      al_proc_done <= 0;
   else if(dec_state_c == AL_PROC && al_state == AL_DONE)
      al_proc_done <= 1'b1;
   else
      al_proc_done <= 0;
end

// IP communicate done
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
      io_comm_done <= 0;
   else if(dec_state_n == IO_COMM)
      io_comm_done <= 1'b1;
   else
      io_comm_done <= 0;
end

// PC calculate done
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
   begin
      pc_calc_delay <= 0;
      pc_jump_done <= 0;
      pc_wr_req <= 1'b0;
      pc_rd_req <= 1'b0;
      pc_rd_first <= 1'b0;
      pc_capt <= 0;
   end
   else if(dec_state_n == PC_JUMP && dec_state_c != PC_JUMP)
   begin
      pc_calc_delay <= 0;
      pc_jump_done <= 0;

      if(ir_reg_r[`CPU_DATA_WIDTH-1-:4] == LCALL[`CPU_DATA_WIDTH-1-:4])
      begin
         pc_wr_req <= 1'b0;
         pc_rd_req <= 1'b1;
         pc_rd_first <= 1'b1;
      end
      else
      begin
         pc_wr_req <= 1'b1;
         pc_rd_req <= 1'b0;
         pc_rd_first <= 1'b0;
      end
   end
   else if(dec_state_c == PC_JUMP && &pc_calc_delay[1:0])
   begin
      if(pc_rd_first)
      begin
         pc_capt <= MEM_RD_DATA;

         pc_calc_delay <= 0;
         pc_rd_first <= 1'b0;
         pc_jump_done <= 1'b0;
         pc_wr_req <= 1'b1;
         pc_rd_req <= 1'b0;
      end
      else
      begin
         pc_rd_first <= 1'b0;
         pc_jump_done <= 1'b1;
         pc_wr_req <= 1'b0;
         pc_rd_req <= 1'b0;
      end
   end
   else
   begin
      pc_calc_delay <= pc_calc_delay + 1;
      pc_jump_done <= 0;
      pc_wr_req <= 1'b0;
      pc_rd_req <= 1'b0;
   end
end

// Memory RW require generate
always @(posedge CLK or posedge RESET)
begin
   if(RESET)
   begin
      wr_comm <= 0;
      rd_comm <= 0;
   end
   else if(dec_state_n == IO_COMM)
   begin
      wr_comm <= 1'b1;
      rd_comm <= 0;
   end
   else if(dec_state_c == PC_JUMP)
   begin
      wr_comm <= pc_wr_req;
      rd_comm <= pc_rd_req;
   end
   else if(dec_state_c == AL_PROC)
   begin
      wr_comm <= al_wr;
      rd_comm <= al_rd;
   end
   else
   begin
      wr_comm <= 0;
      rd_comm <= 0;
   end
end

endmodule
