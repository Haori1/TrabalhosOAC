transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/Parametros.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/sqrt_s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/mul_s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/div_s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/c_comp.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/cvt_w_s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/cvt_s_w.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/add_sub.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/abs_s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db/mult_ncs.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db/mult_k5s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db/mult_i5s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db/mult_r5s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/db/mult_p5s.v}
vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/FPALU.v}

vlog -sv -work work +incdir+C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU {C:/Users/lamar/Dropbox/kiko/Disciplinas/UnB/OAC/2018-1/Lab2/Files/FPALU/FPALU_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  FPALU_tb

add wave *
view structure
view signals
run -all
