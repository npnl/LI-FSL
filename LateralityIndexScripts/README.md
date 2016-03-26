20160324
NPNL USC
kaoriito(at)usc.edu

This series of scripts is used for the purpose of calculating the average Laterality Index 
from a range of thresholds for stroke populations. For more, please refer to Ito & Liew (submitted).

The LI calculator package consists of 7 scripts (5 bash, 2 matlab). Parts 1-3 are used to 
calculate the laterality index at different thresholds; parts 3-6 takes the laterality indices calculated in parts 1-3 and averages across them.
The script 'VisualizeActivity.sh' has been added to help visualize for any overlap between activity in the region of interest and the lesioned brain area.

#########################

For this script to work, your files MUST be in the following format:

Subjects/SubjXX/run01.feat
Subjects/SubjXX/lev2
The Subjects folder will be your primary root directory, and should ONLY contain folders holding subject data. 

Individual subject folders should contain a level 2 feat folder as well as at least one level 1 feat folder (run01.feat).

#########################

Part 1: Getting the active voxels in the region of interest. (LIpt1_getActiveVoxels.sh)

This is a BASH script.

You can set the z-values you want to use as your thresholds here. The defaults are 1.0, 1.5, and 2.3.

Change /PATH/TO/DIRECTORY for ROOTDIR to the directory where all of your subject data is located.

Change ROI_dir to the directory where your ROIs are contained. Your ROIs should be begin with either L_ or R_ for left or right (e.g., L_IFGop.nii.gz)

Change NameofLev2Folder to the name of the directory for your level 2 folders (e.g., level_2). This should not be the entire path; just the name of the file.

Run part 1

#########################

Part 2: calculating the laterality index in matlab (LIpt2_calcLIperThresh.m)

This is a MATLAB script.

Change the ROOTDIR to the directory where all of your subject data is located. This should be the same path you used for ROOTDIR in part 1. 

If you have more than one COPE, then you may want to run this portion of the script multiple times for each COPE. If so, please change cope1 to the corresponding COPE folder.

If you changed the z-values from the defaults in part 1 of the script, please make corresponding changes to zvals. 

Run part 2

##########################

Part 3: grouping the laterality indices together by each group (LIpt3_groupLI.sh)

This is a BASH script.

Change ROOTDIR and ROI_dir to the directory containing your subject data and your ROIs, respectively.

Run part 3

###########################

Part 4: grouping laterality indices together by subject (LIpt4_gatherLIacrossZ.sh)

This is a BASH script.

change ROOTDIR, and set the zthresh to any of the values you chose earlier (default is 2.3). No changes must be made to zthresh if you did not change default settings.

Run part 4

###########################

Part 5: calculate a mean Laterality Index (LIpt5_calcMeanLI.m)

This is a MATLAB script.

change ROOTDIR to folder containing all of your subjects

Run part 5

###########################

Part 6: group together the mean laterality index. (LIpt6_gpMeanLI.sh)

This is a BASH script. 

change ROOTDIR and ROI_dir to your respective files. 
Set copes to the copes you want to choose.

Run part 6.

##########################

Visualizing Activity (VisualizeActivity.sh)

This is a BASH script.

change ROOTDIR and ROI_dir.
Set the theshold you want to use for the whole-brain activity (default is 1.5).

Run this script, then overlay the output onto the subject anatomical registered to standard space. 
