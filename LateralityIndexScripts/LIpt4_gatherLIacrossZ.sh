#!/bin/sh

#NPNL Lab
#KLI kaoriito(at)usc.edu
#reorganizes LI files to calc mean LI from z-scores. 

#########
cd ~
ROOTDIR=/PATH/TO/DIRECTORY
zthresh=2.3 #set a value that you have used for calculating the threshold. (Can be any of previous ones)

#########DO NOT MAKE CHANGES BEYOND THIS POINT #############


cd $ROOTDIR;

SUBJS=`ls -d *`;ø

cd $ROOTDIR/Laterality_Index;	
mkdir subjLI;

cd $ROOTDIR/Laterality_Index/LI_group/z-$zthresh;

numTxtFiles=`ls -a *cope*.txt`;
LatIndex="Laterality_Index";
i=1;

for TxtFile in $numTxtFiles; do	
	numLines=`wc -l < $TxtFile`; #this gets the number of lines in the textfile
	echo "num of lines:" $numLines
	j=1;	
	for SUBJ in $SUBJS; do
		echo $SUBJ;
		if [[ "$SUBJ" == "$LatIndex" ]] 
		then
			echo "skip laterality index folder";

		else

			sed -n "${j}p" $ROOTDIR/Laterality_Index/LI_group/z-1.0/$TxtFile > $ROOTDIR/Laterality_Index/subjLI/${TxtFile}_${SUBJ}.txt; 
			sed -n "${j}p" $ROOTDIR/Laterality_Index/LI_group/z-1.5/$TxtFile >> $ROOTDIR/Laterality_Index/subjLI/${TxtFile}_${SUBJ}.txt; 
			sed -n "${j}p" $ROOTDIR/Laterality_Index/LI_group/z-2.3/$TxtFile >> $ROOTDIR/Laterality_Index/subjLI/${TxtFile}_${SUBJ}.txt; 		
			j=$((j+1));
	
		fi

done
done