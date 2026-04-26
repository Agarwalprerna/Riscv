vlog -sv +acc testbench.sv
vsim  work.testbench
add wave -r *
run -all

