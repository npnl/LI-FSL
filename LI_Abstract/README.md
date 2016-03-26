---
event: '2015 Brainhack Americas (LA)'

title:  'Calculating the Laterality Index Using FSL for Stroke Neuroimaging Data'

author:

- initials: KLI
  surname: Ito
  firstname: Kaori L.
  email: kaoriito@usc.edu
  affiliation: aff1
- initials: SLL
  surname: Liew
  firstname: Sook-Lei 
  email: sliew@chan.usc.edu
  affiliation: aff1
  corref: aff1

affiliations: 

- id: aff1
  orgname: 'Neural Plasticity and Neurorehabilitation Laboratory, Chan Division of Occupational Science and Occupational Therapy, Division of Biokinesiology and Physical Therapy, Keck School of Medicine Department of Neurology, University of Southern California'
  street: 1540 Alcazar Street, CHP 133 MC 9003
  postcode: 90089
  city: Los Angeles
  state: California
  country: USA

url: http://github.com/npnl/LI_FSL

coi: None

acknow: The authors would like to thank the organizers and attendees of Brainhack LA and the developers of FSL.

contrib: KLI and SLL wrote the software,  performed tests, and wrote the report.
  
bibliography: brainhack-report

gigascience-ref: REFXXX
...

#Introduction
The laterality index (LI) is one way to assess hemispheric dominance in a variety of tasks, such as language, cognitive functions, and changes in laterality in clinical populations, such as after stroke. In stroke neuroimaging, however, an optimal method of calculating the LI remains controversial, largely due to lesion variability in post-stroke brains.
	
Two main methods of calculating LI have evolved in neuroimaging literature \cite{Jansen2006}. The first, more traditional approach counts the number of active voxels in a given region of interest (ROI) for each hemisphere. This method has been criticized for its inability to account for differences in signal intensity. Hence, a second approach calculates laterality based on the percent signal change within a given region; however, this method also has problems, such as difficulty handling negative values. 
	
A laterality toolbox that addresses some of these issues has been implemented in the statistical neuroimaging analysis package SPM, which provides users with options of using either method, along with more advanced statistical tests for robust LI calculations \cite{Wilke2007}. No such toolbox is yet available for FSL. Therefore, we developed a series of scripts to calculate LI in FSL using both voxel count and percent signal change methods. However, in the interest of space, here we present only results from the more robust method of the two (voxel count method).

#Approach
We used fMRI data from two groups of stroke participants who either had right or left hemisphere lesions. Participants observed videos of right or left hand actions, and resulting statistical maps were calculated for each individual. The LI was then calculated per participant, based on the number of active voxels within a given anatomically-defined ROI (the inferior frontal gyrus, pars opercularis). Using the “cluster” tool in FSL, we set a threshold on the second-level whole-brain map. We set a range of z-values (z=1.0, z=1.5, z=2.3) to test the effects of different thresholds. We then utilized “fslstats” to determine the total number of active voxels in both left and right hemisphere ROIs. Finally, we calculated LI based on the equation:

    LI=(L-R)/(L+R)

where *L* represents the number of active voxels in the left-hemisphere ROI and *R* is the number of active voxels in the right-hemisphere ROI. This yields a value for LI such that -1 < *LI* < +1, where a positive value indicates left-hemisphere dominance and a negative value indicates right-hemisphere dominance. 

\begin{table*}[t!]
\caption{\label{stattable} Laterality Index Using a Voxel-Count-based Method in FSL: A Comparison Across Different Stroke Lesion Profiles and Different Thresholds}
\begin{tabular}{l l l l l l l l}
 \hline\noalign{\smallskip}
                         &            & \multicolumn{3}{c}{Subcortical Lesion} & \multicolumn{3}{c}{Cortical Lesion} \\
  Side of Stroke Lesion  & Z-score    & LH         & RH           & LI         & LH         & RH           & LI      \\
   \hline\noalign{\smallskip}
                         & 1          & 272        & 284          & -0.022     & 382        & 22           & 0.891 \\
  Left                   & 1.5        & 167        & 217          & -0.130     & 101        & 0            & 1  \\
      					 & 2.3        & 37         & 123          & -0.538     & 1          & 0            & 1  \\         
 \hline  
 \emph{Mean}             &            &            &              & -0.230     &            &              & 0.964 \\
 \noalign{\smallskip}
                         & 1          & 335        & 68           &  0.662     & 509        & 49           & 0.824 \\
  Right                  & 1.5        & 193        & 29           &  0.739     & 318        & 3            & 0.981  \\
      					 & 2.3        & 76         & 1            &  0.974     & 216        & 0            & 1  \\
  \hline
  \emph{Mean}		     &            &            &              &  0.792     &            &              & 0.935 \\  
\end{tabular}
\end{table*}

#Results/Discussion
We examined the variability in LI at different z-value thresholds to look at laterality differences in individuals with cortical versus subcortical stroke as well as the affected hemisphere (R vs. L). The LI values of four representative individuals (see Fig. \ref{fig1}) with the following types of stroke were as follows (see Table 1): subcortical left-hemisphere stroke (mean LI = -0.23; right lateralized), subcortical right-hemisphere stroke (mean LI = 0.79; left lateralized), cortical left-hemisphere stroke (mean LI = 0.96, left lateralized), and cortical right-hemisphere stroke (mean LI = 0.94, left lateralized). These LI results corresponded with our whole brain observations (not included here), in which we examined the laterality of the action observation network in individuals with left versus right hemisphere stroke (Ito, OHBM 2016). Briefly, we show that most individuals show a left-lateralized pattern of activity during action observation, regardless of the lesion location. That is, Both individuals with left-hemisphere stroke and individuals with right-hemisphere stroke tend to activate the left, dominant hemisphere, suggesting a role of hemispheric dominance during recovery after stroke.

\begin{figure}[h!]
  \includegraphics[width=.47\textwidth]{desmxz.jpg}
  \caption{\label{fig1}
  A Comparison Across Different Stroke Lesion Profiles at Maximum Lesion. MRI scans of individuals who sustained A. subcortical left-hemisphere stroke, B. cortical left-hemisphere stroke, C. subcortical right-hemisphere stroke, D. cortical right-hemisphere stroke. }
\end{figure}

\begin{figure}[h!]
  \includegraphics[width=.47\textwidth]{activation_standardSpace.jpg}
  \caption{\label{fig2}
  Overlap Between Activation in ROI and Lesion. Activity in the inferior frontal gyrus, pars opercularis at z=1.5 for individuals who sustained A. subcortical left-hemisphere stroke, B. cortical left-hemisphere stroke, C. subcortical right-hemisphere stroke, D. cortical right-hemisphere stroke. Images were registered to standard space. }
\end{figure}


Importantly, we notice that the voxel count method is highly dependent on the threshold value: as the threshold increases in stringency, the value of the LI increases. With individuals after stroke, higher thresholds may yield 0 active voxels, leading to a potentially skewed LI (LI=1). 

#Conclusions
We suggest that stroke neuroimaging might benefit from calculating an average LI across different thresholds (including more lenient thresholds such as z=1.0), in order to provide a more robust outcome that takes into account threshold dependency. This is especially true for individuals with cortical strokes, where the ROI may overlap with the lesion and yield 0 active voxels. This issue of thresholding, specifically for stroke research, is an interesting question that remains to be addressed further. Future work may also utilize threshold-weighted overlap maps to visualize subject variablility when using different thresholds to calculate a laterality index \cite{Seghier2016}. Our scripts for these calculations may be found online at <https://github.com/npnl/LI-FSL>.


