%%DEAF COGNITION PRE-PROCESSING BATCH CODE September 15 2018
%Modified VC Sept 2019
% Initialise SPM

% this script works for data in the following folder format:
% 
%  mainfolder
%            |___ sub-001
%                 sub-002
%                     .
%                     .
% %                   .
% %                 sub-n 
% %                       |____anat
%                              funct
%                                 |___ run task 1__ fmap
%                                      run task 2__ fmap
%                                            .
%                                            .
%                                            .
%                                      run task n__ fmap
%                                 
% %

%note: one fieldmap (fmap) folder in each functional run folder

%--------------------------------------------------------------------------
clear all;
spm('Defaults','fMRI');
spm_jobman('initcfg');

%spm_get_defaults('cmdline',true);

mainfolder='/Users/b.manini/Documents/MATLAB/Data_CWM';
taskfolders={  'VWM_loc'; 'SWM_loc'; }%  ; 'VWM_loc';'CWM_run_1'; 'CWM_run_2'; 'CWM_run_3'; 'CWM_run_6'; 'CWM_run_7'; 'CWM_run_8'; 'SWM_loc' 'CWM_run_4'; 'CWM_run_5'  ;'SWM_loc' };%'VWM_loc' 'CWM_run_1'; 'CWM_run_2'; 'CWM_run_3'; 'CWM_run_4'; 'CWM_run_5'    }%;'CWM_run_1' %'VWM_loc'; 'V6_loc'; 'SWM_loc'; 'CWM_run_1'; 'CWM_run_2' ;  'CWM_run_3'; 'CWM_run_4' ;  'CWM_run_5' ;
subjs={'207' };%These are letter strings (not numbers). Make sure they are all the same legnth(3 digi   ts)
%n_run={'1';'2';'3';'4';'5';'6';'7';'8'};
%n_run={'2';'3';'4';'5'};
%% PART 1 
%Segmentation and normalization of the anatomica scan. All the functional
%data will be referred and normalized on the common anatomical scan. Do
%this process just once for each subject.
%Comment this loop if you only want to preprocess functional data.
% 
for n=1:size(subjs,1)
   
    
datafolder_anat=strcat(mainfolder,'/sub-',subjs(n,:),'/anat'); %%%% CHANGE TO MATCH THE NAME OF YOUR FOLDER

anat = spm_select('FPList', fullfile(datafolder_anat), '^sP.*\.nii$'); 

