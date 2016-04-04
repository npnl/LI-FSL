NPNL 2016
LATERALITY INDEX CALCULATOR IN FSL
kaoriito@usc.edu

-------------------------------------------

Voxel_based_LateralityIndex.sh calculates the averaged laterality index value across a range of thresholds (default is z=2.3, 1.5, and 1.0)

REQUIRED INPUTS (for each subject, or for one subject):
- zstat nifti file from your Feat output
- anatomical file (registered image if for multiple subjects (e.g., highres2standard), or native space for single subject)
- ROIs (standard space for multiple subjects, native space for single subject).



SCRIPT OUTPUTS: 
/Inputs/Subj/
- zstatX.nii.gz the input used was copied into this file
- z-X.nii.gz this is the whole brain activity map thresholded at X
- highres2standard.nii.gz (or your T1 anatomical)

/Outputs/ROI/Subj/MeanLI
- All_LI.txt contains all of the laterality index values at each threshold, for this subject and the last value is the average LI value.
- Mean_LI.txt only holds the averaged laterality index value (this should be the same as the last line in your All_LI.txt file)

/Outputs/ROI/Subj/zstat_threshX
- L_ROI_Voxels_zX.txt / R_ROI_Voxels_zX.txt this is the output from fslstats -V which is the number of active voxels within this ROI at this threshold. 
- Laterality_Index.txt is the laterality index at this threshold.
- summary.txt is a summary file of these outputs.

FOR MULTIPLE SUBJECTS ONLY:
/Outputs/ROI/GroupedSubjs/MeanLI
- Laterality_Index.txt contains the mean laterality indices for all subjects in order.
/Outputs/ROI/GroupedSubjs/zstat_threshX
- Laterality_Index.txt contains the laterality index for all subjects in order thresholded at X. 

