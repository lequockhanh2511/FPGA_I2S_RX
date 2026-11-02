
# Bien dich cac module
vlib work
vmap work work

vlog -work work i2s_clock_gen.v
vlog -work work i2s_rx.v
vlog -work work tb_i2s_rx.v

# Khoi dong mo phong
vsim work.tb_i2s_rx

# Hien thi tin hieu
add wave sim:/tb_i2s_rx/clk
add wave sim:/tb_i2s_rx/rst_n
add wave sim:/tb_i2s_rx/bclk
add wave sim:/tb_i2s_rx/ws
add wave sim:/tb_i2s_rx/sd
add wave -radix hexadecimal sim:/tb_i2s_rx/sample_data
add wave sim:/tb_i2s_rx/sample_valid

# Chay 100 us
run 100 us

# Phong to
wave zoomrange 20000ns 65000ns
