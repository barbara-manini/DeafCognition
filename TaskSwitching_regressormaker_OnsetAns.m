%spm_get_defaults('cmdline',true);
clear all;
spm('Defaults','fMRI');
spm_jobman('initcfg');


mainfolder='/Users/b.manini/Documents/MATLAB/Data';

taskfolders={'taskswitching'};
taskname={'_TaskSwitch'};
%taskfolders={'taskswitching';'toweroflondon'};'003';
%'006';'007';'008';'011';'013'; '014'; '015'; '017';
% '018';'021';'023';'028';'031';'032';'041'; '042'; '101'; '104'; '106';'107';
% '108'; '110';'111'; '114'; '115'; '116'; '118';'119';'122'; '003';'006';'007';'008';'011';'013';'014';'123';'124';'127'; '129';'130';'131'; '132';
subjs={   '135'};%These are letter strings (not numbers). Make sure they are all the same legnth(3 digits)
%subjs=['006';'007'];

for n=1:size(subjs,1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       

data_path=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders);
regressor_TS_name=strcat(data_path,'/sub-',subjs(n,:),taskname,'.csv');
regressor_TS=string(regressor_TS_name);
data=csvread(regressor_TS);
t0=data(1,8);

%     %stay trials
% staytrials=find(data(:,2) & data(:,1)==0);
% onset_stay=data(staytrials,4)-t0;
% 
% 
% %switch trials
% switchtrials=find(data(:,2) & data(:,1));
% onset_switch=data(switchtrials,4)-t0;

%cue stay
% RTstaycue=find(data(:,7) & data(:,1)==0);
staycue=find(data(:,2) & data(:,1)==0 );
onset_sc=data(staycue,2)-t0;

%cue switch
switchcue=find(data(:,2) & data(:,1)==1);
onset_swc=data(switchcue,2)-t0;

%stay trials left
stayL=find( data(:,1)==0 & data(:,5)==4 & data(:,7)); 
onset_stl_vis=data(stayL,4)-t0;
onset_stl=onset_stl_vis+data(stayL,7);


%stay trials right
stayR=find( data(:,1)==0 & data(:,5)==9 & data(:,7));
onset_str_vis=data(stayR,4)-t0;
onset_str=onset_str_vis+data(stayR,7);

%switch trials left 1st
switchtrials=find( data(:,1)==1 & data(:,5)==4 & data(:,2)& data(:,7));
onset_swtl_first_vis=data(switchtrials,4)-t0;
onset_swtl_first=onset_swtl_first_vis+data(switchtrials,7);
clear switchtrials

%switch trials left rest
switchtrials=find(data(:,1)==1 & data(:,5)==4 & data(:,2)==0 & data(:,7));
onset_swtl_rest_vis=data(switchtrials,4)-t0;
onset_swtl_rest=onset_swtl_rest_vis+data(switchtrials,7);

%switch trials right 1st
switchR=find( data(:,1)==1 & data(:,5)==9 & data(:,2) & data(:,7));
onset_swtr_first_vis=data(switchR,4)-t0;
onset_swtr_first=onset_swtr_first_vis+data(switchR,7);

clear switchR

%switch trials right rest
switchR=find( data(:,1)==1 & data(:,5)==9 & data(:,2)==0 & data(:,7));
onset_swtr_rest_vis=data(switchR,4)-t0;
onset_swtr_rest=onset_swtr_rest_vis+data(switchR,7);

funct= spm_select ('FPList', data_path, '^sw.*\.nii$') ;
motionfile=spm_select ('FPList', data_path, '^r.*\.txt$');


dir=strcat(mainfolder,'/Lev1st_TaskSwitching/s',subjs(n,:));
dir1=cell2mat(dir);  
directory=mkdir(dir1);

matlabbatch{1}.spm.stats.fmri_spec.dir = dir;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(funct);
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;

%----switch_left_1
c=1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = 'switch_left_1';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = onset_swtl_first;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
%------switch_right_1
c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = 'switch_right_1';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = onset_swtr_first;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
%-------switch_left_rest
c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = 'switch_left_rest';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = onset_swtl_rest;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
%-------switch_right_rest
c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = 'switch_right_rest';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = onset_swtr_rest;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
%------stay_left
c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = 'stay_left';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = onset_stl;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
%------stay_right
c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = 'stay_right';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = onset_str;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
%-------switchcue
c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = 'switchcue';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = onset_swc;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
%----staycue
c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = 'staycue';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = onset_sc;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;

%----------motion file

matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {motionfile};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

%-----estimate
SPMfile=strcat (dir, '/SPM.mat');

%SPMfile=strcat (data_path, '/SPM.mat');
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cellstr(SPMfile);
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


%------'Switch cue LR > Stay cue LR'
matlabbatch{3}.spm.stats.con.spmmat = (SPMfile);
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Switch first trial LR > Stay LR';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 1 0 0 -1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% %---------Switch cue vs stay cue
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Switch cue vs Stay cue';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 -1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%--------Left > Right
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Left hand > Right hand';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 -1 1 -1 1 -1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%------Switch left cue > Stay left cue
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Switch left first trial > Stay left ';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 0 0 0 -1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
%------Switch Right cue > Stay Right cue
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Switch Right first trial > Stay Right ';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 1 0 0 0 -1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
%------' Stay cue LR > Switch cue LR'
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Stay LR > Switch first trial LR';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-1 -1 0 0 1 1];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
% %---------Switch cue vs stay cue
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Switch cue vs Stay cue';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 -1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%--------Right > Left 
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Right hand > Left hand';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-1 1 -1 1 -1 1];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
%------Stay left cue > Switch left cue 
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Stay left  > Switch left first trial ';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [-1 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
%------ Stay Right cue vs Switch Right cue
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Stay Right > Switch Right first trial ';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 -1 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.spmmat = (SPMfile);
matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Switch first trial LR ';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [1 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
% %---------Switch cue vs stay cue
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Switch cue vs Stay cue';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 -1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%--------Left > Right
matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Left hand';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [1 0 1 0 1 0];
matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
%------Switch left cue > Stay left cue
matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Switch left first trial';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
%------Switch Right cue > Stay Right cue
matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Switch Right first trial';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = [0 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
%------' Stay cue LR > Switch cue LR'
matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'Stay LR ';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 1 1];
matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
% %---------Switch cue vs stay cue
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Switch cue vs Stay cue';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 -1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%--------Right > Left 
matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 'Right hand ';
matlabbatch{3}.spm.stats.con.consess{14}.tcon.weights = [0 1 0 1 0 1];
matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
%------Stay left cue > Switch left cue 
matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 'Stay left  ';
matlabbatch{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
%------ Stay Right cue vs Switch Right cue
matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 'Stay Right  ';
matlabbatch{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';



matlabbatch{3}.spm.stats.con.delete = 0;
disp(strcat('Running Task Switching first level analysis participant... ',subjs(n,:)))

spm_jobman('run',matlabbatch);
disp(strcat('Done Task Switching first level analysis participant... ',subjs(n,:)))
disp('')

%clear matlabbatch funct

end


disp('The end')