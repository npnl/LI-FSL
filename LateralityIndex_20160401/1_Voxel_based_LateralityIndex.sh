#!/bin/sh

#NPNL Lab
#KLI kaoriito(at)usc.edu 20160325
#This script will set the whole-brain zstat image to different z-scores, then extract the number of active Voxels for each ROI and calculate a laterality index

clear;
cd ~
######################### MAKE CHANGES HERE ##############################

threshSet=( 1.0 1.5 2.3 ) #set the z-values here

#SPECIFY YOUR INPUTS
Path2SubjDir=/PATH/TO/SUBJECTS #this is the directory holding your subject data. You may choose whether it's a folder containing subfolders of subjects, or just 1 subject folder. 
SubjID="subj" #CHANGE TO 0 IF RUNNING ONLY ON ONE SUBJECT. Otherwise specify your subject identifier (e.g., 'Subj' if your subject folder is Subj01, Subj02, Subj03, etc.)

Path2ZstatFile=/REST/OF/PATH/TO/zstatX.nii.gz #this should be the REST OF THE PATH to your zstatX.nii.gz file (where the full path is $Path2SubjDir/$SubjID/$Path2ZstatFile ). If your zstat file is in native space, please only run script on one subject at a time, using native space ROIs. 

Path2Anatomicals=/REST/OF/PATH/TO/highres2standard.nii.gz #this is the REST OF THE PATH to your anatomical image; if your zstat.nii.gz image is in standard space, then use the path to highres2standard. 

#SPECIFY ROI DIRECTORY
#NOTE: This will calculate a laterality index for ALL ROIS in the directory. All ROIS must be labeled with "R_roiname" or "L_roiname" to indicate whether it's a left ROI or right ROI.
ROIDir=/FULL/PATH/TO/ROIs #Please make sure that your ROI is in the same space as your zstat.nii.gz image! If running in native space, this script can only handle one subject at a time.

#SPECIFY WHERE YOU WANT YOUR OUTPUT FOLDER
OutputDir=/FULL/PATH/TO/DESIRED/OUTPUT/LOCATION

#SPECIFY OUTPUT DIRECTORY NAME
NameOfOutput='Laterality_COPEXX'; #change the name of the output directory you want

	#FOR EXAMPLE, IF MULTIPLE SUBJECTS:
	#If the full path to the zstat file is /Users/NPNL/Project_Brain/Subjects/SubjXX/lev2/cope1.feat/stats/zstat1.nii.gz, then:
	#Path2SubjDir=/Users/NPNL/Project_Brain/Subjects
	#SubjID='Subj'
	#Path2ZstatFile=/lev2/cope1.feat/stats/zstat1.nii.gz 
	
	#FOR EXAMPLE, IF ONLY A SINGLE SUBJECT:
	#If the full path to the zstat file is /Users/NPNL/Project_Brain/Subjects/Subj04/lev2/cope1.feat/stats/zstat1.nii.gz, then:
	#Path2SubjDir=/Users/NPNL/Project_Brain/Subjects/Subj04
	#SubjID=0
	#Path2ZstatFile=/lev2/cope1.feat/stats/zstat1.nii.gz 
	
	#If the full path to the anatomical is /Users/NPNL/Project_Brain/Subjects/SubjXX/run01.feat/reg/highres2standard.nii.gz, then:
	#Path2Anatomicals=/run01.feat/reg/highres2standard.nii.gz


################ DO NOT MAKE CHANGES BEYOND THIS POINT ###################

############### MAKING SUBJECT ARRAY BASED ON SINGLE OR MULTIPLE SUBJECTS ###################

cd $OutputDir;
mkdir "$NameOfOutput";
cd $OutputDir/$NameOfOutput;
pwd;


#set filepath to subject directory/directories.
if [[ $SubjID == '0' ]]
then 
	AllSubjs=`basename "$Path2SubjDir"`;
	Path2AllSubj=$(dirname $Path2SubjDir);
	echo $AllSubjs;
else
	Path2AllSubj=$Path2SubjDir;
	cd $Path2AllSubj;
	
	AllSubjs=`ls -d ${SubjID}*`;
	echo $AllSubjs;
	
fi

################# SETTING FILEPATHS AND COPYING INPUTS INTO SUBJECT FOLDERS ###############

cd $OutputDir/$NameOfOutput;


mkdir Inputs;
cd $OutputDir/$NameOfOutput/Inputs;

#get all paths to zstat file, stores into an array ($SubjPath_Zstat) starting with 0.
iter=0;

	
for subj in $AllSubjs; do
	
	mkdir $subj;
	
	SubjPath_Zstat[${iter}]=${Path2AllSubj}/${subj}${Path2ZstatFile};
	cp ${SubjPath_Zstat[${iter}]} $OutputDir/$NameOfOutput/Inputs/$subj;
	
	SubjPath_Anat[${iter}]=${Path2AllSubj}/${subj}${Path2Anatomicals};
	cp ${SubjPath_Anat[${iter}]} $OutputDir/$NameOfOutput/Inputs/$subj;
	
	iter=$((iter+1));
done



############### CREATE THRESHOLDED WHOLE BRAIN MAPS ###########################

j=0;
	
