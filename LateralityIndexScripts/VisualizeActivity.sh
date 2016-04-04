#!/bin/sh
#npnl usc
#20160324
#KLI kaoriito(at)usc.edu
#this script uses the ROI in standard space to mask out activity in other regions to help visualize if any activity is in the area of the lesion.
#take the output of the script (Subject/Activation_Overlaps) and overlay with the subject's T1 image registered to standard space.

cd ~

##############
ROOTDIR=/PATH/TO/DIRECTORY;

ROI_dir=/PATH/TO/ROIS; 

zthresh=1.5; #set the threshold you want to visualize.


###############

cd $ROI_dir;
pwd
LROIs=`ls -a L_*.nii`;
RROIs=`ls -a R_*.nii`;


################
WholeBrainActivation=lev2/cope1.feat/stats/zstat1-${zthresh}.nii.gz;

cd $ROOTDIR;

SUBJS=`ls -d *`;

LatIndex="Laterality_Index";

for SUBJ in $SUBJS; do

	if [[ "$SUBJ" == "$LatIndex" ]] 
		then
			echo "skip laterality index folder";
	else
	
		cd $SUBJ;
		mkdir Activation_Overlaps
		
		for left_roi in $LROIs; do
		
			fslmaths $ROOTDIR/$SUBJ/${WholeBrainActivation} -mas $ROI_dir/${left_roi} $ROOTDIR/$SUBJ/Activation_Overlaps/masked_z${zthresh}_${left_roi} 
		
		done
		
		for right_roi in $RROIs; do
			
			fslmaths $ROOTDIR/$SUBJ/${WholeBrainActivation} -mas $ROI_dir/${right_roi} $ROOTDIR/$SUBJ/Activation_Overlaps/masked_z${zthresh}_${right_roi}	
		
		done
		
		cd $ROOTDIR;
	fi

done