#******************************************************************************
# runfw.tcl
#
# This module is the tcl script of building project.
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       Feb. 1, 2020      Initial Release
#******************************************************************************

proc RunFw { buildName chipType coreNum } {
   # create project
   create_project $buildName -part $chipType

   # add working path
   set current_path [pwd]

   # add source file to project
   source ./file_list.tcl

   # set top
   set_property top $buildName [current_fileset]
   update_compile_order -fileset sources_1

   # synthesize
   reset_run synth_1
   launch_runs synth_1 -jobs $coreNum
   wait_on_run synth_1

   # HDF
   file mkdir ./SDK
   write_hwdef -force -file ./SDK/$buildName.hdf

   # implement
   launch_runs impl_1 -jobs $coreNum
   wait_on_run impl_1

   # Generate the bitstream.
   launch_runs impl_1 -to_step write_bitstream -jobs $coreNum
   wait_on_run impl_1
}

# Example
# RunFw qwi00_led xc7z020clg400-2 2
