
# Chuyen den thu muc du an
cd D:/FPGA_I2S_RX

# Tao thu vien neu chua co
if {![file exists work]} {
    vlib work
}
vmap work work

# Bien dich
vlog -work work i2s_clock_gen.v
vlog -work work i2s_rx.v
vlog -work work tb_i2s_rx_auto.v

# Mo phong
vsim work.tb_i2s_rx_auto

# Hien thi dang song
add wave sim:/tb_i2s_rx_auto/clk
add wave sim:/tb_i2s_rx_auto/rst_n
add wave sim:/tb_i2s_rx_auto/bclk
add wave sim:/tb_i2s_rx_auto/ws
add wave sim:/tb_i2s_rx_auto/sd
add wave -radix hexadecimal sim:/tb_i2s_rx_auto/sample_data
add wave sim:/tb_i2s_rx_auto/sample_valid

run -all
wave zoomrange 20000ns 65000ns
