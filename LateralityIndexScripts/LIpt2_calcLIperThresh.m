
%Calculate LI
%20151106 KLI
%remember to delete unnecessary textfiles or it will not run
clear;
ROOTDIR='/PATH/TO/DIRECTORY'; %set ROOTDIR
COPE='cope1'; %choose cope folder

zvals = ['2.3'; '1.0'; '1.5'];
zvals = cellstr(zvals);
    
for i=1:length(zvals)
    zthresh = zvals{i};

    cd(fullfile([ROOTDIR '/Laterality_Index/' COPE '/z-' zthresh]))



    files = dir('*.txt'); %remember to delete non-subject textfiles first.
    m=length(files);

    for j=1:m
         textfile = files(j).name;
        disp(textfile);
        fileID = fopen(textfile, 'r');
        %set 'textfile' to curr file name
        formatSpec = '%f';
        valsInfile = fscanf(fileID, formatSpec);
        leftVal = valsInfile(1);
        rightVal = valsInfile(3);
        disp(leftVal);
        disp(rightVal);
        LI = (leftVal - rightVal) / (leftVal + rightVal);
        disp(LI);
        
        fileID = fopen(textfile, 'a');
        fprintf(fileID,formatSpec,LI);
        
        
        fclose(fileID);
        %append onto current textfile as 3rd column
    end

end