#add constraints
add_files -fileset constrs_1 -norecurse ./constraints/pinout.xdc

#add source
add_files ../source

#set defines
set_property is_global_include true [get_files ../source/define/qwic51_include.vh]
