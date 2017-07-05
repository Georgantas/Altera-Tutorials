transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Georgantas/Documents/Altera-Tutorials/digital_logic_tuts/waveform_editor {C:/Users/Georgantas/Documents/Altera-Tutorials/digital_logic_tuts/waveform_editor/majority3.v}

