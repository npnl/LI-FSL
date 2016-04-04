#!/bin/sh

#NPNL Lab
#KLI kaoriito(at)usc.edu 20160331
#This script is for visualizing functional activity within each ROI on a registered anatomical image. 
#This script will create a nifti output of the activation based on chosen thresholds within the ROI regions.
#This script is dependent on having first run Voxel_based_lateralityIndex.sh
#The output of this file is in Path/To/Outputs/$ROI/$subj/ROI_Activation_Maps/ and is either Left-z-threshold.nii.gz or Right-z-threshold.nii.gz
#After running this script, for each subject, use fslview to open Path/To/Inputs/$subj/highres2standard.nii.gz and overlay with the desired outputs 

clear;
cd ~
######################### MAKE CHANGES HERE ##############################

threshSet=( 1.0 1.5 2.3 ) #set the z-values here - these should already have been computed in Voxel_based_LateralityIndex.sh

#SPECIFY ROI DIRECTORY	
#NOTE: All ROIS must be labeled with "R_roiname" or "L_roiname" to indicate whether it's a left ROI or right ROI.
ROIDir=/PATH/TO/ROI/DIRECTORY #Please make sure that your ROI is in the same space as your zstat.nii.gz image! If running in native space, this script can only handle one subject at a time.

#SPECIFY NAME OF LATERALITY OUTPUTS DIRECTORY
OutputDir=/PATH/TO/YOUR/OUTPUT/FOLDER

################DO NOT MAKE CHANGES BEYOND THIS POINT###################


cd $OutputDir/Inputs

SUBJS=`ls -d *`;


cd $OutputDir/Outputs;
bilateralROIS=`ls -d *`;

for bilatROI in $bilateralROIS; do

	#set left and right ROI.
	cd $ROIDir;
	L_ROI=`ls -a $PWD/L_${bilatROI}*`;
	R_ROI=`ls -a $PWD/R_${bilatROI}*`;
	
	
	for subj in $SUBJS; do
	
		cd $OutputDir/Outputs/$bilatROI/$subj; 
		
		mkdir ROI_Activation_Maps;
		
		for THRESH in "${threshSet[@]}"; do
		
			fslmaths $OutputDir/Inputs/$subj/z-"${THRESH}".nii.gz -mas $L_ROI $OutputDir/Outputs/$bilatROI/$subj/ROI_Activation_Maps/Left_z-"${THRESH}"
			fslmaths $OutputDir/Inputs/$subj/z-"${THRESH}".nii.gz -mas $R_ROI $OutputDir/Outputs/$bilatROI/$subj/ROI_Activation_Maps/Right_z-"${THRESH}"
		
		done
		
	done

done

