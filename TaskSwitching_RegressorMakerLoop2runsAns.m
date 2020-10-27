%spm_get_defaults('cmdline',true);
clear all;
spm('Defaults','fMRI');
spm_jobman('initcfg');


mainfolder='/Users/b.manini/Documents/MATLAB/Data';

taskfolder_TS={'taskswitching'};
taskname={'_TaskSwitching'};
%taskfolders={'taskswitching';'toweroflondon'};

%subjs=['006';'007';'008';'013';'014';'101';'102';'104';'108';'109'];%These are letter strings (not numbers). Make sure they are all the same legnth(3 digits)
subjs={'004';'002'};

for n=1:size(subjs,1)
    
    
   for t=1:size(taskfolder_TS,1)
    
    dir=strcat(mainfolder,'/Lev1st_TaskSwitching/s',subjs(n,:));
    dir1=cell2mat(dir);  
    directory=mkdir(dir1);

    datafolder_TS=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolder_TS, '_run','1');
    datafolder_TS2=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolder_TS, '_run','2');
    regressor_TS_name_1=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/','taskswitching_run1','/sub-',subjs(n,:),'_TaskSwitch','.csv');
    regressor_TS_name_2=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/','taskswitching_run2','/sub-',subjs(n,:),'_TaskSwitch','.csv');
    regressor_TS1=string(regressor_TS_name_1);
    regressor_TS2=string(regressor_TS_name_2);

    data_1=csvread(regressor_TS1);
    t0_1=data_1(1,8);
    data_2=csvread(regressor_TS2);
    t0_2=data_2(1,8);


    %     %stay trials
    % staytrials=find(data(:,2) & data(:,1)==0);
    % onset_stay=data(staytrials,4)-t0;
    % 
    % 
    % %switch trials
    % switchtrials=find(data(:,2) & data(:,1));
    % onset_switch=data(switchtrials,4)-t0;

    %cue stay 1
    staycue1=find(data_1(:,2) & data_1(:,1)==0 );
    onset_sc1=data_1(staycue1,2)-t0_1;
    
    %cue switch
    switchcue1=find(data_1(:,2) & data_1(:,1));
    onset_swc1=data_1(switchcue1,2)-t0_1;
    
    %stay trials left
    stayL1=find( data_1(:,1)==0 & data_1(:,5)==4 & data_1 (:,7) ); 
    onset_stl1_vis=data_1(stayL1,4)-t0_1;
    onset_stl1=onset_stl1_vis+data_1(stayL1,7);
    %stay trials right
    stayR1=find( data_1(:,1)==0 & data_1(:,5)==9 & data_1(:,7));
    onset_str1_vis=data_1(stayR1,4)-t0_1;
    onset_str1=onset_str1_vis+data_1(stayR1,7);
    %switch trials left 1st
    switchtrials1=find( data_1(:,1) & data_1(:,5)==4 & data_1(:,2)& data_1 (:,7));
    onset_swtl_first1_vis=data_1(switchtrials1,4)-t0_1;
    onset_swtl_first1=onset_swtl_first1_vis+data_1(switchtrials1,7);
    clear switchtrials1

    %switch trials left rest
    switchtrials1=find( data_1(:,1) & data_1(:,5)==4 & data_1(:,2)==0 & data_1 (:,7));
    onset_swtl_rest1_vis=data_1(switchtrials1,4)-t0_1;
    onset_swtl_rest1=onset_swtl_rest1_vis+data_1(switchtrials1,7)

    %switch trials right 1st
    switchR1=find( data_1(:,1) & data_1(:,5)==9 & data_1(:,2) & data_1 (:,7));
    onset_swtr_first1_vis=data_1(switchR1,4)-t0_1;
    onset_swtr_first1=onset_swtr_first1_vis+data_1(switchR1,7);
    clear switchR1

    %switch trials right rest
    switchR1=find( data_1(:,1) & data_1(:,5)==9 & data_1(:,2)==0 & data_1 (:,7));
    onset_swtr_rest1_vis=data_1(switchR1,4)-t0_1;
    onset_swtr_rest1=onset_swtr_rest1_vis+data_1(switchR1,7);
    
    %cue stay 2
    staycue2=find(data_2(:,2) & data_2(:,1)==0 & data_2 (:,7));
    onset_sc2=data_2(staycue2,2)-t0_2;

    %cue switch2
    switchcue2=find(data_2(:,2) & data_2(:,1) & data_2 (:,7));
    onset_swc2=data_2(switchcue2,2)-t0_2;

    %stay trials left2
    stayL2=find( data_2(:,1)==0 & data_2(:,5)==4 & data_2 (:,7) ); 
    onset_stl2_vis=data_2(stayL2,4)-t0_2;
    onset_stl2=onset_stl2_vis+data_2(stayL2,7)
    %stay trials right2
    stayR2=find( data_2(:,1)==0 & data_2(:,5)==9 & data_2 (:,7));
    onset_str2_vis=data_2(stayR2,4)-t0_2;
    onset_str2= onset_str2_vis+data_2(stayR2,7);

    %switch trials left 2st2
    switchtrials2=find( data_2(:,1) & data_2(:,5)==4 & data_2(:,2) & data_2 (:,7));
    onset_swtl_first2_vis=data_2(switchtrials2,4)-t0_2;
    onset_swtl_first2=onset_swtl_first2_vis+ data_2(switchtrials2,7);
    clear switchtrials2

    %switch trials left rest
    switchtrials2=find(data_2(:,1) & data_2(:,5)==4 & data_2(:,2)==0);
    onset_swtl_rest2_vis=data_2(switchtrials2,4)-t0_2;
    onset_swtl_rest2= onset_swtl_rest2_vis+data_2(switchtrials2,7);

    %switch trials right 2st
    switchR2=find(data_2(:,1) & data_2(:,5)==9 & data_2(:,2));
    onset_swtr_first2_vis=data_2(switchR2,4)-t0_2;
    onset_swtr_first2=onset_swtr_first2_vis+data_2(switchR2,7);
    clear switchR2

    %switch trials right rest2
    switchR2=find( data_2(:,1) & data_2(:,5)==9 & data_2(:,2)==0);
    onset_swtr_rest2=data_2(switchR2,4)-t0_2;
    onset_swtr_rest2=onset_swtr_rest2+data_2(switchR2,7);

    
    funct_TS1= spm_select ('FPList', datafolder_TS, '^sw.*\.nii$') ;
    motionfile_TS1=spm_select ('FPList', datafolder_TS, '^r.*\.txt$');
    funct_TS2= spm_select ('FPList', datafolder_TS2, '^sw.*\.nii$') ;
    motionfile_TS2=spm_select ('FPList', datafolder_TS2, '^r.*\.txt$');

    matlabbatch{1}.spm.stats.fmri_spec.dir = dir;
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;

    c=1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = cellstr(funct_TS1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).name = 'switch_left';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).onset = onset_swtl_first1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).orth = 1;
    %------switch_right_1
    c=c+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).name = 'switch_right';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).onset = onset_swtr_first1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).orth = 1;
    %-------switch_left_rest
    c=c+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).name = 'switch_left_rest';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).onset = onset_swtl_rest1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).orth = 1;
    %-------switch_right_rest
    c=c+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).name = 'switch_right_rest';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).onset = onset_swtr_rest1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).orth = 1;
    %------stay_left
    c=c+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).name = 'stay_left';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).onset = onset_stl1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).orth = 1;
    %------stay_right
    c=c+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).name = 'stay_right';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).onset = onset_str1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).orth = 1;
    %-------switchcue
    c=c+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).name = 'switchcue';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).onset = onset_swc1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).orth = 1;
    %----staycue
    c=c+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).name = 'staycue';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).onset = onset_sc1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(c).orth = 1;

    %----------motion file

    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {motionfile_TS1};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {'/Users/b.manini/Documents/MATLAB/Data/mask_deaf_cogn.nii'};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
   
    d=1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = cellstr(funct_TS2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).name = 'switch_left';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).onset = onset_swtl_first2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).orth = 1;
    %------switch_right_1
    d=d+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).name = 'switch_right';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).onset = onset_swtr_first2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).orth = 1;
    %-------switch_left_rest
    d=d+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).name = 'switch_left_rest';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).onset = onset_swtl_rest2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).orth = 1;
    %-------switch_right_rest
    d=d+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).name = 'switch_right_rest';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).onset = onset_swtr_rest2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).orth = 1;
    %------stay_left
    d=d+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).name = 'stay_left';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).onset = onset_stl2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).orth = 1;
    %------stay_right
    d=d+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).name = 'stay_right';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).onset = onset_str2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).orth = 1;
    %-------switchcue
    d=d+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).name = 'switchcue';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).onset = onset_swc2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).orth = 1;
    %----staycue
    d=d+1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).name = 'staycue';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).onset = onset_sc2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(d).orth = 1;

    %----------motion file

    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {motionfile_TS2};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
