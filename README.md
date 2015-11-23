Calculating the Laterality Index Using FSL for Stroke Neuroimaging Data
=====

Kaori L. Ito and Sook-Lei Liew

###Introduction
The laterality index (LI) is one way to assess hemispheric dominance in a variety of tasks, such as language, cognitive functions, and changes in laterality in clinical populations, such as after stroke. In stroke neuroimaging, however, an optimal method of calculating the LI remains controversial, largely due to lesion variability in post-stroke brains.
	
Two main methods of calculating LI have evolved in neuroimaging literature (Seghier, 2008). The first, more traditional approach counts the number of active voxels in a given region of interest (ROI) for each hemisphere. This method has been criticized for its inability to account for differences in signal intensity. Hence, a second approach calculates laterality based on the percent signal change within a given region; however, this method also has problems, such as difficulty handling negative values. 
	
A laterality toolbox that addresses some of these issues has been implemented in the statistical neuroimaging analysis package SPM, which provides users with options of using either method, along with more advanced statistical tests for robust LI calculations (Wilke & Lidzba, 2007). No such toolbox is yet available for FSL. Therefore, we developed a series of scripts to calculate LI in FSL using both voxel count and percent signal change methods. However, in the interest of space, here we present only results from the more robust method of the two (voxel count method).

###Approach
	
We used fMRI data from two groups of stroke participants who either had right or left hemisphere lesions. Participants observed videos of right or left hand actions, and resulting statistical maps were calculated for each individual. The LI was then calculated per participant, based on the number of active voxels within a given anatomically-defined ROI (the inferior frontal gyrus, pars opercularis). Using the “cluster” tool in FSL, we set a threshold on the second-level whole-brain map. We set a range of z-values (z=1.0, z=1.5, z=2.3) to test the effects of different thresholds. We then utilized “fslstats” to determine the total number of active voxels in both left and right hemisphere ROIs. Finally, we calculated LI based on the equation:

    LI=(L-R)/(L+R)

where *L* represents the number of active voxels in the left-hemisphere ROI and *R* is the number of active voxels in the right-hemisphere ROI. This yields a value for LI such that -1 < *LI* < +1, where a positive value indicates left-hemisphere dominance and a negative value indicates right-hemisphere dominance. 

###Results/Discussion
	
We examined the variability in LI at different z-value thresholds to look at laterality differences in individuals with cortical versus subcortical stroke as well as the affected hemisphere (R vs. L). The LI values of four representative individuals with the following types of stroke were as follows (see Table 1): subcortical left-hemisphere stroke (mean LI = -0.23; right lateralized), subcortical right-hemisphere stroke (mean LI = 0.79; left lateralized), cortical left-hemisphere stroke (mean LI = 0.96, left lateralized), and cortical right-hemisphere stroke (mean LI = 0.94, left lateralized). These LI results corresponded with our whole brain observations (not included here).

Importantly, we notice that the voxel count method is highly dependent on the threshold value: as the threshold increases in stringency, the value of the LI increases. With individuals after stroke, higher thresholds may yield 0 active voxels, leading to a potentially skewed LI (LI=1). 

###Conclusions

We suggest that stroke neuroimaging might benefit from calculating an average LI across different thresholds (including more lenient thresholds such as z=1.0), in order to provide a more robust outcome that takes into account threshold dependency. This is especially true for individuals with cortical strokes, where the ROI may overlap with the lesion and yield 0 active voxels. This issue of thresholding, specifically for stroke research, is an interesting question that remains to be addressed further. Our scripts for these calculations may be found online at <http://chan.usc.edu/npnl/resources>.

#####Table 1: Laterality Index Using a Voxel-Count-based Method in FSL: A Comparison Across Different Stroke Lesion Profiles and Different Thresholds

![](http://i66.tinypic.com/11i08ra.jpg)

#####Figure 1: A Comparison Across Different Stroke Lesion Profiles at Maximum Lesion

![](http://i68.tinypic.com/desmxz.jpg)
MRI scans of individuals who sustained A. subcortical left-hemisphere stroke, B. cortical left-hemisphere stroke, C. subcortical right-hemisphere stroke, D. cortical right-hemisphere stroke. 
###References
Seghier, M. L. (2008). Laterality index in functional MRI: methodological issues. Magnetic resonance imaging, 26(5), 594-601.

Wilke, M., & Lidzba, K. (2007). LI-tool: a new toolbox to assess lateralization in functional MR-data. Journal of neuroscience methods, 163(1), 128-136.
