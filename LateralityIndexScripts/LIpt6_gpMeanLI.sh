#!/bin/sh
#npnlusc
#KLI 20160323
#kaoriito(at)usc.edu

#########
cd ~
ROOTDIR=/PATH/TO/DIRECTORY;

ROI_dir=/PATH/TO/ROIS #this directory contains your ROIs in .nii format

copes="cope1 cope2";

###################################
cd ~
cd $ROI_dir
pwd
LROIs=`ls -a L_*.nii`;
############################

cd $ROOTDIR/Laterality_Index/LI_group;
mkdir z-mean;

cd $ROOTDIR/Laterality_Index/subjLI;

TxtFile=`ls | sort -n | head -1`;
echo $TxtFile;
numLines=`wc -l < $TxtFile`;
numLines=$((numLines+1));
echo $numLines;


for ROI in $LROIs; do
		String2find=${ROI:2};
	
	for cope in $copes; do
		echo "now on " $cope;
		
		totalROIfiles=`ls $String2find*${cope}*.txt`;
		
		echo $totalROIfiles;
		
		for ROIfile in $totalROIfiles;do 
			sed -n "${numLines}p" $ROIfile >> $ROOTDIR/Laterality_Index/LI_group/z-mean/${String2find}_${cope}.txt;
		done
		
	done			

done 