for subj in $AllSubjs; do
	echo $subj;
	zStatPath=${SubjPath_Zstat[$j]};
	echo $zStatPath;
	echo j="$j";
	j=$((j+1));
	
	for THRESH in "${threshSet[@]}"; do
		cluster -i $zStatPath --zthresh=$THRESH --othresh=$OutputDir/$NameOfOutput/Inputs/$subj/z-$THRESH.nii.gz
	done


done
 
############################# GET ROIs ###############################
#need to have ROI names in order to loop through roi folders
#store ROIs
cd $ROIDir
pwd
LROIs=`ls -a L_*.nii*`; #this will collect ONLY the left ROIs
RROIs=`ls -a R_*.nii*`;
ALL_ROIs=`ls -a *.nii*`;

######################## MAKE FOLDERS FOR ROIs & GET ACTIVE VOXEL COUNT ############################

cd $OutputDir/$NameOfOutput;

mkdir Outputs;

cd $OutputDir/$NameOfOutput/Outputs;

for roi in $ALL_ROIs; do

	roi_noExtension=${roi%.*};
	roi_fileName=${roi_noExtension:2};
	
	mkdir $roi_fileName; 
	
	cd $OutputDir/$NameOfOutput/Outputs/$roi_fileName;
	

	for subj in $AllSubjs; do
		mkdir $subj;
		cd $OutputDir/$NameOfOutput/Outputs/$roi_fileName/$subj;
	
		for THRESH in "${threshSet[@]}"; do
			mkdir zstat_thresh"${THRESH}";
			echo `$OutputDir/$NameOfOutput/Inputs/$subj/z-$THRESH.nii.gz`
			fslstats $OutputDir/$NameOfOutput/Inputs/$subj/z-$THRESH.nii.gz -k $ROIDir/$roi -V >> $OutputDir/$NameOfOutput/Outputs/"${roi_fileName}"/$subj/zstat_thresh"${THRESH}"/"${roi_noExtension}"_Voxels_z"${THRESH}".txt;
		done
		
		mkdir MeanLI;
		
		cd $OutputDir/$NameOfOutput/Outputs/$roi_fileName;
		
	done
	
	if [[ $SubjID != '0' ]]
	then 
		mkdir GroupedSubjs;
		cd $OutputDir/$NameOfOutput/Outputs/$roi_fileName/GroupedSubjs;

		for THRESH in "${threshSet[@]}"; do
			mkdir zstat_thresh"${THRESH}";
		done
	
		mkdir MeanLI;
	
	fi

	cd $OutputDir/$NameOfOutput/Outputs;

done

################# COMBINE L & R VALS INTO ONE TEXTFILE ###############################


ROIfiles=`ls -d *`;

for roifile in $ROIfiles; do

	cd $OutputDir/$NameOfOutput/Outputs/$roifile;


	for subj in $AllSubjs; do
		
		cd $OutputDir/$NameOfOutput/Outputs/$roifile/$subj;
		
		
		for THRESH in "${threshSet[@]}"; do
			
			cd $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/zstat_thresh"${THRESH}";
			
			filename_R=`ls R_*.txt`;
			filename_L=`ls L_*.txt`;
			
			RightVal=`echo * | head -n1 $filename_R | awk '{print $1;}'`; 
			LeftVal=`echo * | head -n1 $filename_L | awk '{print $1;}'`;
			
			echo left: $LeftVal > $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/zstat_thresh"${THRESH}"/summary.txt;
			echo right: $RightVal >> $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/zstat_thresh"${THRESH}"/summary.txt;
			
			subtractLR=$(($LeftVal - $RightVal));
			addLR=$(($LeftVal + $RightVal));
			
			if [[ $addLR == 0 ]]
			then
				LI="NA";
			
			else
				LI=$(echo "$subtractLR/$addLR" | bc -l);
			fi
		
			
			echo LI: $LI >> $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/zstat_thresh"${THRESH}"/summary.txt; 
			echo $LI >> $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/zstat_thresh"${THRESH}"/Laterality_Index.txt;
			
			#place LI into a grouped folder.
			echo $LI >> $OutputDir/$NameOfOutput/Outputs/$roifile/GroupedSubjs/zstat_thresh"${THRESH}"/Laterality_Index.txt;
			
			#place LI into subject mean folder
			echo $LI >> $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/MeanLI/All_LI.txt;
			
		done
		
		cd $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/MeanLI/
		
		sum=0;
		denominator=0;
		while read LINE; do
			LIval=`echo $LINE`;
			echo 'LI val:' $LIval;
			
			if [[ $LIval == 'NA' ]]
			then
				echo "no active voxels at this threshold"
			else
				sum=$(echo "$LIval+$sum" | bc -l);
				denominator=$((denominator+1));
			fi	
		done < All_LI.txt
		
		echo 'sum is:' $sum;
		echo 'num of thresholds included' $denominator;
		
		averageLI=$(echo "$sum/$denominator" | bc -l);
		echo 'average is:' $averageLI;
		echo $averageLI > $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/MeanLI/Mean_LI.txt;
		echo $averageLI >> $OutputDir/$NameOfOutput/Outputs/$roifile/$subj/MeanLI/All_LI.txt;
		
		echo $averageLI >> $OutputDir/$NameOfOutput/Outputs/$roifile/GroupedSubjs/MeanLI/Laterality_Index.txt;
			
		
		cd $OutputDir/$NameOfOutput/Outputs/$roifile;
	
	done

done

################### END OF SCRIPT #######################################

