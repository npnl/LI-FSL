```
#!/bin/sh

#NPNL Lab
#KLI kaoriito(at)usc.edu 20151030
#Part 1
#This script will set the whole-brain zstat image to different z-scores, then extract the number of active Voxels for each #roi

#####################################
threshSet=2.3; #set the z-value here
ROOTDIR=/PATH/TO/DIRECTORY	#root directory with MRI data; this folder should only contain folders for each subject
ROI_dir=/PATH/TO/ROIs #this directory contains your ROIs in .nii format
LEV2=NameOfLev2Folder #provide name of level 2 folder within each subject directory

###################################
cd ~
cd $ROOTDIR
pwd

SUBJS=`ls -d *`		#Collects all subjects in main folder (takes in any file name; cannot have non-subject data)


mkdir Laterality_Index;
cd Laterality_Index;


for cope in cope1 cope2; do
	mkdir $cope;
	cd $cope;
	mkdir z-$threshSet;
	cd $ROOTDIR/Laterality_Index;
done



#################
#need to have ROI names in order to loop through roi folders
#store ROIs
cd ~
cd $ROI_dir
pwd
ROIs=`ls -a *.nii`; #this will collect the names of all files with .nii so only include ROIs to be used in this folder. Make sure ROIs are labeled with L-ROIname.nii and R-ROIname.nii
LROIs=`ls -a L_*.nii`; #this will collect ONLY the left ROIs
RROIs=`ls -a R_*.nii`;

echo $ROIs;
cd ~
cd $ROOTDIR
pwd

#################set the whole-brain zstat image to different z-scores, then extract the number of active Voxels for each ROI and outputs into each subject's folder with separate L-ROI and R-ROI textfiles

for SUB in $SUBJS; do
	cd $ROOTDIR/$SUB #goes through each subject directory and makes a Laterality Index folder with a separate z-value folder
	mkdir Laterality_Index;
	cd Laterality_Index;
	mkdir z-$threshSet;
    pwd;

    for ROI in $ROIs; do
		echo "in for loop";
	 	for cope in cope1 cope2; do #set for number of copes you want to calculate LI for
            echo $SUB $ROI $cope;
            cd $ROOTDIR/$SUB/$LEV2/$cope.feat/stats; #this is the path to your stats folder for each COPE in your second level folder at the subject level (combined runs 1, 2 and 3 in our case)
            pwd;
            
            cluster -i zstat1.nii.gz --zthresh=$threshSet -o cluster_index --othresh=zstat1-$threshSet.nii #this sets the threshold and outputs the thresholded image to zstat1-$threshsSet.nii (e.g., zstat1-2.3.nii)            
            fslstats zstat1-$threshSet.nii.gz -k $ROI_dir/$ROI -V >> $ROOTDIR/$SUB/Laterality_Index/z-$threshSet/$ROI-$cope-voxels.txt #this takes the number of active voxels within the ROI and outputs it into a textfile labeled with the ROI name and cope number
            
        done

    done

    cd $ROOTDIR;

done

#################takes the R and L active voxel values frome each subject and reorganizes them for use in a group folder

#loop through all subjects
for SUB in $SUBJS; do

	#get magnitude signal change val from each ROI, Left and Right
	
	cd $SUB/Laterality_Index;
	threshDIRs=`ls -d *`;
	
	for threshDIR in $threshDIRs; do 
		cd $threshDIR;

		for LROI in $LROIs; do
		
			ROI_string2find=${LROI:2};
		
			echo $ROI_string2find;
			
			echo Left ROI;
			echo $LROI;
		
			for cope in cope1 cope2; do
				filename_L=$LROI-$cope-voxels.txt;
			
				for RROI in $RROIs; do
					if [[ "$RROI" =~ "$ROI_string2find" ]] #if LROI matches RROI substring then
					then
						echo "found it!"
						filename_R=$RROI-$cope-voxels.txt; #set filename_R to current RROI
					fi
				done	
				echo $filename_R;
				echo $filename_L;
				
				#read vals from filenames
				LeftVal=$(cat "$filename_L");
				RightVal=$(cat "$filename_R");		
				pwd; 
				echo $LeftVal;
				echo $RightVal;
				echo subject $SUB 
				echo $LeftVal > $ROOTDIR/Laterality_Index/$cope/$threshDIR/${ROI_string2find}_$SUB.txt; #in two cope folders
				echo $RightVal >> $ROOTDIR/Laterality_Index/$cope/$threshDIR/${ROI_string2find}_$SUB.txt;
				#output $LeftVal and $RightVal to own txt file
					
		
			done
			
			
		done
		
		cd $ROOTDIR/$SUB/Laterality_Index;
	done
	
	cd $ROOTDIR;
	
done


#####################





```
