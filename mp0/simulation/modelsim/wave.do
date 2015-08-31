onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /mp0_tb/clk
add wave -noupdate -label pc_out /mp0_tb/dut/datapath/pc/out
add wave -noupdate -label mem_address /mp0_tb/mem_address
add wave -noupdate -label mem_read /mp0_tb/mem_read
add wave -noupdate -label mem_rdata /mp0_tb/mem_rdata
add wave -noupdate -label mem_write /mp0_tb/mem_write
add wave -noupdate -label mem_byte_enable /mp0_tb/mem_byte_enable
add wave -noupdate -label mem_wdata /mp0_tb/mem_wdata
add wave -noupdate /mp0_tb/dut/datapath/regfile/load
add wave -noupdate /mp0_tb/dut/datapath/regfile/in
add wave -noupdate /mp0_tb/dut/datapath/regfile/src_a
add wave -noupdate /mp0_tb/dut/datapath/regfile/src_b
add wave -noupdate /mp0_tb/dut/datapath/regfile/dest
add wave -noupdate /mp0_tb/dut/datapath/regfile/reg_a
add wave -noupdate /mp0_tb/dut/datapath/regfile/reg_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 294
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {868620 ps}
