
source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_axis_fifo
adi_ip_files util_axis_fifo [list \
	"address_generator.v" \
	"../common/ad_mem.v" \
	"../common/ad_mem_asym.v" \
	"util_axis_fifo.v" \
]

adi_ip_properties_lite util_axis_fifo

adi_ip_add_core_dependencies { \
	analog.com:user:util_cdc:1.0 \
}

adi_add_bus "s_axis" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"s_axis_valid" "TVALID"} \
		{"s_axis_ready" "TREADY"} \
		{"s_axis_data" "TDATA"} \
	}

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_valid" "TVALID"} \
		{"m_axis_ready" "TREADY"} \
		{"m_axis_data" "TDATA"} \
	}

adi_add_bus_clock "m_axis_aclk" "m_axis" "m_axis_aresetn"
adi_add_bus_clock "s_axis_aclk" "s_axis" "m_axis_aresetn"

## TODO: Validate RD_ADDRESS_WIDTH

## add parameters to GUI

ipgui::add_param -name {WR_DATA_WIDTH} -component [ipx::current_core] -display_name {Write Data Width} -show_label {true} -show_range {true} -widget {}
ipgui::add_param -name {RD_DATA_WIDTH} -component [ipx::current_core] -display_name {Read Data Width} -show_label {true} -show_range {true} -widget {}
ipgui::add_param -name {WR_ADDRESS_WIDTH} -component [ipx::current_core] -display_name {Address width of the write side. The actual depth of the FIFO} -show_label {true} -show_range {true} -widget {}
ipgui::add_param -name {RD_ADDRESS_WIDTH} -component [ipx::current_core] -display_name {Address width of the read side.} -show_label {true} -show_range {true} -widget {}
ipgui::add_param -name {ASYNC_CLK} -component [ipx::current_core] -display_name {Asynchronous write/read interface} -show_label {true} -show_range {true} -widget {}
ipgui::add_param -name {S_AXIS_REGISTERED} -component [ipx::current_core] -display_name {Registered data output on AXIS slave} -show_label {true} -show_range {true} -widget {}

ipx::save_core [ipx::current_core]