c=1;
matlabbatch{c}.spm.spatial.preproc.channel.vols  = cellstr(anat);
matlabbatch{c}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{c}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{c}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{c}.spm.spatial.preproc.tissue(1).tpm = {'/Users/b.manini/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
matlabbatch{c}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{c}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{c}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{c}.spm.spatial.preproc.tissue(2).tpm = {'/Users/b.manini/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
matlabbatch{c}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{c}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{c}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{c}.spm.spatial.preproc.tissue(3).tpm = {'/Users/b.manini/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
matlabbatch{c}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{c}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{c}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{c}.spm.spatial.preproc.tissue(4).tpm = {'/Users/b.manini/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
matlabbatch{c}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{c}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{c}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{c}.spm.spatial.preproc.tissue(5).tpm = {'/Users/b.manini/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
matlabbatch{c}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{c}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{c}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{c}.spm.spatial.preproc.tissue(6).tpm = {'/Users/b.manini/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
matlabbatch{c}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{c}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{c}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{c}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{c}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{c}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{c}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{c}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{c}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{c}.spm.spatial.preproc.warp.write = [0 1];


%biasanat = spm_select('FPList', fullfile(datafolder_anat), '^msP.*\.nii$');

c=c+1;
matlabbatch{c}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(anat,'prefix','y_','ext','nii'));
matlabbatch{c}.spm.spatial.normalise.write.subj.resample = cellstr(anat);
matlabbatch{c}.spm.spatial.normalise.write.woptions.vox  = [1 1 1];
matlabbatch{c}.spm.spatial.normalise.write.woptions.prefix = 'w';


disp(strcat('Running struct preprocessing participant... ',subjs(n,:)))



spm_jobman('run',matlabbatch);
disp(strcat('Done struct preprocessing participant... ',subjs(n,:)))
disp('')

clear matlabbatch anat datafolder_anat
 

end

%% PART 2

% functional data pre-processing 
clear n c

for n=1:size(subjs,1)
     for t=1:size(taskfolders,1)
      

        
         datafolder=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders{t});

        datafolder_anat=strcat(mainfolder,'/sub-',subjs(n,:),'/anat'); %%%% CHANGE TO MATCH THE NAME OF YOUR FOLDER
        
        
        %Please choose the fieldmap temporally closer to the run session!!!!
%         datafolder_fieldmap=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders{t},'/fmap');%CHANGE FOLDER
        
        funct = spm_select('FPList', fullfile(datafolder), '^fP.*\.nii$');
        anat = spm_select('FPList', fullfile(datafolder_anat), '^sP.*\.nii$');
        biasanat = spm_select('FPList', fullfile(datafolder_anat), '^msP.*\.nii$');
        dummy_folder=strcat(datafolder, '/Dummies/')
        first_scan=spm_select('FPList', fullfile(dummy_folder),'01-01.nii$');
        %cans=cellstr(funct);
        
        % Realign
           %--------------------------------------------------------------------------
        matlabbatch{1}.spm.spatial.realign.estwrite.data{1} = cellstr(funct);
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        
%         %Time correction
%         %--------------------------------------------------------------------------
%        
%         matlabbatch{2}.spm.temporal.st.scans{1} = cellstr(spm_file(funct,'prefix','r'));
%         matlabbatch{2}.spm.temporal.st.nslices = 40;
%         matlabbatch{2}.spm.temporal.st.tr = 2.80;
%         matlabbatch{2}.spm.temporal.st.ta = 2.73;
%         matlabbatch{2}.spm.temporal.st.so = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 ]; 
%         matlabbatch{2}.spm.temporal.st.refslice = 20 ;
%         matlabbatch{2}.spm.temporal.st.prefix = 'a';         

        %Coregister
        %--------------------------------------------------------------------------
      
        matlabbatch{2}.spm.spatial.coreg.estimate.ref    = cellstr(biasanat);
        matlabbatch{2}.spm.spatial.coreg.estimate.source = cellstr(spm_file(first_scan));
        matlabbatch{2}.spm.spatial.coreg.estimate.other = cellstr(spm_file(funct,'prefix','r'));
           
        
%         Normalise: Write
%         --------------------------------------------------------------------------
        
        matlabbatch{3}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(anat  ,'prefix','y_','ext','nii'));
        matlabbatch{3}.spm.spatial.normalise.write.subj.resample = cellstr(char(spm_file(funct,'prefix','r')));
        matlabbatch{3}.spm.spatial.normalise.write.woptions.vox  = [2 2 2];
        matlabbatch{3}.spm.spatial.normalise.write.woptions.prefix = 'w';
        
        % Smooth
        %--------------------------------------------------------------------------
       
        matlabbatch{4}.spm.spatial.smooth.data = cellstr(spm_file(funct,'prefix','wr'));
        matlabbatch{4}.spm.spatial.smooth.fwhm = [8 8 8];
        matlabbatch{4}.spm.spatial.smooth.prefix = 's';
        
        disp(strcat('Running funct preprocessing__ ', taskfolders{t}, '   participant... ',subjs(n,:)))
        
         spm_jobman('run',matlabbatch);
        
        clear matlabbatch  datafolder* funct biasanat short* long* wrap_img
        
        disp(strcat('Done funct preprocessing__ ', taskfolders{t}, '  participant... ',subjs(n,:)))
        disp('__')
     end 
end
disp('THE END')