%     matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
%     matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
%     matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
%     matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
%     matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
     matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
%     matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
% 
%     %-----estimate
%    SPMfile=strcat (data_path, '/SPM.mat');
     SPMfile=strcat (dir, '/SPM.mat');
     matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cellstr(SPMfile);
     matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
     matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
     

    %------'Switch cue LR > Stay cue LR'
    matlabbatch{3}.spm.stats.con.spmmat = (SPMfile);
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Switch cue LR > Stay cue LR';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 1 0 0 -1 -1] ;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
    % %---------Switch cue vs stay cue
    % matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Switch cue vs Stay cue';
    % matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 -1];
    % matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    %--------Left > Right
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Left hand > Right hand';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 -1 1 -1 1 -1 ];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
    %------Switch left cue > Stay left cue
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Switch left cue > Stay left cue';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 0 0 0 -1 ];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
    %------Switch Right cue > Stay Right cue
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Switch Right cue > Stay Right cue';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 1 0 0 0 -1 ];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
    %------' Stay cue LR > Switch cue LR'
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Stay cue LR > Switch cue LR';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-1 -1 0 0 1 1 ];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';
    % %---------Switch cue vs stay cue
    % matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Switch cue vs Stay cue';
    % matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 -1];
    % matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    %--------Right > Left 
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Right hand > Left hand';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-1 1 -1 1 -1 1  ];
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'repl';
    %------Stay left cue > Switch left cue 
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Stay left cue > Switch left cue ';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [1 0 0 0 -1 ];
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'repl';
    %------ Stay Right cue vs Switch Right cue
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Stay Right cue > Switch Right cue';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 -1 0 0 0 1 ];
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'repl';
    matlabbatch{3}.spm.stats.con.delete = 0;
    %Switch 1st trial Left Right
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Switch 1st trial Left Right';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [1 1 0 0 0 0 ];
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'repl';
    matlabbatch{3}.spm.stats.con.delete = 0;
    %Stay all trials LR
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Stay all trials LR';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 0 1 1 ];
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'repl';
    matlabbatch{3}.spm.stats.con.delete = 0;
    
    
    
    
    disp(strcat('Running Task Switching first level analysis participant... ',subjs(n,:)))

    spm_jobman('run',matlabbatch);
    disp(strcat('Done Task Switching first level analysis participant... ',subjs(n,:)))
    disp('')

    clear matlabbatch funct1 funct2
       end 
  end


disp('The end')