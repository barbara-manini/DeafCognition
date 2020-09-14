%September 8, 2020
%DEAF COGNITION: WORKING MEMORY TASK
%Barbara Manini
%This script extract the beta values from three bilateral ROIs: Heschl's
%gyrus, Planum Temporale, posterior superior temporal cortex

%STEP 1: Set the directories name
clear all;

%Replace with your Marsbar directory
marsbar_dir='/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/toolbox/marsbar-0.44'; 

%Replace with the directory where the first-level analysis are contained (the script will automatically loop into each participant folder)
mainfolder_Data='/Users/deafneuralplasticitylab/Documents/MATLAB/1-First Level analysis/Lev1st_WM_buttonpressbyhand/';

%Replace with the directory where your ROIs are kept (the script will automatically loop into each participant folder)
mainfolder_ROI='/Users/deafneuralplasticitylab/Documents/MATLAB/Data/ROI_freesurf/'; 

% Start marsbar to make sure spm_get works
marsbar('on')
subjs={ '002';'004'; '006';'007';'008';'011'; '013';'014'; '015'; '016'; '017'; '018';'021';'023';'028';'031';'032';'041'; '042'; '101';'103';'104';'106'; '107';'108'; '110';'111'; '114'; '115'; '116'; '118';'119';'122'; '124';'127'; '129'; '130';'131';'132';'133';'134';'135'; '136'}; 

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
    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(roi_dir,'L_HerschlGyrus_1_roi.mat'));
    L_HG_name = [r.name];
    roinames  = strcat(roi_dir,'/' ,L_HG_name);
    
    %load con file: load the relevant contrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 working memory condition% get images from the contrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ywm = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_wm datavar_wm o_wm] = summary_data(Ywm, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ywm)); %note the regionname   
   
    %load con file control task
    K= dir(fullfile(subjroot ,'con_0006.nii')); % con= 1 0 0 0 control condition % get images from contrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'WorkingMemory_L_HG_roi.mat');
     save(data_file, 'datamean_wm', 'datamean_con','regionname'); %save the data in the given participant' directory
     
     clear subjroot roi_dir r L_HG_name roinames P V D D2 J K H H2 datamean_wm datavar_wm o_wm region_name datamean_con datavar_con o_con Ywm Wcon data_file
    
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

    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the STC ROI
    r = dir(fullfile(roi_dir,'R_HerschlGyrus_1_roi.mat'));
    R_HG_name = [r.name];
    roinames  = strcat(roi_dir,'/' ,R_HG_name);
    
    %load con file
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 working memory condition% get images from the contrast directory where they are stored
    V = spm_vol(P);
%     wm_file  = strcat(subjroot ,'/',wm_name);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ywm = get_marsy(roi_array, D2, 'mean');%get the values
    [datamean_wm datavar_wm o_wm] = summary_data(Ywm, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ywm)); %note the regionname   
 
      %load con file control task
    K= dir(fullfile(subjroot ,'con_0006.nii')); % con= 1 0 0 0 control condition % get images from contrast directory where they are stored
    J = spm_vol(K);
