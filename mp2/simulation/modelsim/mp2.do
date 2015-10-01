onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp2_tb/clk
add wave -noupdate /mp2_tb/pmem_resp
add wave -noupdate /mp2_tb/pmem_read
add wave -noupdate /mp2_tb/pmem_write
add wave -noupdate /mp2_tb/pmem_address
add wave -noupdate /mp2_tb/pmem_rdata
add wave -noupdate /mp2_tb/pmem_wdata
add wave -noupdate /mp2_tb/clk
add wave -noupdate /mp2_tb/pmem_resp
add wave -noupdate /mp2_tb/pmem_read
add wave -noupdate /mp2_tb/pmem_write
add wave -noupdate /mp2_tb/pmem_address
add wave -noupdate /mp2_tb/pmem_rdata
add wave -noupdate /mp2_tb/pmem_wdata
add wave -noupdate -radix hexadecimal /mp2_tb/clk
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu/opcode
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu/cpu_control/state
add wave -noupdate -expand /mp2_tb/dut/cpu/cpu_datapath/regfile/data
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_datapath/index
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_datapath/offset
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_datapath/tag
add wave -noupdate -radix hexadecimal -childformat {{{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[7]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[6]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[5]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[4]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[3]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[2]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[1]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/cache/cache_datapath/dataarr1/data[7]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr1/data[6]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr1/data[5]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr1/data[4]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr1/data[3]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr1/data[2]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr1/data[1]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr1/data[0]} {-height 15 -radix hexadecimal}} /mp2_tb/dut/cache/cache_datapath/dataarr1/data
add wave -noupdate -radix hexadecimal -childformat {{{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[7]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[6]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[5]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[4]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[3]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[2]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[1]} -radix hexadecimal} {{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/cache/cache_datapath/dataarr0/data[7]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr0/data[6]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr0/data[5]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr0/data[4]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr0/data[3]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr0/data[2]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr0/data[1]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/dataarr0/data[0]} {-height 15 -radix hexadecimal}} /mp2_tb/dut/cache/cache_datapath/dataarr0/data
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_control/ishit1_out
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_control/ishit0_out
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_control/mem_read
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_control/mem_write
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_control/mem_resp
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_control/state
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/mem_rdata
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/mem_address
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/lruarr/data
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/dirtyarr1/data
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/dirtyarr0/data
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirtyarr1/write
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirtyarr1/index
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirtyarr1/datain
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirtyarr1/dataout
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirtyarr0/write
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirtyarr0/index
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirtyarr0/datain
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirtyarr0/dataout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2607662 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 530
configure wave -valuecolwidth 261
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
WaveRestoreZoom {2535416 ps} {2654584 ps}
