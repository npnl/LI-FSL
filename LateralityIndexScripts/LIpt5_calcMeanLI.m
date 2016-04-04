%Calculate LI
%npnlusc
%20160324 KLI

%Calculate mean LI

clear;

ROOTDIR='/PATH/TO/DIRECTORY'; %change directory to subjects folder.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(fullfile([ROOTDIR '/Laterality_Index/subjLI']))

files = dir('*.txt');
m=length(files);

for j=1:m
        textfile = files(j).name;
        disp(textfile);
        fileID = fopen(textfile, 'r');
        %set 'textfile' to curr file name
        formatSpec = '%f';
        valsInfile = fscanf(fileID, formatSpec);        
        meanLI= nanmean(valsInfile);
        disp (meanLI);
        
        fileID = fopen(textfile, 'a');
        fprintf(fileID,formatSpec,meanLI);
end