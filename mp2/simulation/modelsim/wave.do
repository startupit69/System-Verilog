onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /mp2_tb/clk
add wave -noupdate -label pc_out /mp2_tb/dut/datapath/pc/out
add wave -noupdate -label mem_address /mp2_tb/mem_address
add wave -noupdate -label mem_read /mp2_tb/mem_read
add wave -noupdate -label mem_rdata /mp2_tb/mem_rdata
add wave -noupdate -label mem_write /mp2_tb/mem_write
add wave -noupdate -label mem_byte_enable /mp2_tb/mem_byte_enable
add wave -noupdate -label mem_wdata /mp2_tb/mem_wdata
add wave -noupdate {/mp2_tb/dut/datapath/regfile/data[7]}
add wave -noupdate {/mp2_tb/dut/datapath/regfile/data[6]}
add wave -noupdate {/mp2_tb/dut/datapath/regfile/data[5]}
add wave -noupdate {/mp2_tb/dut/datapath/regfile/data[4]}
add wave -noupdate {/mp2_tb/dut/datapath/regfile/data[3]}
add wave -noupdate {/mp2_tb/dut/datapath/regfile/data[2]}
add wave -noupdate {/mp2_tb/dut/datapath/regfile/data[1]}
add wave -noupdate {/mp2_tb/dut/datapath/regfile/data[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {137576 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 333
configure wave -valuecolwidth 59
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
WaveRestoreZoom {0 ps} {503368 ps}
