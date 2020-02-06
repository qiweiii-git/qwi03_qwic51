# Verilog compile options
set VLOG_OPTS "+acc"
set VLOG_OPTS "$VLOG_OPTS +incdir+../project"
set VLOG_OPTS "$VLOG_OPTS +incdir+../project/cpu"
set VLOG_OPTS "$VLOG_OPTS +incdir+../project/define"

# Verilog source directory list
set VLOG_DIR_LIST [list ]
lappend VLOG_DIR_LIST "../project"
lappend VLOG_DIR_LIST "../project/cpu"
lappend VLOG_DIR_LIST "../project/define"

# flush work library, if present
if { [file exists work] } {
    vdel -lib work -all
}
vlib work

# compile Verilog sources
foreach dir ${VLOG_DIR_LIST} {
    eval vlog ${VLOG_OPTS} t.sv
    eval vlog ${VLOG_OPTS} ../project/define/*.vh
    eval vlog ${VLOG_OPTS} ../project/cpu/*.sv
    eval vlog ${VLOG_OPTS} ../project/*.sv
}
