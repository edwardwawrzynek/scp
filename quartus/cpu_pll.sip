set_global_assignment -entity "cpu_pll" -library "lib_cpu_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "cpu_pll" -library "lib_cpu_pll" -name IP_TOOL_VERSION "19.1"
set_global_assignment -entity "cpu_pll" -library "lib_cpu_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_cpu_pll" -name SPD_FILE [file join $::quartus(sip_path) "cpu_pll.spd"]

set_global_assignment -library "lib_cpu_pll" -name MISC_FILE [file join $::quartus(sip_path) "cpu_pll_sim/cpu_pll.vo"]
