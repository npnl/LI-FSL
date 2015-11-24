```

%NPNL Lab
%KLI kaoriito(at)usc.edu 20151030
%Part 2
%This script takes in the number of active voxels in the right and left hemisphere ROI and then calculates the LI in MATLAB
%This has to be done in matlab since there is no mathematical functions in bash

%%%%%%%%%%%%%%%%%%%%%%%%%%

%remember to delete unnecessary textfiles or it will not run
clear;


ROOTDIR='/PATH/TO/DIRECTORY'; %set ROOTDIR
COPE='cope1'; %choose cope folder
zthresh='2.3'; %choose z-value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(fullfile([ROOTDIR '/Laterality_Index/' COPE '/z-' zthresh])) %change directory to location of textfiles from pt1

files = dir('*.txt'); %remember to delete non-subject textfiles first; this collects all the text files
m=length(files);

for j=1:m %loops through textfiles
    textfile = files(j).name;     %set 'textfile' to curr file name
    disp(textfile);
    fileID = fopen(textfile, 'r'); %this opens the textfile for editing and reading
    formatSpec = '%f';
    valsInfile = fscanf(fileID, formatSpec);
    leftVal = valsInfile(1); %reads in the first value/first line in the textfile (voxels for L-ROI)
    rightVal = valsInfile(2); %reads in the first value/second line in the textfile (voxels for R-ROI)
    disp(leftVal);
    disp(rightVal);
    LI = (leftVal - rightVal) / (leftVal + rightVal);
    disp(LI);

    fileID = fopen(textfile, 'a');
    fprintf(fileID,formatSpec,LI); %this writes in the calculated LI value into the textfile

    fclose(fileID);
end






```
