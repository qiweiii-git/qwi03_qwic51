#*****************************************************************************
# makeall.sh
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       May. 4, 2019      Initial Release
#*****************************************************************************
#!/bin/bash
source /opt/Xilinx/Vivado/2015.4/settings64.sh

MakeFileDir='build'
OutpFileDir='bin'

if [ -d $OutpFileDir ]; then
   echo "--Warning: Output Files Directory $OutpFileDir Exist--"
   rm -r $OutpFileDir
   echo "--Info: Old Output Files Directory $OutpFileDir Removing--"
fi
mkdir $OutpFileDir
echo "--Info: Output Files Directory $OutpFileDir Establish---"

cd $MakeFileDir
./makefw.sh qwic51 xc7z020clg400-2 2
