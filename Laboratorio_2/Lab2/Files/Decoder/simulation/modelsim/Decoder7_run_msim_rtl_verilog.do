transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/Decoder {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/Decoder/decoder7.v}

vlog -vlog01compat -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/Decoder {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/Decoder/decoder7_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  decoder7_tb

add wave *
view structure
view signals
run -all
