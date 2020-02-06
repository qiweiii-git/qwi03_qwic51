#*****************************************************************************
# makefw.sh
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       May. 4, 2019      Initial Release
#*****************************************************************************
#!/bin/bash

FileSys='..'
BuildDir='.build'
BuildFileDir='build'
BitFileDir='impl_1/'
CopyBitFileDir='bin'
CopyBitRoute='../../../..'

PrjName=$1
ChipType=$2
CpuCnt=$3
echo "--Info: Project Name is $PrjName------"

cd $FileSys
#make dir
if [ -d $BuildDir ]; then
   echo "--Warning: Building Directory $BuildDir Exist--"
   rm -r $BuildDir
   echo "--Info: Old Building Directory $BuildDir Removing--"
fi
mkdir $BuildDir
echo "--Info: Building Directory $FileSys/$BuildDir Establish---"

#copy source files
cp * $BuildDir -r

#building
cd $BuildDir/$BuildFileDir
echo "RunFw $PrjName $ChipType $CpuCnt" >> runfw.tcl
echo "--Info: $PrjName Project is building----"
vivado -mode batch -source runfw.tcl

#finish building
echo "--Info: $PrjName Project finish building----"

#copy the bit file
cd $PrjName.runs/$BitFileDir
if [ -f $PrjName.bit ]; then
   cp $PrjName.bit $CopyBitRoute/$CopyBitFileDir
   cp $CopyBitRoute/$BuildDir/$BuildFileDir/SDK/$PrjName.hdf $CopyBitRoute/$CopyBitFileDir
   echo "--Info: $PrjName bit file moved to BIN-----"
   #clean
   cd $CopyBitRoute
   rm -rf $BuildDir
   echo "--Info: $PrjName bit file finish making-----"
   echo -e "\n   Success \n"
else
   echo "--Error: $PrjName Project built failed-----"
   echo "--Error: $PrjName Project make failed-----"
   echo -e "\n   Failure \n"
fi
