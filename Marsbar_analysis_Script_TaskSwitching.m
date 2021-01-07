%September 8, 2020
%DEAF COGNITION: Task Switching
%Barbara Manini
%This script extract the beta values from three bilateral ROIs: Heschl's
%gyrus, Planum Temporale, posterior superior temporal cortex

%STEP 1: Set the directories name
clear all;

%Replace with your Marsbar directory
marsbar_dir='/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/toolbox/marsbar-0.44'; 

%Replace with the directory where the first-level analysis are stored (the script will automatically loop into each participant folder)
mainfolder_Data='/Users/deafneuralplasticitylab/Documents/MATLAB/1-First Level analysis/Lev1st_TaskSwitching/';

%Replace with the directory where your ROIs are kept (the script will automatically loop into each participant folder)
mainfolder_ROI='/Users/deafneuralplasticitylab/Desktop/Temporal_ROIs/'; 

% Start marsbar to make sure spm_get works
marsbar('on')
%IMPORTANT: We use a separate script for participant 002 and 004. Run them
%first and then run this script
subjs={ '003'; '006';'007';'008';'011'; '013';'014'; '015'; '016'; '017'; '018';'021';'023';'028';'031';'032';'041'; '042'; '101';'104';'106'; '107';'108'; '110';'111';'114'; '115'; '116'; '118';'119';'122'; '124';'127'; '129';'130';'131';'132';'133';'134';'135';'136'}; 

% MarsBaR version check
if isempty(which('marsbar'))
  error('Need MarsBaR on the path');
end
v = str2num(marsbar('ver'));
if v < 0.35
  error('Batch script only works for MarsBaR >= 0.35');
end
marsbar('on');  % needed to set paths etc


%% STEP 2: Left HG
for n=1:size(subjs,1)

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory from where the ROIs are loaded and where the data
    %are stored
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:));
     roi_dir  = char(roi_dir );     
  
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');
    % Subdirectory for restfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(roi_dir,'L_HeschlGyrus_1_roi.mat'));
    L_HG_name = [r.name];
    roinames  = strcat(roi_dir,'/' ,L_HG_name);
    
    %load st file: load the relevant sttrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0009.nii')); %  contrast= 1 1 0 0 0 0 switch 1st trial (left and right) get images from the sttrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ysw = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_sw datavar_sw o_sw] = summary_data(Ysw, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ysw)); %note the regionname   
   
    %load st file control  task
    K= dir(fullfile(subjroot ,'con_0013.nii')); % %  contrast= 0 0 0 0 1 1 stay all trials(left and right) % get images from sttrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Yst = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_st datavar_st o_st] = summary_data(Yst, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'TaskSwitching_L_HG_roi.mat');
     save(data_file, 'datamean_sw', 'datamean_st','regionname'); %save the data in the given participant' directory
     
     clear subjroot roi_dir r L_HG_name roinames P V D D2 J K H H2 datamean_sw datavar_sw o_sw region_name datamean_st datavar_st o_st Ysw Wst data_file
    
end 

%% STEP 3: Right HG
for n=1:size(subjs,1)

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:));
     roi_dir  = char(roi_dir);     
  
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');

    % Subdirectory for restfigured design
    mars_sdir = 'Mars_ana';
      
    % select the STC ROI
    r = dir(fullfile(roi_dir,'R_HeschlGyrus_1_roi.mat'));
    R_HG_name = [r.name];
    roinames  = strcat(roi_dir,'/' ,R_HG_name);
    
    %load st file
    P= dir(fullfile(subjroot ,'con_0009.nii')); %  contrast= 1 1 0 0 0 0 switch 1st trial (left and right) condition% get images from the sttrast directory where they are stored
    V = spm_vol(P);
%     sw_file  = strcat(subjroot ,'/',sw_name);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ysw = get_marsy(roi_array, D2, 'mean');%get the values
    [datamean_sw datavar_sw o_sw] = summary_data(Ysw, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ysw)); %note the regionname   
 
      %load st file control  task
    K= dir(fullfile(subjroot ,'con_0013.nii'));% %  contrast= 0 0 0 0 1 1 stay all trials(left and right) % get images from sttrast directory where they are stored
    J = spm_vol(K);
