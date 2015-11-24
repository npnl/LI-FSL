```
#!/bin/sh

#NPNL Lab
#KLI kaoriito(at)usc.edu 20151030
#Part 3
#after calculating LI values in MATLAB, this will group together all LI values from subjects. 

#####################################
threshSet=2.3; #set the z-value here
ROOTDIR=/PATH/TO/DIRECTORY/Laterality_Index	#this is the directory containing the text with LI values calculated from MATLAB 
ROI_dir=/PATH/TO/ROI/DIRECTORY #this directory contains your ROIs in .nii format

###################################
cd ~
cd $ROI_dir
pwd
LROIs=`ls -a L_*.nii`;
############################

cd $ROOTDIR;
mkdir LI_group;
cd LI_group;
mkdir z-$threshSet; #your output will now be saved to $ROOTDIR/Laterality_Index/LI_group/z-$threshSet

cd $ROOTDIR;

for cope in cope1 cope2; do
		cd $cope/z-$threshSet;
		pwd;
	
		for ROI in $LROIs; do
			String2find=${ROI:2};
			
			totalROIfiles=`ls $String2find*.txt`;
			
			for ROIfile in $totalROIfiles;do 
				sed -n '3p' $ROIfile >> $ROOTDIR/LI_group/z-$threshSet/${String2find}_${cope}.txt; #outputs #LI value into one ROI textfile
			done
		
		
		done
done


```
