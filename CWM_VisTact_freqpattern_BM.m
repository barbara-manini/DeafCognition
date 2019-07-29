
%___________________________________________________________________
% Script for Crossmodal Visual & Somatosensory Working Memory Experiment
% by V. Cardin July 2019
% CWM_VisTact

% You will need the following custom functions: coordsangle.m,
% counterbal.m, lognormdist.m
% Pretty similar to CWM_freq_pattern, but
% Grating based on PsychToolbox DemoDrift2
% Somatosensory stimulation parameters from L. Tame's VisuoTactileDeaf
% script
% For comments on the parameters of the grating check DemoDrift2 or CWM_freq pattern

% Two sensory modalities: visual and somatosensory

% Two tasks Remember Freq (1 and 11) and Remember pattern (0 and 10)

% The structure PARAMS saves all the parameters used in the experiment
% The structure RESULTS saves all the trial- or run- specific information


% +++++++++++
% Decription of variable all_trials:
%
%     columns are individual trials
%     rows are:
%     1. frequency sample
%     2. pattern sample
%     3. frequency test
%     4. pattern test
%     5. same or different frequency? 0=same
%     6. same or differnt pattern?
%
%     z-dimension has a matrix for each block
%++++++++++

% Grating Parameters:
%
% PARAMS.angle = PARAMS.angle of the grating with respect to the vertical direction.
% PARAMS.vistask.sample_freqs and _test_freqs = Speed of grating in cycles per second.
% f = Frequency of grating in cycles per pixel.
% drawmask = If set to 1, a gaussian aperture is drawn over the grating.
% PARAMS.gratings.size = Visible size of grating in screen pixels.
%
% Screen('Preference', 'SkipSyncTests', 1);


%v3 update: grating was still flickering.
% srcRect changed from
%     %srcRect=[xoffset 0 xoffset + PARAMS.gratings.visiblesize PARAMS.gratings.visiblesize]
%   to
%      srcRect=[xoffset 0 PARAMS.gratings.visiblesize PARAMS.gratings.visiblesize];
%Also changed:
%Screen('DrawTexture', w, gratingtex, srcRect, [], PARAMS.angle);
%Screen('DrawTexture', w, masktex, [0 0 (PARAMS.gratings.visiblesize+p) (PARAMS.gratings.visiblesize+p)], [], PARAMS.angle);



clear all
close all


% Configure random number genesrator
rand('seed',cputime*10000);