%   sw_file  = strcat(subjroot ,'/',sw_name);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Yst = get_marsy(roi_array, H2, 'mean');%get the values
    
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_st datavar_st o_st] = summary_data(Yst, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    %regionname = char(region_name(Y)); %note the regionname   
      
     data_file= fullfile (roi_dir,'TaskSwitching_R_HG_roi.mat');
     save(data_file, 'datamean_sw', 'datamean_st','regionname'); %save the data in the given participant' directory
     
     clear subjroot roi_dir r R_HG_name roinames P V D D2 J K H H2 datamean_sw datavar_sw o_sw region_name datamean_st datavar_st o_st Ysw Wst data_file
    
end 
%% STEP 4: Left PT
for n=1:size(subjs,1)

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory from where the ROIs are loaded and where the data
    %are stored
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:));
     roi_dir  = char(roi_dir );     
  
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');
    % Subdirectory for restfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(roi_dir,'L_PTwithoutSTC_roi.mat')); %Left PT from where the voxel overlapping with pSTC were removed
    L_PT_name = [r.name];
    roinames  = strcat(roi_dir,'/' ,L_PT_name);
    
    %load st file: load the relevant sttrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0009.nii')); %  contrast= 1 1 0 0 0 0 switch 1st trial (left and right) condition% get images from the sttrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ysw = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_sw datavar_sw o_sw] = summary_data(Ysw, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ysw)); %note the regionname   
   
    %load st file control  task
    K= dir(fullfile(subjroot ,'con_0013.nii')); %  contrast=  0 0 0 0 1 1 stay all trials(left and right) % get images from sttrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Yst = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_st datavar_st o_st] = summary_data(Yst, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'TaskSwitching_L_PT_roi.mat');
     save(data_file, 'datamean_sw', 'datamean_st','regionname'); %save the data in the given participant' directory
     
     clear subjroot roi_dir r L_PT_name roinames P V D D2 J K H H2 datamean_sw datavar_sw o_sw region_name datamean_st datavar_st o_st Ysw Wst data_file
    
end 
%% STEP 5: Right PT
for n=1:size(subjs,1)

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory from where the ROIs are loaded and where the data
    %are stored
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:));
     roi_dir  = char(roi_dir );     
  
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');
    % Subdirectory for restfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(roi_dir,'R_Planum_Temporale_1_roi.mat')); %Right PT 
    R_PT_name = [r.name];
    roinames  = strcat(roi_dir,'/' ,R_PT_name);
    
    %load st file: load the relevant sttrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0009.nii')); %  contrast= 1 1 0 0 0 0 switch 1st trial (left and right) condition% get images from the sttrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ysw = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_sw datavar_sw o_sw] = summary_data(Ysw, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ysw)); %note the regionname   
   
    %load st file control  task
    K= dir(fullfile(subjroot ,'con_0013.nii')); %   contrast= 0 0 0 0 1 1 stay all trials(left and right) % get images from sttrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Yst = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_st datavar_st o_st] = summary_data(Yst, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'TaskSwitching_R_PT_roi.mat'); %save the data in the given participant' directory
     save(data_file, 'datamean_sw', 'datamean_st','regionname'); 
     
     clear subjroot r R_PT_name roinames P V D D2 J K H H2 datamean_sw datavar_sw o_sw region_name datamean_st datavar_st o_st Ysw Wst data_file  
end 
%% STEP 6: Left pSTC 
%(pSTC ROI use a different ROIs directory, because there is only one ROI for all the participants)
%change it with the folder where you are keeping your STC ROIs

mainfolder_STC= '/Users/deafneuralplasticitylab/Documents/MATLAB/Velia_ROI_contrast_analysis'; 

for n=1:size(subjs,1)

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory from where the ROIs are loaded and where the data
    %are stored
     stc_dir  = strcat(mainfolder_STC);
     stc_dir  = char(stc_dir );     
  
    %roi_dir: Directory from where the ROIs are loaded and where the data
    %are stored
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:));
     roi_dir  = char(roi_dir );   
         
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');
    % Subdirectory for restfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(stc_dir,'L_STC_005conj_-59_-37_10_roi.mat')); %Left STC 
    L_STC_name = [r.name];
    roinames  = strcat(stc_dir,'/' ,L_STC_name);
    
    %load st file: load the relevant sttrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0009.nii')); %  contrast= 1 1 0 0 0 0 switch 1st trial (left and right) condition% get images from the sttrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ysw = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_sw datavar_sw o_sw] = summary_data(Ysw, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ysw)); %note the regionname   
   
    %load st file control  task
    K= dir(fullfile(subjroot ,'con_0013.nii')); %  contrast=  0 0 0 0 1 1 stay all trials(left and right) % get images from sttrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Yst = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_st datavar_st o_st] = summary_data(Yst, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'TaskSwitching_L_STC_roi.mat');%save the data in the given participant' directory
     save(data_file, 'datamean_sw', 'datamean_st','regionname'); 
     
     clear subjroot r L_STC_name  stc_dir roinames P V D D2 J K H H2 datamean_sw datavar_sw o_sw region_name datamean_st datavar_st o_st Ysw Wst data_file
    