%   wm_file  = strcat(subjroot ,'/',wm_name);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values
    
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    %regionname = char(region_name(Y)); %note the regionname   
      
     data_file= fullfile (roi_dir,'WorkingMemory_R_HG_roi.mat');
     save(data_file, 'datamean_wm', 'datamean_con','regionname'); %save the data in the given participant' directory
     
     clear subjroot roi_dir r R_HG_name roinames P V D D2 J K H H2 datamean_wm datavar_wm o_wm region_name datamean_con datavar_con o_con Ywm Wcon data_file
    
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
    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(roi_dir,'PTwithoutSTC_roi.mat')); %Left PT from where the voxel overlapping with pSTC were removed
    L_PT_name = [r.name];
    roinames  = strcat(roi_dir,'/' ,L_PT_name);
    
    %load con file: load the relevant contrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 working memory condition% get images from the contrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ywm = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_wm datavar_wm o_wm] = summary_data(Ywm, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ywm)); %note the regionname   
   
    %load con file control task
    K= dir(fullfile(subjroot ,'con_0006.nii')); % con= 1 0 0 0 control condition % get images from contrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'WorkingMemory_L_PT_roi.mat');
     save(data_file, 'datamean_wm', 'datamean_con','regionname'); %save the data in the given participant' directory
     
     clear subjroot roi_dir r L_PT_name roinames P V D D2 J K H H2 datamean_wm datavar_wm o_wm region_name datamean_con datavar_con o_con Ywm Wcon data_file
    
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
    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(roi_dir,'R_Planum_Temporale_1_roi.mat')); %Right PT 
    R_PT_name = [r.name];
    roinames  = strcat(roi_dir,'/' ,R_PT_name);
    
    %load con file: load the relevant contrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 working memory condition% get images from the contrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ywm = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_wm datavar_wm o_wm] = summary_data(Ywm, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ywm)); %note the regionname   
   
    %load con file control task
    K= dir(fullfile(subjroot ,'con_0006.nii')); % con= 1 0 0 0 control condition % get images from contrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'WorkingMemory_R_PT_roi.mat'); %save the data in the given participant' directory
     save(data_file, 'datamean_wm', 'datamean_con','regionname'); 
     
     clear subjroot r R_PT_name roinames P V D D2 J K H H2 datamean_wm datavar_wm o_wm region_name datamean_con datavar_con o_con Ywm Wcon data_file
    
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
    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(stc_dir,'L_STC_005conj_-59_-37_10_roi.mat')); %Left STC 
    L_STC_name = [r.name];
    roinames  = strcat(stc_dir,'/' ,L_STC_name);
    
    %load con file: load the relevant contrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 working memory condition% get images from the contrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ywm = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_wm datavar_wm o_wm] = summary_data(Ywm, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ywm)); %note the regionname   
   
    %load con file control task
    K= dir(fullfile(subjroot ,'con_0006.nii')); % con= 1 0 0 0 control condition % get images from contrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'WorkingMemory_L_STC_roi.mat');%save the data in the given participant' directory
     save(data_file, 'datamean_wm', 'datamean_con','regionname'); 
     
     clear subjroot r L_STC_name  stc_dir roinames P V D D2 J K H H2 datamean_wm datavar_wm o_wm region_name datamean_con datavar_con o_con Ywm Wcon data_file
    
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
    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the Left Heschl's gyrus ROI from the subj folder
    r = dir(fullfile(stc_dir,'R_STC_005conj_56_-28_-1_roi.mat')); %Right STC 
    R_STC_name = [r.name];
    roinames  = strcat(stc_dir,'/' ,R_STC_name);
    
    %load con file: load the relevant contrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 working memory condition% get images from the contrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ywm = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_wm datavar_wm o_wm] = summary_data(Ywm, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ywm)); %note the regionname   
   
    %load con file control task
    K= dir(fullfile(subjroot ,'con_0006.nii')); % con= 1 0 0 0 control condition % get images from contrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
     data_file= fullfile (roi_dir,'WorkingMemory_R_STC_roi.mat'); %save the data in the given participant' directory
     save(data_file, 'datamean_wm', 'datamean_con','regionname'); 
     
     clear subjroot roi_dir r R_STC_name roinames P V D D2 J K H H2 datamean_wm datavar_wm o_wm region_name datamean_con datavar_con o_con Ywm Wcon data_file
    
end 

%% STEP 8: Put the data togheter in a common matrix 
% Working Memory  (stimulus onset)

subjs={ '002';'004'; '006';'007';'008';'011'; '013';'014'; '015'; '016'; '017'; '018';'021';'023';'028';'031';'032';'041'; '042'; '101';'103';'104';'106'; '107';'108'; '110';'111'; '114'; '115'; '116'; '118';'119';'122'; '124';'127'; '129'; '130';'131';'132';'133';'134';'135'; '136'}; 

folder_ROI= '/Users/deafneuralplasticitylab/Documents/MATLAB/Data/ROI_freesurf/'; %replace this directory with the directory where your data will be stored

data_file= {'WorkingMemory_L_HG_roi.mat'; 'WorkingMemory_R_HG_roi.mat'; 'WorkingMemory_L_PT_roi.mat'; 'WorkingMemory_R_PT_roi.mat'; 'WorkingMemory_L_STC_roi.mat'; 'WorkingMemory_R_STC_roi.mat' }

datamean_wm_vector=zeros(6,length(subjs));
datamean_con_vector=zeros(6,length(subjs));


%roi1= strcat(folder_ROI, subjs {n}, data_file{1})

for n=1:size(subjs,1)
    for s=1:size(data_file,1)
      
       roi1= strcat(folder_ROI, 'sub-', subjs {n} ,'/', data_file{s});
       load (roi1);
       datamean_wm_vector (s,n) = datamean_wm;
       datamean_con_vector (s,n) = datamean_con;
       
       
    end
    
end 

filename = 'WorkingMemory_ROIdata.xlsx';

datamean_wm_vector=(datamean_wm_vector.');
datamean_wm_table=array2table(datamean_wm_vector);

datamean_con_vector=(datamean_con_vector.');
datamean_con_table=array2table(datamean_con_vector);

writetable(datamean_wm_table,filename,'Sheet',1,'Range','A1:F44')%range changes on the base of N subjs
writetable(datamean_con_table,filename,'Sheet',1,'Range','G1:L44')

%LIST OF ROI
%datamean_wm_vector1: Left Heschl's gyrus
%datamean_wm_vector2: Right Heschl's gyrus
%datamean_wm_vector3: Left planum temporale
%datamean_wm_vector4: Right planum temporale
%datamean_wm_vector5: Left superior temporal cortex
%datamean_wm_vector6: Right superior temporal cortex


%datamean_con_vector1: Left Heschl's gyrus
%datamean_con_vector2: Right Heschl's gyrus
%datamean_con_vector3: Left planum temporale
%datamean_con_vector4: Right planum temporale
%datamean_con_vector5: Left superior temporal cortex
%datamean_con_vector6: Right superior temporal cortex