
cd [file dirname [file normalize [info script]]]

if {![file isdirectory work]} {
    vlib work
}
vmap work work

vlog -work work i2s_rx.v
vlog -work work tb_i2s_independent.v

vsim work.tb_i2s_independent

add wave sim:/tb_i2s_independent/clk
add wave sim:/tb_i2s_independent/bclk
add wave sim:/tb_i2s_independent/ws
add wave sim:/tb_i2s_independent/sd
add wave -radix hexadecimal sim:/tb_i2s_independent/sample_data
add wave sim:/tb_i2s_independent/sample_valid

run -all
