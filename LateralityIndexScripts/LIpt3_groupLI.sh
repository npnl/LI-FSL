#!/bin/sh

#NPNL Lab
#KLI kaoriito(at)usc.edu 20151120

#####################################
threshSet=( 2.3 1.0 1.5 )#set the z-value here
ROOTDIR=/PATH/TO/DIRECTORY#this is the directory containing the text with LI values calculated from MATLAB 
ROI_dir=/PATH/TO/ROI/DIRECTORY #this directory contains your ROIs in .nii format

###################################
cd ~
cd $ROI_dir
pwd
LROIs=`ls -a L_*.nii`;
############################


cd $ROOTDIR/Laterality_Index;
mkdir LI_group;
cd LI_group;

for THRESH in "${threshSet[@]}"
	do
	mkdir z-$THRESH; #your output will now be saved to $ROOTDIR/Laterality_Index/LI_group/z-$threshSet


	for cope in cope1 cope2; do
			cd $ROOTDIR/Laterality_Index;
			cd $cope/z-$THRESH;
			pwd;
	
			for ROI in $LROIs; do
				String2find=${ROI:2};
			
				totalROIfiles=`ls $String2find*.txt`;
			
				for ROIfile in $totalROIfiles;do 
					sed -n '3p' $ROIfile >> $ROOTDIR/Laterality_Index/LI_group/z-$THRESH/${String2find}_${cope}.txt;
				done
		
		
			done
			
	done

	cd $ROOTDIR/Laterality_Index/LI_group/
done