end 

%% STEP 7: Right pSTC 
%(pSTC ROI use a different ROIs directory, because there is only one ROI for all the participants)
%change it with the folder where you are keeping your STC ROIs
mainfolder_STC= '/Users/deafneuralplasticitylab/Documents/MATLAB/Velia_ROI_contrast_analysis'; 

for n=1:size(subjs,1)

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory from where the ROIs are loaded and where the data
    %are stored
     stc_dir  = strcat(mainfolder_STC);
     stc_dir  = char(stc_dir ); 
     
    %roi_dir: Directory from where the ROIs are loaded and where the data
    %are stored
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:));
     roi_dir  = char(roi_dir ); 
  
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');
    % Subdirectory for restfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(stc_dir,'R_STC_005conj_56_-28_-1_roi.mat')); %Right STC 
    R_STC_name = [r.name];
    roinames  = strcat(stc_dir,'/' ,R_STC_name);
    
    %load st file: load the relevant sttrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0009.nii')); %  contrast= 1 1 0 0 0 0 switch 1st trial (left and right) condition% get images from the sttrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ysw = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_sw datavar_sw o_sw] = summary_data(Ysw, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ysw)); %note the regionname   
   
    %load st file control  task
    K= dir(fullfile(subjroot ,'con_0013.nii')); % contrast=  0 0 0 0 1 1 stay all trials(left and right) % get images from sttrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Yst = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_st datavar_st o_st] = summary_data(Yst, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'TaskSwitching_R_STC_roi.mat'); %save the data in the given participant' directory
     save(data_file, 'datamean_sw', 'datamean_st','regionname'); 
     
     clear subjroot roi_dir r R_STC_name roinames P V D D2 J K H H2 datamean_sw datavar_sw o_sw region_name datamean_st datavar_st o_st Ysw Wst data_file
    
end 

%% STEP 8: Put the data togheter in a common matrix 

subjs={ '002'; '003';  '004'; '006';'007';'008';'011'; '013';'014'; '015'; '016'; '017'; '018';'021';'023';'028';'031';'032';'041'; '042'; '101';'104';'106'; '107';'108'; '110';'111'; '114';'115'; '116'; '118';'119';'122'; '124';'127'; '129';'130';'131';'132';'133';'134';'135';'136'}; 
 

folder_ROI= '/Users/deafneuralplasticitylab/Documents/MATLAB/Data/ROI_freesurf/'; %replace this directory with the directory where your data will be stored

data_file= {'TaskSwitching_L_HG_roi.mat'; 'TaskSwitching_R_HG_roi.mat'; 'TaskSwitching_L_PT_roi.mat'; 'TaskSwitching_R_PT_roi.mat'; 'TaskSwitching_L_STC_roi.mat'; 'TaskSwitching_R_STC_roi.mat' }

datamean_sw_vector=zeros(6,length(subjs));
datamean_st_vector=zeros(6,length(subjs));


%roi1= strcat(folder_ROI, subjs {n}, data_file{1})

for n=1:size(subjs,1)
    for s=1:size(data_file,1)
      
       roi1= strcat(folder_ROI, 'sub-', subjs {n} ,'/', data_file{s});
       load (roi1);
       datamean_sw_vector (s,n) = datamean_sw;
       datamean_st_vector (s,n) = datamean_st;
       
       
    end
    
end 

filename = 'TaskSwitching_ROIdata.xlsx';

datamean_sw_vector=(datamean_sw_vector.');
datamean_sw_table=array2table(datamean_sw_vector);

datamean_st_vector=(datamean_st_vector.');
datamean_st_table=array2table(datamean_st_vector);

writetable(datamean_sw_table,filename,'Sheet',1,'Range','A1:F41')%range changes on the base of N subjs
writetable(datamean_st_table,filename,'Sheet',1,'Range','G1:L41')

%LIST OF ROI
%datamean_sw_vector1: Left Heschl's gyrus
%datamean_sw_vector2: Right Heschl's gyrus
%datamean_sw_vector3: Left planum temporale
%datamean_sw_vector4: Right planum temporale
%datamean_sw_vector5: Left superior temporal cortex
%datamean_sw_vector6: Right superior temporal cortex


%datamean_st_vector1: Left Heschl's gyrus
%datamean_st_vector2: Right Heschl's gyrus
%datamean_st_vector3: Left planum temporale
%datamean_st_vector4: Right planum temporale
%datamean_st_vector5: Left superior temporal cortex
%datamean_st_vector6: Right superior temporal cortex