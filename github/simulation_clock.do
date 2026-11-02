vlib work
vmap work work

vlog i2s_clock_gen.v
vlog tb_i2s_clock_gen.v

vsim work.tb_i2s_clock_gen

add wave sim:/tb_i2s_clock_gen/clk
add wave sim:/tb_i2s_clock_gen/rst_n
add wave sim:/tb_i2s_clock_gen/bclk
add wave sim:/tb_i2s_clock_gen/ws

run 100 us
wave zoomrange 40000ns 70000ns