try
    %% INPUTS
    
    PARAMS.piezo.connected=0; % is the piezo connected?
    Practice=input('Practice(1) or Test(0)?');
    if ~Practice
        RESULTS.ID=input('Enter participant ID:  ','s');
        RESULTS.script='CWM_VisTact';
        RESULTS.run=input('Run number:  ');
        RESULTS.date=datestr(now,'dd-mm-yyyy HH:MM');
        % Filename for Saving
        RESULTS.fname=strcat(RESULTS.script,'_',RESULTS.ID,'_run',num2str(RESULTS.run),'_',datestr(now,'ddmmyy_HHMMSS'),'.mat'); %file name to save result
        
        PrevRun=input('Frequencies and durations same as previous run?(Yes=1; No=0)');
        
    else
        PrevRun=0;
        RESULTS.fname=strcat('Practice_',datestr(now,'ddmmyy_HHMMSS'),'.mat');
    end
    
    %% CONSTANT GRATING PARAMETERS
    
    PARAMS.gratings.size = 150;% Grating size in pixels:
    PARAMS.gratings.drawmask=1;% By default, we mask the grating by a gaussian transparency mask:
    PARAMS.gratings.f=0.05;% Grating cycles/pixel: By default 0.05 cycles per pixel.
    PARAMS.gratings.angle=30; %PARAMS.gratings.angle for  grating
    
    %% EXPERIMENTAL DESIGN PARAMETERS
    
    % Response recording (comparison between pattern or frequency in sample vs test stimulus)
    KbName('UnifyKeyNames'); %it should make the KbName work in windows?
    PARAMS.KeySame = KbName('RightArrow'); % same
    PARAMS.KeyDiff  = KbName('LeftArrow'); % different
    
    PARAMS.blanks.ITImaxdur=5;%max duration of intertrial interval; it will create a log norm distribution of ITIs... check the script below around line 114
    PARAMS.blanks.ITImindur=3;%min duration of intertrial interval
    
    PARAMS.blanks.ISImaxdur=5;%
    PARAMS.blanks.ISImindur=3;%duration of intertrial interval
    
    PARAMS.vistask.dursample=.5;%in seconds
    PARAMS.vistask.durtest=.5;
    %PARAMS.NoReps=1; %number of repetitions for each type of trial.
    
    blocks=[11 11 10 10 11 1 10 0]; %1= visual remember frequency  0= visual remember pattern 11= tactile remember frequency  10= tactile remember pattern
    
    
    %% PIEZO INITALISATION & PARAMETERS
    
    if PARAMS.piezo.connected
        
        
        %% Inizialization PIEZO
        fprintf(1, 'INITIALIZING PIEZO STIMULATOR...\n');
        
        % Add path for Piezo library
        % addpath(genpath('C:\Luigi\PiezoLibrariesManual\PiezoInit'));             % laptop
        % addpath(genpath('F:\Hardware\PIEZO\PiezoLibrariesManual\PiezoInit'));    % PC office
        addpath(genpath('C:\EXPERIMENTS\PiezoLibrariesManual\PiezoInit'));         % PC big testing room
        % addpath(genpath('C:\Users\ltame\Desktop\PiezoInit'));
        
        loadlibrary stimlib0.dll stimlibrel.h alias stimlib ;
        % Close any DAQ ports open
        openDAQ=daqfind;
        for i=1:length(openDAQ)
            stop(openDAQ(i))
            delete(openDAQ(i));
        end
    end
    
    
    % PARAMS.piezo.stimDuration = stim.length; % original code
    PARAMS.piezo.stimDuration_sample   = 700;
    PARAMS.piezo.stimDuration_test     = 700;
    %PARAMS.piezo.stimDuration_standard = 500;
    PARAMS.piezo.stimFreq              = 50;
    
    PARAMS.piezo.trIn = 0;
    
    pause_sample_test = 3000;
    PARAMS.piezo.intensity = 4050; % max 4096 2049 %% Should be PARAMS.piezo.intensity?
    
    PARAMS.piezo.left_index  = 0;
    PARAMS.piezo.left_middle = 1;
    PARAMS.piezo.left_ring   = 2;
    PARAMS.piezo.left_little = 3;
    %n=0;
    
    
    %% VARIABLE VISUAL GRATING PARAMETERS
    
    PARAMS.vistask.sample_freqs=  [ 3.4 3.4 3.4 3.4 5.3 5.3 5.3 5.3];% Speed of grating in cycles per second: 1 cycle per second by default. (Called cyclespersecond in DrifDemo2)
    
    PARAMS.vistask.test_freqs=[3.4 3.4 2.3 5.3 5.3 5.3 3.4 9];% in proportion of sample -maybe not needed for this in proportion-
    
    PARAMS.vistask.sample_pattern  =[1 1 1 1 2  2 2 2 ]; % type of pattern; number indicates lcoation of matrix in PARAMS.vistask.psmat
    PARAMS.vistask.test_pattern= [1 1 3 4 2 2 5 6];
    
    PARAMS.vistask.anglespat=[141 222 308 52  %angles of the pattern. Each row is a pattern. Enter as many rows as the maximum number specDISPLAY.ified in PARAMS.vistask.sample_pattern
        129 217 321 33  %first two rows will be the sample pattern (1 2)
        149 230 316 60
        133 214 300 44
        137 225 329 41
        121 209 313 52];
    
    
    PARAMS.tacttask.sample_freqs= [24 24 24 24 70 70 70 70 ];% piezo frequency of stimulation
    
    PARAMS.tacttask.test_freqs=   [24 24 16 40 70 70 50 110];%
    
    PARAMS.tacttask.sample_pattern  =[1 1 1 1 2 2 2 2 ]; % type of pattern
    PARAMS.tacttask.test_pattern  =  [1 1 3 4 2 2 4 3];
    
    % each row is a pattern of stimulation
    %each column is one finger: 1.index 2.middle 3. ring 4.little
    PARAMS.tacttask.pins= [ 0 1 1 1 %
        1 1 1 0
        1 0 1 1
        1 1 0 1];
    
    
    visual_trials=counterbal(PARAMS.vistask.sample_freqs,PARAMS.vistask.sample_pattern,PARAMS.vistask.test_freqs,PARAMS.vistask.test_pattern);
    
    visual_trials=  visual_trials(:,randperm(size( visual_trials,2))); % randomize columnss,PARAMS.tacttask.test_pattern);
    
    
    tact_trials=counterbal(PARAMS.tacttask.sample_freqs,PARAMS.tacttask.sample_pattern,PARAMS.tacttask.test_freqs,PARAMS.tacttask.test_pattern);
    
    tact_trials=  tact_trials(:,randperm(size( tact_trials,2))); % randomize columns
    
    if PrevRun
        
        %load previous run
        try
            paramfile=strcat('FreqDurParams_',RESULTS.ID,'_run',num2str(RESULTS.run-1),'.mat');
            load(paramfile)
        catch
            paramfile=input('Enter name of previous parameters file ');
            load(paramfile)
        end
        
        PARAMS.blocks=(prevblocks-1)*-1;
        
    else
        
        PARAMS.blocks=blocks(randperm(length(blocks)));
        prevblocks=PARAMS.blocks;
        vstp=1;
        venp=8;
        tstp=1;
        tenp=8;
        
        for q=1:length(PARAMS.blocks)
            
            if PARAMS.blocks(q)<10
                
                all_trials(:,:,q)=visual_trials(:, vstp:venp);
                vstp=vstp+8;
                venp=venp+8;
            else
                all_trials(:,:,q)=tact_trials(:, tstp:tenp);
                tstp=tstp+8;
                tenp=tenp+8;
            end
            
        end
        
        
        if ~Practice
            paramfile=strcat('FreqDurParams_',RESULTS.ID,'_run',num2str(RESULTS.run),'.mat');
            save(paramfile,'all_trials','prevblocks')
        end
        
    end
    clear venp tenp tstp vstp
    
    %
    if Practice %you can specifcy here the exact values of frequency and duration that you wish to test during the practice
        %
        %         clear all_trials
        %
        %         % practice block 1
        %         all_trials(:,:,1)=[
        %             2  3 2 2 3 3
        %             .65 .65 .9 .9 .9 .65
        %             2 3 2.69 1.48 4.05 2.22
        %             .65 .481 .9 .666 1.214 .877];
        %
        %         % practice block 2
        %         all_trials(:,:,2)=[
        %             2  3  2 2  3  3 %frquency sample
        %             .65 .65 .9 .65  .9  .9 % duration sample
        %             2  3 2.69 1.48 4.05 2.22 %frequency test
        %             .65 .481 .9 .666  1.214 .877];  %duration test
        %
        %
        %
        % PARAMS.blocks=[1 0  ];
    end
    
    all_trials(5,:,:)=all_trials(1,:,:)-all_trials(3,:,:);%calculate if same or different frequency(0=same)
    all_trials(6,:,:)=all_trials(2,:,:)-all_trials(4,:,:); % calculate if same or different length (0=same)
    
    
    
    %% create a lognorm distribution of ITI and ISIs
    
    ITIs=lognormdist(PARAMS.blanks.ITImaxdur,PARAMS.blanks.ITImindur,1000);
    ISIs=lognormdist(PARAMS.blanks.ISImaxdur,PARAMS.blanks.ISImindur,1000);
    
    
    
    %% SCREEN STUFF
    
    for deb=1
        
        % This script calls Psychtoolbox commands available only in OpenGL-based
        % versions of the Psychtoolbox. (So far, the OS X Psychtoolbox is the
        % only OpenGL-base Psychtoolbox.)  The Psychtoolbox command AssertPsychOpenGL will issue
        % an error message if someone tries to execute this script on a computer without
        % an OpenGL Psychtoolbox
        AssertOpenGL;
        
        screens=Screen('Screens');
        DISPLAY.screenNumber=max(screens);
        
        
        DISPLAY.white=WhiteIndex(DISPLAY.screenNumber);
        DISPLAY.black=BlackIndex(DISPLAY.screenNumber);
        DISPLAY.gray=round((DISPLAY.white+DISPLAY.black)/2);
        
        if DISPLAY.gray == DISPLAY.white
            DISPLAY.gray=DISPLAY.white / 2;
        end
        
        DISPLAY.red=[255 125 125];
        
        
        % Contrast DISPLAY.increment range for given DISPLAY.white and DISPLAY.gray values:
        DISPLAY.inc=DISPLAY.white-DISPLAY.gray;
        
        % Open a double buffeDISPLAY.red fullscreen window and set default background
        % color to DISPLAY.gray:
        %[w screenRect]=Screen('OpenWindow',DISPLAY.screenNumber, DISPLAY.gray); %full screen
        [w screenRect]=Screen('OpenWindow',DISPLAY.screenNumber, DISPLAY.gray,[0 0 1500 900]); %uncomment for debugging screen
        
        DISPLAY.rfr=round(FrameRate(w));   %Screen refresh rate
        
        %% Fixation Cross Parameters
        
        % Get the centre coordinate of the window
        [DISPLAY.xCenter, DISPLAY.yCenter] = RectCenter(screenRect);
        
        % Here we set the size of the arms of our fixation cross
        DISPLAY.fixCrossDimPix = 20;
        
        % Enable alpha blending for proper combination of the gaussian aperture
        % with the drifting sine grating:
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        % Setup the text type for the window
        Screen('TextFont', w, 'Arial');
        Screen('TextSize', w, 50);
        
        %%  Calculate parameters of the grating:
        
        
        PARAMS.gratings.texsize=PARAMS.gratings.size / 2;
        
        PARAMS.gratings.p=ceil(1/PARAMS.gratings.f);   % First we compute pixels per cycle, rounded up to full pixels, as we
        % need this to create a grating of proper size below:
        
        PARAMS.gratings.fr=PARAMS.gratings.f*2*pi;   % Also need frequency in radians:
        
        PARAMS.gratings.visiblesize=2*PARAMS.gratings.texsize+1;
        
        x = meshgrid(-PARAMS.gratings.texsize:PARAMS.gratings.texsize + PARAMS.gratings.p, 1);% Create one single static grating image:
        
        grating=DISPLAY.gray + DISPLAY.inc*cos(PARAMS.gratings.fr*x);% Compute actual cosine grating:
        
        gratingtex=Screen('MakeTexture', w, grating); % Store 1-D single row grating in texture:
        
        % Create a single gaussian transparency mask and store it to a texture:
        mask=ones(2*PARAMS.gratings.texsize+1, 2*PARAMS.gratings.texsize+1, 2) * DISPLAY.gray;
        [x,y]=meshgrid(-1*PARAMS.gratings.texsize:1*PARAMS.gratings.texsize,-1*PARAMS.gratings.texsize:1*PARAMS.gratings.texsize);
        mask(:, :, 2)= round(DISPLAY.white * (1 - exp(-((x/(PARAMS.gratings.texsize/2.5)).^2)-((y/(PARAMS.gratings.texsize/2.5)).^2))));
        masktex=Screen('MakeTexture', w, mask);
        
        % Query maximum useable priorityLevel on this system:
        priorityLevel=MaxPriority(w); %
        
        %Priority(priorityLevel);
        
        dstRect=[0 0 PARAMS.gratings.visiblesize PARAMS.gratings.visiblesize];
        dstRect=CenterRect(dstRect, screenRect);
        
        DISPLAY.ifi=Screen('GetFlipInterval', w); % Query duration of one monitor refresh interval:
        
        waitframes = 1;
        
        waitduration = waitframes * DISPLAY.ifi;% Translate frames into seconds for screen update interval:
        
        PARAMS.gratings.p=1/PARAMS.gratings.f;  % pixels/cycle
        
        % Paraemeters for sinusoidal function for changing direction in movement of the grating
        sinStopTime = 6;             % seconds (choose a long, random one, like 3 s, so that it calculates enough points for the grating's movement)
        PARAMS.gratings.t_sin = (0:DISPLAY.ifi:sinStopTime-DISPLAY.ifi)';     % seconds
        
        for ac=1:size(PARAMS.vistask.anglespat,1) %calculates coordinates of the rectangles in which the gratings will be displayed
            PARAMS.vistask.psmat(:,:,ac) = coordsangle(PARAMS.vistask.anglespat(ac,:),2*PARAMS.gratings.visiblesize,DISPLAY.yCenter,DISPLAY.xCenter,PARAMS.gratings.texsize); %pattern sample matrix
        end
        
    end
    
    
    % Draw the fixation cross
    DrawFormattedText(w, 'eye + square: visual frequency', 400, 200, DISPLAY.white);
    DrawFormattedText(w, 'eye + circle: visual pattern', 400, 300, DISPLAY.white);
    DrawFormattedText(w, 'hand + square: tactile frequency', 400, 400, DISPLAY.white);
    DrawFormattedText(w, 'hand + circle: tactile pattern', 400, 500, DISPLAY.white);
    DrawFormattedText(w, 'Press space bar to continue', 400, 600, DISPLAY.white);
    %
    Screen('Flip', w);
    
    
    pause
    Screen('Flip', w);
    
    
    ct=1;% initialise a counter for trials
    cb=1;% initialise a counter for blocks
    RESULTS.T0=GetSecs;
    
    %% EXPERIMENT LOOP STARTS HERE
    if Practice
        RESULTS.OrderBlocks=[ 1 2 ];
    else
        RESULTS.OrderBlocks=randsample(length(PARAMS.blocks),length(PARAMS.blocks))';
    end
    for b= RESULTS.OrderBlocks; % Blocks' loop with info about modality and task
        
        % TASK CUE
        if PARAMS.blocks(b)==1
            imgcue= 'vis_freq' ; %eye and square
        elseif PARAMS.blocks(b)==0 %eye and circle
            imgcue= 'vis_patt' ;
        elseif PARAMS.blocks(b)==10 %hand and square
            imgcue= 'tact_freq' ;
        elseif PARAMS.blocks(b)==11
            imgcue= 'tact_patt' ; %hand and circle
        end
        
        
        for preframes=1:60%
            
            % Draw the fixation cross
            Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.white,[0 0],2);
            
            Screen('Flip', w);       
        end
        
        for TaskCueframes=1:120%
            
            ima=imread(imgcue, 'png');
            Screen('PutImage', w, ima); % put image on screen
            %imageArray=Screen(?GetImage?, windowPtr [,rect] [,bufferName] [,floatprecision=0] [,nrchannels=3])
            %
            %Screen('getImage', w, ima,[0 0],10 ); % put image on screen
            %%%%
            
            Screen('Flip', w);
        end
        
        for preframes=1:60%
            
            % Draw the fixation cross
            Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.white,[0 0],2);
            
            Screen('Flip', w);     
        end
        
        if Practice
            RESULTS.blocktrials(cb,:) = 1:size(all_trials,2);
        else
            RESULTS.blocktrials(cb,:) = randsample(size(all_trials,2),size(all_trials,2))';
        end
        
        
        %loops through trials for each block
        for u=RESULTS.blocktrials(cb,:)
            textfeedback='No Response';
            
            RESULTS.buttonID(ct)=0;% before any response, set the values to 0
            RESULTS.Correct(ct)=0;% before any response, set the values to 0
            
            for preframes=1:(DISPLAY.rfr/2)%
                
                % Draw the fixation cross
                Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                
                Screen('Flip', w);
                
                
            end
            
            
            disp('=====================================')
            disp(['Trial  ',num2str(ct)])
            disp(['Task  ',imgcue])
            disp(['freq sample ',num2str(all_trials(1,u,b))])
            disp(['freq test   ',num2str(all_trials(3,u,b))])
            disp(['pattern sample  ',num2str(all_trials(2,u,b))])
            disp(['pattern test    ',num2str(all_trials(4,u,b))])
            
            RESULTS.task(ct)=PARAMS.blocks(b);
            RESULTS.freqsample(ct)=all_trials(1,u,b);
            RESULTS.pattern_sample(ct)=all_trials(2,u,b);
            RESULTS.freqtest(ct)=all_trials(3,u,b);
            RESULTS.pattern_test(ct)=all_trials(4,u,b);
            RESULTS.ISI(ct)=randsample(ISIs,1);% ISI
            
            
            if PARAMS.blocks(b)<10 %% if the block is a visual block
                
                Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                
                vbl=Screen('Flip', w);                % Perform initial Flip to sync us to the VBL and for getting an initial
                
                % Translate requested speed of the grating (in cycles per second) into
                % a shift value in "pixels per frame" following a
                % sinusoidal function
                sinfunction1 = cos(2*pi*all_trials(1,u,b)*PARAMS.gratings.t_sin)*PARAMS.gratings.p; %
                
                
                
                % Grating will run for vblendtime (duration of grating 1)
                vblendtime = vbl + PARAMS.vistask.dursample;
                
                RESULTS.dursample(ct)=vblendtime-vbl;
                
                
                i=1;
                
                %% Display of sample grating
                RESULTS.SampleStart(ct)=GetSecs-RESULTS.T0;
                
                while vbl < vblendtime
                    %      for bbb=1:60
                    
                    % Shift the grating by "xoffeset" pixels per frame:
                    xoffset = round(sinfunction1(i));% mod(i*shiftperframe*sinfunction(shift_co),p)*sign(sinfunction(shift_co));                % xoffset = mod(round(  abs(i*shiftpe ame*sinfunction(shift_co)) ,p) )*sign(sinfunction(shift_co));
                    
                    
                    i=i+1;
                    
                    % Define shifted srcRect that cuts out the properly shifted rectangular
                    % area from the texture:
                    %srcRect=[xoffset 0 xoffset + PARAMS.gratings.visiblesize PARAMS.gratings.visiblesize]
                    srcRect=[xoffset 0 [PARAMS.gratings.visiblesize + xoffset] PARAMS.gratings.visiblesize];
                    
                    % Draw grating texture, rotated by "PARAMS.gratings.angle"
                    for dt=1:size(PARAMS.vistask.psmat,1)
                        Screen('DrawTexture', w, gratingtex, srcRect, [PARAMS.vistask.psmat(dt,:,all_trials(2,u,b))], PARAMS.gratings.angle);
                        
                    end
                    
                    if PARAMS.gratings.drawmask==1
                        % Draw gaussian mask over grating:
                        for dt=1:size(PARAMS.vistask.psmat,1)
                            Screen('DrawTexture', w, masktex, [0 0 PARAMS.gratings.visiblesize PARAMS.gratings.visiblesize],[PARAMS.vistask.psmat(dt,:,all_trials(2,u,b))], PARAMS.gratings.angle);
                        end
                    end
                    
                    % Draw the fixation dot in white,and set it to the center of our screen
                    Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                    
                    % Flip 'waitframes' monitor refresh intervals after last redraw.
                    vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * DISPLAY.ifi);
                    
                end
                
                RESULTS.SampleEnd(ct)=GetSecs-RESULTS.T0;
                
                clear vblendtime vbl
                
                
                %% ISI
                
                for ISIframes=1:round(RESULTS.ISI(ct)/DISPLAY.ifi)%
                    
                    % Draw the fixation cross
                    Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                    
                    Screen('Flip', w);
                    
                    
                end
                
                %% Display of test grating
                
                vbl=Screen('Flip', w);
                
                
                RESULTS.freqtest(ct)=all_trials(3,u,b);
                
                sinfunction2 = cos(2*pi*all_trials(3,u,b)*PARAMS.gratings.t_sin)*PARAMS.gratings.p; %
                
                
                RESULTS.patterntest(ct)=all_trials(4,u,b);
                
                vblendtime = vbl + PARAMS.vistask.durtest;
                RESULTS.durtest(ct)=vblendtime-vbl;
                i=1;
                
                clear KbCheck %make sure that there is no stored key press
                
                RESULTS.TestStart(ct)=GetSecs-RESULTS.T0;
                
                % Animationloop:
                while vbl < vblendtime
                    
                    xoffset = sinfunction2(i);% mod(i*(shiftperframe2*sinfunction(shift_co)),p);
                    i=i+1;
                    
                    
                    %srcRect=[xoffset 0 xoffset + PARAMS.gratings.visiblesize PARAMS.gratings.visiblesize];
                    srcRect=[xoffset 0 (PARAMS.gratings.visiblesize + xoffset) PARAMS.gratings.visiblesize];
                    
                    % Draw grating texture, rotated by "PARAMS.gratings.angle":
                    for dt=1:size(PARAMS.vistask.psmat,1)
                        Screen('DrawTexture', w, gratingtex, srcRect, [PARAMS.vistask.psmat(dt,:,all_trials(4,u,b))], PARAMS.gratings.angle);
                    end
                    %
                    if PARAMS.gratings.drawmask==1
                        % Draw gaussian mask over grating:
                        for dt=1:size(PARAMS.vistask.psmat,1)
                            Screen('DrawTexture', w, masktex, [0 0 PARAMS.gratings.visiblesize PARAMS.gratings.visiblesize],[PARAMS.vistask.psmat(dt,:,all_trials(4,u,b))], PARAMS.gratings.angle);
                        end
                    end
                    
                    % Draw the fixation cross
                    Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                    
                    vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * DISPLAY.ifi);
                    
                    
                    %% RESPONSE
                    [ keyIsDown, seconds, keyCode ] = KbCheck;
                    
                    if keyIsDown && ~RESULTS.buttonID(ct)
                        
                        FindResponse=find(keyCode);
                        RESULTS.buttonID(ct)=FindResponse(1);
                        
                        RESULTS.RT(ct)=(GetSecs-RESULTS.T0);
                        
                        if (~all_trials(6-PARAMS.blocks(b),u,b) & RESULTS.buttonID(ct)==PARAMS.KeySame)...
                                | (all_trials(6-PARAMS.blocks(b),u,b) & RESULTS.buttonID(ct)==PARAMS.KeyDiff)
                            
                            RESULTS.Correct(ct)=1;
                            textfeedback='Correct';
                        else
                            RESULTS.Correct(ct)=0;
                            textfeedback='Try Again';
                        end
                    end
                    
                    
                end
                clear vblendtime vbl
                RESULTS.TestEnd(ct)=GetSecs-RESULTS.T0;
                
                
                
                
            else %% SOMATOSENSORY TRIALS
                %% SET DURATION OF EACH PIN IN THE "UP" AND "DOWN" POSITION
                % PiezoStim_standard
                PARAMS.piezo.stimTime_sample = 1000/ all_trials(1,u,b);
                PARAMS.piezo.stimTime_test = 1000/all_trials(3,u,b);
                PARAMS.piezo.stimTime = (RESULTS.ISI(ct)*1000)/(PARAMS.piezo.stimFreq);
                
                if PARAMS.piezo.connected
                    % Piezo opening and parameters
                    calllib('stimlib', 'initStimulator', '127318080D12L3686M939AFAHDDUGS');    % Code for new cards with 10 pins
                    calllib('stimlib', 'triggerOut',16,1);
                    calllib('stimlib', 'setProperty','local_buffer_size',150000);
                    
                    
                    % CHECK WAIT FOR THE TRIGGER
                    if PARAMS.piezo.trIn == 1; calllib('stimlib', 'waitForTrigger',16,0); end
                    
                    
                    % SET THE DACS
                    calllib('stimlib', 'setDAC',0,0);
                    calllib('stimlib', 'setDAC',1,PARAMS.piezo.intensity);                              % Half of the intensity
                    DAC=1;
                    
                    
                    
                    
                    %% DELIVER THE PIEZO STIMULATION (Different patterns on 2 fingers)
                    
                    index=PARAMS.tacttask.pins(all_trials(2,u,b),1);  % INDEX;
                    middle=PARAMS.tacttask.pins(all_trials(2,u,b),2); % MIDDLE
                    ring=PARAMS.tacttask.pins(all_trials(2,u,b),3); % RING
                    little=PARAMS.tacttask.pins(all_trials(2,u,b),4); %LITTLE finger
                    
                    vector_sample = [index middle ring little];
                    
                    
                    %% Stimulation pattern in the loop (SAMPLE)
                    
                    for bs=1:ceil(PARAMS.piezo.stimDuration_sample/PARAMS.piezo.stimTime_sample)
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_index,DAC,index,index,index,index,index,index,index,index,index,index);  % Up Set pin to 1 target intensity module 1!
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_middle,DAC,middle,middle,middle,middle,middle,middle,middle,middle,middle,middle);  % Up Set pin to 1 target intensity module 1!
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_ring,DAC,ring,ring,ring,ring,ring,ring,ring,ring,ring,ring);    % Up Set pin to 1 target intensity module 1!
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_little,DAC,little,little,little,little,little,little,little,little,little,little);   % Up Set pin to 1 target intensity module 1!
                        
                        calllib('stimlib', 'wait',1,PARAMS.piezo.stimTime_sample);
                        
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_index,DAC,0,0,0,0,0,0,0,0,0,0);   % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_middle,DAC,0,0,0,0,0,0,0,0,0,0);  % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_ring,DAC,0,0,0,0,0,0,0,0,0,0);    % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_little,DAC,0,0,0,0,0,0,0,0,0,0);   % Close and go down
                        
                        calllib('stimlib', 'wait',1,PARAMS.piezo.stimTime_sample);
                    end
                    
                    
                    %% INTER-STIMULUS INTERVAL
                    
                    for x=1:ceil((RESULTS.ISI(ct)*1000)/PARAMS.piezo.stimTime)
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_index,DAC,0,0,0,0,0,0,0,0,0,0);   % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_middle,DAC,0,0,0,0,0,0,0,0,0,0);  % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_ring,DAC,0,0,0,0,0,0,0,0,0,0);    % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_little,DAC,0,0,0,0,0,0,0,0,0,0);   % Close and go down
                        
                        calllib('stimlib', 'wait',1,PARAMS.piezo.stimTime);
                        
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_index,DAC,0,0,0,0,0,0,0,0,0,0);   % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_middle,DAC,0,0,0,0,0,0,0,0,0,0);  % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_ring,DAC,0,0,0,0,0,0,0,0,0,0);    % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_little,DAC,0,0,0,0,0,0,0,0,0,0);   % Close and go down
                        
                        calllib('stimlib', 'wait',1,PARAMS.piezo.stimTime);
                    end
                    
                    
                    index=PARAMS.tacttask.pins(all_trials(4,u,b),1);  % INDEX;
                    middle=PARAMS.tacttask.pins(all_trials(4,u,b),2); % MIDDLE
                    ring=PARAMS.tacttask.pins(all_trials(4,u,b),3); % RING
                    little=PARAMS.tacttask.pins(all_trials(4,u,b),4); %LITTLE finger
                    
                    vector_test = [index middle ring little];
                    
                    
                    for bt=1:ceil(PARAMS.piezo.stimDuration_test/PARAMS.piezo.stimTime_test)
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_index,DAC,index,index,index,index,index,index,index,index,index,index);  % Up Set pin to 1 target intensity module 1!
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_middle,DAC,middle,middle,middle,middle,middle,middle,middle,middle,middle,middle);  % Up Set pin to 1 target intensity module 1!
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_ring,DAC,ring,ring,ring,ring,ring,ring,ring,ring,ring,ring);    % Up Set pin to 1 target intensity module 1!
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_little,DAC,little,little,little,little,little,little,little,little,little,little);   % Up Set pin to 1 target intensity module 1!
                        
                        calllib('stimlib', 'wait',1,PARAMS.piezo.stimTime_test);
                        
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_index,DAC,0,0,0,0,0,0,0,0,0,0);   % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_middle,DAC,0,0,0,0,0,0,0,0,0,0);  % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_ring,DAC,0,0,0,0,0,0,0,0,0,0);    % Close and go down
                        calllib('stimlib', 'setPinBlock10',PARAMS.piezo.left_little,DAC,0,0,0,0,0,0,0,0,0,0);   % Close and go down
                        
                        calllib('stimlib', 'wait',1,PARAMS.piezo.stimTime_test);
                    end
                    
                    % Stimulation output
                    calllib('stimlib', 'startStimulation');%stimulation starts
                    
                            
                    % Draw the fixation cross
                    Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                    
                vbl=Screen('Flip', w);
                    
                    
                    %wait for stimulation to end
                    
                    vblendtime= vbl +  sum(   (PARAMS.piezo.stimDuration_sample/1000) + (PARAMS.piezo.stimDuration_test/1000) + RESULTS.ISI(ct));
                    
                    while vbl < vblendtime
                        
                        % Draw the fixation dot in white,and set it to the center of our screen
                        Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                        
                        % Flip 'waitframes' monitor refresh intervals after last redraw.
                        vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * DISPLAY.ifi);
                        
                    end
                    
                    calllib('stimlib', 'closeStimulator');%stimulation finishes
                    
                    RESULTS.TactStimEnd(ct)=GetSecs-RESULTS.T0;
                    
                    clear vblendtime vbl
                    
                    
                    
                    
                    
                    %% line asking the program to wait
                else
                    
                    %% DELIVER THE PIEZO STIMULATION (Different patterns on 2 fingers)
                    
                    index=PARAMS.tacttask.pins(1,all_trials(2,u,b));  % INDEX;
                    middle=PARAMS.tacttask.pins(2,all_trials(2,u,b)); % MIDDLE
                    ring=PARAMS.tacttask.pins(3,all_trials(2,u,b)); % RING
                    little=PARAMS.tacttask.pins(4,all_trials(2,u,b)); %LITTLE finger
                    
                    vector_sample = [index middle ring little];
                    
                    index=PARAMS.tacttask.pins(all_trials(2,u,b),1);  % INDEX;
                    middle=PARAMS.tacttask.pins(all_trials(2,u,b),2); % MIDDLE
                    ring=PARAMS.tacttask.pins(all_trials(2,u,b),3); % RING
                    little=PARAMS.tacttask.pins(all_trials(2,u,b),4); %LITTLE finger
                    
                    vector_test = [index middle ring little];
                    
                    %% DELIVER THE PIEZO STIMULATION (Different patterns on 2 fingers)
                    vbl=Screen('Flip', w);                % Perform initial Flip to sync us to the VBL and for getting an initial
                    
                    vblendtime= vbl + sum(   (PARAMS.piezo.stimDuration_sample/1000) + (PARAMS.piezo.stimDuration_test/1000) + RESULTS.ISI(ct));
                    
                    while vbl < vblendtime
                        
                        % Draw the fixation dot in white,and set it to the center of our screen
                        Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                        
                        
                        %display parameters
                        DrawFormattedText(w,['pattern sample ', num2str(vector_sample)],  'center', 100, DISPLAY.white);
                        DrawFormattedText(w,['pattern test ', num2str(vector_test)],  'center', 150, DISPLAY.white);
                        DrawFormattedText(w,['freq sample ', num2str(all_trials(1,u,b))], 'center', 200, DISPLAY.white);
                        DrawFormattedText(w,['freq test ', num2str(all_trials(3,u,b))],'center', 250,  DISPLAY.white);
                        
                        
                        % Flip 'waitframes' monitor refresh intervals after last redraw.
                        vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * DISPLAY.ifi);
                        
                        
                        
                    end
                    
                    %                 vblendtime=  sum(   PARAMS.piezo.stimDuration_sample + PARAMS.piezo.stimDuration_test + RESULTS.ISI(ct));
                    %
                    %                     while vbl < vblendtime
                    %
                    %                         % Draw the fixation dot in white,and set it to the center of our screen
                    %                         Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                    %
                    %                         % Flip 'waitframes' monitor refresh intervals after last redraw.
                    %                         vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * DISPLAY.ifi);
                    %
                    %                     end
                    
                    RESULTS.TactStimEnd(ct)=GetSecs-RESULTS.T0;
                    
                    clear vblendtime vbl
                    
                    
                end %end of conditional for piezo connected
            end %end of conditional for if the trial isvisual or somat
            
            %% ITI for either visual or somatosensory
            
            respframes=0;
            while respframes<120%%
                
                
                Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.red,[0 0],2);
                
                
                Screen('Flip', w);
                
                %% RESPONSE
                [ keyIsDown, seconds, keyCode ] = KbCheck;
                
                if keyIsDown && ~ RESULTS.buttonID(ct)
                    respframes=121;
                    FindResponse=find(keyCode);
                    
                    RESULTS.buttonID(ct)=FindResponse(1);
                    RESULTS.RT(ct)=(GetSecs-RESULTS.T0);
                    
                    if PARAMS.blocks(b)==11 | PARAMS.blocks(b)==1
                        
                        if (~all_trials(5,u,b) & RESULTS.buttonID(ct)==PARAMS.KeySame)...
                                | (all_trials(5,u,b) & RESULTS.buttonID(ct)==PARAMS.KeyDiff)
                            
                            RESULTS.Correct(ct)=1;
                            textfeedback='Correct';
                        else
                            RESULTS.Correct(ct)=0;
                            textfeedback='Try Again';
                            
                        end
                        
                    else
                        if (~all_trials(6,u,b) & RESULTS.buttonID(ct)==PARAMS.KeySame)...
                                | (all_trials(6,u,b) & RESULTS.buttonID(ct)==PARAMS.KeyDiff)
                            
                            RESULTS.Correct(ct)=1;
                            textfeedback='Correct';
                        else
                            RESULTS.Correct(ct)=0;
                            textfeedback='Try Again';
                        end
                        
                    end
                    
                    
                    if FindResponse(1) ==KbName('ESCAPE')
                        save(RESULTS.fname)
                        
                        
                        break;
                        
                    end
                end
                
                respframes=respframes+1;
            end
            
            disp(['Response  ',num2str(RESULTS.buttonID(ct)),'   ',textfeedback])
            
            if Practice % if Practice, display feedback
                
                for respframes=1:30%
                    
                    DrawFormattedText(w, textfeedback, 'center', 'center', DISPLAY.white);
                    
                    Screen('Flip', w);
                    
                end
                
                %                 for respframes=1:30%
                %
                %
                %
                %                     Screen('Flip', w);
                %
                %                 end
            end
            
            
            %% ITI
            RESULTS.ITI(ct)=randsample(ITIs,1);
            for ITIframes=1:round(RESULTS.ITI(ct)/DISPLAY.ifi)%%
                
                % Draw the fixation cross
                Screen('DrawDots',w,[DISPLAY.xCenter, DISPLAY.yCenter],DISPLAY.fixCrossDimPix,DISPLAY.white,[0 0],2);
                Screen('Flip', w);
                
            end
            
            ct=ct+1; %updates counter
        end  %Trials loop
        
        %% TRIAL LOOP ENDS HERE
        %%
        cb=cb+1; %updates block counter
        
    end %% BOCK LOOP ENDS HERE
    
    save(RESULTS.fname)
    
    
    % Restore normal priority scheduling in case something else was set
    % before:
    Priority(0);
    
    %The same commands wich close onscreen and offscreen windows also close
    %textures.
    sca;
    
    disp(['Percent correct:  ', num2str( sum(RESULTS.Correct)/length(RESULTS.Correct)*100),'%'] )
    
    
catch
    %this "catch" section executes in case of  an error in the "try" section
    %above.  Importantly, it closes the onscreen window if it's open.
    save(RESULTS.fname)
    sca;
    % Close any DAQ ports open
    if PARAMS.piezo.connected
        openDAQ=DaqFind;
        for i=1:length(openDAQ)
            stop(openDAQ(i))
            delete(openDAQ(i));
        end
        
    end
    Priority(0);
    psychrethrow(psychlasterror);
end %ends the try..catch..

% We're done!



