onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /t/CPU_CLK
add wave -noupdate -radix hexadecimal /t/CPU_RESET
add wave -noupdate /t/u_qwic51/LED
add wave -noupdate -radix hexadecimal /t/u_qwic51/QWIC51_ROM/CPU_PC_ADDR
add wave -noupdate /t/u_qwic51/QWIC51_ROM/CPU_IR_REG
add wave -noupdate -expand -group DECODER /t/u_qwic51/QWIC51_CORE/CPU_DECODER/ir_reg_r
add wave -noupdate -expand -group DECODER /t/u_qwic51/QWIC51_CORE/CPU_DECODER/ir_data_r
add wave -noupdate -expand -group DECODER /t/u_qwic51/QWIC51_CORE/CPU_DECODER/dec_state_n
add wave -noupdate -expand -group DECODER /t/u_qwic51/QWIC51_CORE/CPU_DECODER/dec_state_c
add wave -noupdate -expand -group DECODER -radix hexadecimal /t/u_qwic51/QWIC51_CORE/CPU_DECODER/MEM_WR_DATA
add wave -noupdate -expand -group DECODER -radix hexadecimal /t/u_qwic51/QWIC51_CORE/CPU_DECODER/MEM_RD_DATA
add wave -noupdate -expand -group DECODER -radix hexadecimal /t/u_qwic51/QWIC51_CORE/CPU_DECODER/MEM_ADDR
add wave -noupdate -expand -group DECODER -radix hexadecimal /t/u_qwic51/QWIC51_CORE/CPU_DECODER/MEM_WR
add wave -noupdate -expand -group DECODER -radix hexadecimal /t/u_qwic51/QWIC51_CORE/CPU_DECODER/MEM_RD
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 169
configure wave -valuecolwidth 99
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 fs} {2387131998 fs}
