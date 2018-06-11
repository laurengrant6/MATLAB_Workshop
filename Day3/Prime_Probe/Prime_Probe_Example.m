%in this task, the two tasks are a Left, Right, Up, Down task and a Bird,
%Dog, Cat, Pig task. In each trial, the stimuli are either visual or
%auditory. Both modality and congruency are fully counter-balanced in the test trials, but
%only modality is counterbalanced in the practice trials. This was to reduce
%the amount of time it takes for Ps to complete the experiment.

function ConflictAdaptation(SubNum)

%turn off MATLAB warnings
warning('off')

% Enable unified mode of KbName.
% This way, KbName will accept identical key names on all operating systems
KbName('UnifyKeyNames');

%reset the random number generator
rng('shuffle');

%======================= Open Log File =======================%
%Open Logfile and write header information

%Check whether a logfile with the same name already exists
switch (exist(sprintf(sprintf('Prime_Probe_2task_Subject_%i_log.txt', SubNum))))
    
    case 0% the file does not exist so create it
        
        logFileName = sprintf('Prime_Probe_2task_Subject_%i_log.txt', SubNum);
        fid = fopen(logFileName,'w+');
        fprintf(fid,'Experiment ID\t Prime_Probe_2task_Paradigm\n');
        fprintf(fid,'Subject\t %d\n', SubNum);
        fprintf(fid,'Run Time\t %s\n\n', datestr(now));
        fprintf(fid,'Run Number \tTrial Number \tTask \tStimulus \tCurrent Trial Type \tPrevious Trial Type \tModality \tPrevModality \tStimulusOnsetTime \tStimulusOffsetTime \tResponse \tRT \tAccuracy \tPreviousAccuracy\n');
        
        
    case 2% the file already exists so ask whether to overwrite it.
        
        sprintf('An output file for subject %i already exists.', SubNum)
        Decision = input ('Overwrite this file? (1 = yes, 2 = abort) ');
        
        if (Decision == 1) %Overwrite the file
            
            logFileName = sprintf('Prime_Probe_2task_Subject_%i_log.txt', SubNum);
            fid = fopen(logFileName,'w+');
            fprintf(fid,'Experiment ID\t Prime_Probe_2task_Paradigm\n');
            fprintf(fid,'Subject\t %d\n', SubNum);
            fprintf(fid,'Run Time\t %s\n\n', datestr(now));
            fprintf(fid,'Run Number \tTrial Number \tTask \tStimulus \tCurrent Trial Type \tPrevious Trial Type \tModality \tPrevModality \tStimulusOnsetTime \tStimulusOffsetTime \tResponse \tRT \tAccuracy \tPreviousAccuracy\n');
            
        else %Don't overwrite the file and abort the script
            error('User chose to abort because a logfile for this subject already exists');
            return
            
        end%if
        
end %switch

%=============== Set Screen/Display/Task Parameters ===============%
% Display Parameters
BackColor = [0 0 0];
TextColor = [255 255 255];
TextFont = 'Arial Unicode MS';
FontSizeResp = 30;
FontSizeDistracterText = 80;%used to control the size of the visual targets and visual distracters
FontSizeTargetText = 80;%not used
FontSizeFix = 50;
InstructionSizeText = 20;
FontSizeError = 60;
%FontSizePeriod = 10;

%Task parameters
nRuns = 6; 
nTrialTypes = 8;
nTrialsPerRun = 128;
StartFixationDuration = 2;
EndFixationDuration = 2; %0;
%StimulusDuration = 0.300;%not used
PrimeDuration = 0.250;
Prime_Probe_Interval = 0.250;
ProbeDuration = 0.250;
%MaxResponseInterval in this experiment should be at least 200 ms less than the Prime_Probe_Interval + Error Feedback time (200 ms)
%The reason is that subjects respond to each stimulus (distracter + target)
MaxResponseInterval = 1.25; %This is measured from the time the probe (or target) onsets so no need to add other intervals.
nUniqueStimuli = 32;
%ITI = 1.7;%not used
Trial_Duration = 2.5;

%Enter the visual targets and distracters that participants will see
LEFT = sprintf('LEFT');
RIGHT = sprintf('RIGHT');
BIRD = sprintf('BIRD');
DOG = sprintf('DOG');

UP = sprintf('UP');
DOWN = sprintf('DOWN');
CAT = sprintf('CAT');
PIG = sprintf('PIG');

%Initialize some important sound parameters
InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [], 1, [0],16000, 1, [], 0.020);

%Load the auditory targets and distracters that participants will hear;
[LEFT_spoken soundfreq] = audioread('left1_300ms.wav');
[RIGHT_spoken soundfreq] = audioread('right1_250ms.wav');
[BIRD_spoken soundfreq] = audioread('bird_250_ms.wav');
[DOG_spoken soundfreq] = audioread('dog_250_ms.wav');

[UP_spoken soundfreq] = audioread('up1_250ms.wav');
[DOWN_spoken soundfreq] = audioread('down1_300ms.wav');
[CAT_spoken soundfreq] = audioread('cat_250_ms.wav');
[PIG_spoken soundfreq] = audioread('pig_250_ms.wav'); 

%Enter the keyboard button presses that correspond to <, >, up, and down
PossibleResponses ={'f', 'g', 'j', 'n'};

%%=============== Open a window on screen and set more screen parameters ===============%
%Set ScreenNum as MainScreen(0)
ScreenNum = 0;

if ismac == 1
    RestrictKeysForKbCheck([9,10,13,17,41,44,22,6,4]);
    res.height = 1600;
    res.width = 2560;
    res.hz = 60;
    res.pixelSize = 32;
    RequestedScreenResolution = NearestResolution(ScreenNum,[2560,1600,60,8]);
    
else
    RestrictKeysForKbCheck([70, 71, 74, 78, 32, 27]);
    %Turn off the task bar in case it fails to turn off by accident.
    ShowHideWinTaskbarMex(0);
    res.height = 1200;
    res.width = 1600;
    res.hz = 60;
    res.pixelSize = 32;
    oldResolution = SetResolution (ScreenNum, res);
    
end

%Open a window
[windowPtr] = Screen('OpenWindow', ScreenNum, BackColor);
HideCursor(windowPtr);
Screen('TextFont', windowPtr, TextFont);

%Set priority level (highest priority for precise timing)
priorityLevel = MaxPriority(windowPtr);
Priority(priorityLevel);

%Define Center of Screen
ScreenRect = Screen('Rect', windowPtr);
CenterX = ScreenRect(3)/2;
CenterY = ScreenRect(4)/2;

%Check the horizontal and vertical size of each visual word
Screen('TextSize',windowPtr, FontSizeDistracterText);
LEFT_Size = Screen('TextBounds', windowPtr, 'LEFT');
RIGHT_Size = Screen('TextBounds', windowPtr, 'RIGHT');
BIRD_Size = Screen('TextBounds', windowPtr, 'BIRD');
DOG_Size = Screen('TextBounds', windowPtr, 'DOG');

UP_Size = Screen('TextBounds', windowPtr, 'UP');
DOWN_Size = Screen('TextBounds', windowPtr, 'DOWN');
CAT_Size = Screen('TextBounds', windowPtr, 'CAT');
PIG_Size = Screen('TextBounds', windowPtr, 'PIG');

%Get FixationSize
Screen('TextSize',windowPtr, FontSizeFix);
FixSize = Screen('TextBounds', windowPtr, '+');

%Get instructionscreen sizes
Screen('TextSize',windowPtr, FontSizeResp);
AdvanceScreenSize = Screen('TextBounds', windowPtr, 'When you are ready, press the space bar to start Block X of Y');

%Get break screen size
Screen('TextSize',windowPtr, FontSizeResp);
BreakScreenSize = Screen('TextBounds', windowPtr, 'Please press the spacebar when you are ready to continue Block %d');

%Get error screen size
Screen('TextSize',windowPtr, FontSizeError);
ErrorScreenSize = Screen('TextBounds', windowPtr, 'Error');

%Get slack time for the monitor
slack = Screen('GetFlipInterval', windowPtr)/2;

% %Hide the cursor
HideCursor(windowPtr);

%========================== Start Cycling through the runs ======================%
for Run = 1:nRuns
    
    %===============Create the trial and stimulus sequences for this run======%
    
    %Create a first-order counterbalanced trial sequence consisting of
    %congruent and incongruent stimuli (2 trial types)
    
    TrialSequence = Counterbalanced_Order_Odd_Even(nTrialTypes, nTrialsPerRun);

    %Convert the trial sequence into a stimulus sequence involving the 16
    %stimuli below (listed as separate cases).
    
    %Task1 Odd-numbered trials with congruent stimuli will be cases 1 and 2
    %LL RR vis
    T1OddCongTrialsV = Shuffle([1*ones(1,(nTrialsPerRun/nUniqueStimuli)) 2*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task1 Even-numbered trials with congruent stimuli will be cases 3 and 4
    %UU DD vis
    T1EvenCongTrialsV = Shuffle([3*ones(1,(nTrialsPerRun/nUniqueStimuli)) 4*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task2 Odd-numbered trials with congruent stimuli will be cases 5 and 6
    %CC BB vis
    T2OddCongTrialsV = Shuffle([5*ones(1,(nTrialsPerRun/nUniqueStimuli)) 6*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task2 Even-numbered trials with congruent stimuli will be cases 7 and 8
    %DD PP vis
    T2EvenCongTrialsV = Shuffle([7*ones(1,(nTrialsPerRun/nUniqueStimuli)) 8*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task1 Odd-numbered trials with incongruent stimuli will be cases 9 and 10
    %LR RL vis
    T1OddIncongTrialsV = Shuffle([9*ones(1,(nTrialsPerRun/nUniqueStimuli)) 10*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task1 Even-numbered trials with incongruent stimuli will be cases 11 and 12
    %UD DU vis
    T1EvenIncongTrialsV = Shuffle([11*ones(1,(nTrialsPerRun/nUniqueStimuli)) 12*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task2 Odd-numbered incongruent trials with incongruent stimuli are cases 13 and 14
    %CB BC vis
    T2OddIncongTrialsV = Shuffle([13*ones(1,(nTrialsPerRun/nUniqueStimuli)) 14*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task2 Even-numbered incongruent trials with incongruent stimuli are cases 15 and 16
    %DP PD vis
    T2EvenIncongTrialsV = Shuffle([15*ones(1,(nTrialsPerRun/nUniqueStimuli)) 16*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Task1 Odd-numbered trials with congruent stimuli will be cases 17,18
    %LL RR aud
    T1OddCongTrialsA = Shuffle([17*ones(1,(nTrialsPerRun/nUniqueStimuli)) 18*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task1 Even-numbered trials with congruent stimuli will be cases 19,20
    %UU DD aud
    T1EvenCongTrialsA = Shuffle([19*ones(1,(nTrialsPerRun/nUniqueStimuli)) 20*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task2 Odd-numbered trials with congruent stimuli will be cases 21,22
    %CC BB aud
    T2OddCongTrialsA = Shuffle([21*ones(1,(nTrialsPerRun/nUniqueStimuli)) 22*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task2 Even-numbered trials with congruent stimuli will be cases 23,24
    %DD PP aud
    T2EvenCongTrialsA = Shuffle([23*ones(1,(nTrialsPerRun/nUniqueStimuli)) 24*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task1 Odd-numbered trials with incongruent stimuli will be cases 25,26
    %LR RL aud
    T1OddIncongTrialsA = Shuffle([25*ones(1,(nTrialsPerRun/nUniqueStimuli)) 26*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task1 Even-numbered trials with incongruent stimuli will be cases
    %27,28
    %UD DU aud
    T1EvenIncongTrialsA = Shuffle([27*ones(1,(nTrialsPerRun/nUniqueStimuli)) 28*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task2 Odd-numbered incongruent trials with incongruent stimuli are
    %cases 29,30
    %CB BC aud
    T2OddIncongTrialsA = Shuffle([29*ones(1,(nTrialsPerRun/nUniqueStimuli)) 30*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Task2 Even-numbered incongruent trials with incongruent stimuli are
    %cases 31,32
    %DP PD aud
    T2EvenIncongTrialsA = Shuffle([31*ones(1,(nTrialsPerRun/nUniqueStimuli)) 32*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Initialize the stimulus sequence for this run
    StimulusSequence = zeros(1,nTrialsPerRun);
    
    %Create the stimulus sequence for this run
    for ThisTrial = 1: nTrialsPerRun
        
        if mod(ThisTrial,2)%odd-numbered trial
            
            switch TrialSequence(ThisTrial)
                
                case 1%T1 congruent trial V
                    
                    StimulusSequence(ThisTrial) = T1OddCongTrialsV(1);
                    
                    T1OddCongTrialsV = T1OddCongTrialsV(2:end);
                    
                    
                case 2%T1 incongruent trial V
                    
                    StimulusSequence(ThisTrial) = T1OddIncongTrialsV(1);
                    
                    T1OddIncongTrialsV = T1OddIncongTrialsV(2:end);
                    
                    
                case 3%T2 cong trial V
                    
                    StimulusSequence(ThisTrial) = T2OddCongTrialsV(1);
                    
                    T2OddCongTrialsV = T2OddCongTrialsV(2:end);
                    
                    
                case 4%T2 incong trial V
                    
                    StimulusSequence(ThisTrial) = T2OddIncongTrialsV(1);
                    
                    T2OddIncongTrialsV = T2OddIncongTrialsV(2:end);
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                case 5%T1 congruent trial A
                    
                    StimulusSequence(ThisTrial) = T1OddCongTrialsA(1);
                    
                    T1OddCongTrialsA = T1OddCongTrialsA(2:end);
                    
                    
                case 6%T1 incongruent trial A
                    
                    StimulusSequence(ThisTrial) = T1OddIncongTrialsA(1);
                    
                    T1OddIncongTrialsA = T1OddIncongTrialsA(2:end);
                    
                    
                case 7%T2 cong trial A
                    
                    StimulusSequence(ThisTrial) = T2OddCongTrialsA(1);
                    
                    T2OddCongTrialsA = T2OddCongTrialsA(2:end);
                    
                    
                case 8%T2 incong trial A
                    
                    StimulusSequence(ThisTrial) = T2OddIncongTrialsA(1);
                    
                    T2OddIncongTrialsA = T2OddIncongTrialsA(2:end);
                    
                    
            end%switch
            
            
        else%even-numbered trial
            
            switch TrialSequence(ThisTrial)
                
                case 1%T1 congruent trial V
                    
                    StimulusSequence(ThisTrial) = T1EvenCongTrialsV(1);
                    
                    T1EvenCongTrialsV = T1EvenCongTrialsV(2:end);
                    
                    
                case 2%T1 incongruent trial V
                    
                    StimulusSequence(ThisTrial) = T1EvenIncongTrialsV(1);
                    
                    T1EvenIncongTrialsV = T1EvenIncongTrialsV(2:end);
                    
                    
                case 3%T2 cong trial V
                    
                    StimulusSequence(ThisTrial) = T2EvenCongTrialsV(1);
                    
                    T2EvenCongTrialsV = T2EvenCongTrialsV(2:end);
                    
                    
                case 4%T2 incong trial V
                    
                    StimulusSequence(ThisTrial) = T2EvenIncongTrialsV(1);
                    
                    T2EvenIncongTrialsV = T2EvenIncongTrialsV(2:end);
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                case 5%T1 congruent trial A
                    
                    StimulusSequence(ThisTrial) = T1EvenCongTrialsA(1);
                    
                    T1EvenCongTrialsA = T1EvenCongTrialsA(2:end);
                    
                    
                case 6%T1 incongruent trial A
                    
                    StimulusSequence(ThisTrial) = T1EvenIncongTrialsA(1);
                    
                    T1EvenIncongTrialsA = T1EvenIncongTrialsA(2:end);
                    
                    
                case 7%T2 cong trial A
                    
                    StimulusSequence(ThisTrial) = T2EvenCongTrialsA(1);
                    
                    T2EvenCongTrialsA = T2EvenCongTrialsA(2:end);
                    
                    
                case 8%T2 incong trial A
                    
                    StimulusSequence(ThisTrial) = T2EvenIncongTrialsA(1);
                    
                    T2EvenIncongTrialsA = T2EvenIncongTrialsA(2:end);
                    
                    
            end%switch
            
        end%if
        
    end%for
    
    
    
    %%================ COMPUTE OUTPUT CODES FOR LATER==================%
    
    %Need Task, Stimulus, PrevTrialType, CurrTrialType, Correct Response, and Run for each trial
    Task = cell(nTrialsPerRun, 1);
    Stimulus = cell(nTrialsPerRun, 1);
    CurrTrialType = cell(nTrialsPerRun, 1);
    CorrectResponse = cell(nTrialsPerRun, 1);
    PrevTrialType = cell(nTrialsPerRun, 1);
    Modality = cell(nTrialsPerRun, 1);
    PrevModality = cell(nTrialsPerRun, 1);
    
    %Initialize Stimulus_Times and Fixation_Times at the start of each run
    Stimulus_Times = [];
    Fixation_Times = [];
    
    %Also initialize Acc and PrevAcc
    Acc = cell(nTrialsPerRun, 1);
    PrevAcc = cell(nTrialsPerRun, 1);
    
    %Code the trials for the current run
    for ThisTrial = 1:nTrialsPerRun
        
        %Task
        %Odd trials (MSIT stimuli made of 1s and 2s)
        %Even trials (MSIT stimuli made of 3s and 4s)
        if mod(ThisTrial, 2)
            
            %Odd trial
            Task{ThisTrial} = 'LRBD_Task';
            
        else
            
            %Even trial
            Task{ThisTrial} = 'UDCP_Task';
            
        end
        
        %Stimulus & CorrectResponse
        switch StimulusSequence(ThisTrial)
            case 1
                Stimulus{ThisTrial} = double('LL_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case 2
                Stimulus{ThisTrial} = double('RR_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case 3
                Stimulus{ThisTrial} = double('UU_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{3};
            case 4
                Stimulus{ThisTrial} = double('DD_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{4};
            case 5
                Stimulus{ThisTrial} = double('BB_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case 6
                Stimulus{ThisTrial} = double ('DD_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case 7
                Stimulus{ThisTrial} = double('CC_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{3};
            case 8
                Stimulus{ThisTrial} = double('PP_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{4};

            case 9
                Stimulus{ThisTrial} = double('LR_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case 10
                Stimulus{ThisTrial} = double('RL_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case 11
                Stimulus{ThisTrial} = double('UD_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{4};
            case 12
                Stimulus{ThisTrial} = double('DU_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{3};
            case 13
                Stimulus{ThisTrial} = double('BD_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case 14
                Stimulus{ThisTrial} = double('DB_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case 15
                Stimulus{ThisTrial} = double('CP_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{4};
            case 16
                Stimulus{ThisTrial} = double('PC_Vis');
                CorrectResponse{ThisTrial} = PossibleResponses{3};

            case 17
                Stimulus{ThisTrial} = double('LL_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case 18
                Stimulus{ThisTrial} = double('RR_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case 19
                Stimulus{ThisTrial} = double('UU_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{3};
            case 20
                Stimulus{ThisTrial} = double('DD_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{4};
            case 21
                Stimulus{ThisTrial} = double('BB_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case 22
                Stimulus{ThisTrial} = double ('DD_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case 23
                Stimulus{ThisTrial} = double('CC_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{3};
            case 24
                Stimulus{ThisTrial} = double('PP_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{4};
             
            case 25
                Stimulus{ThisTrial} = double('LR_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case 26
                Stimulus{ThisTrial} = double('RL_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case 27
                Stimulus{ThisTrial} = double('UD_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{4};
            case 28
                Stimulus{ThisTrial} = double('DU_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{3};
            case 29
                Stimulus{ThisTrial} = double('BD_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case 30
                Stimulus{ThisTrial} = double('DB_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case 31
                Stimulus{ThisTrial} = double('CP_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{4};
            case 32
                Stimulus{ThisTrial} = double('PC_Aud');
                CorrectResponse{ThisTrial} = PossibleResponses{3};
                
        end
        
        %CurrTrialType
        if (StimulusSequence(ThisTrial) < 9)
            CurrTrialType{ThisTrial} = 'Congruent';
            Modality{ThisTrial} = 'Visual';
            
        elseif ( (StimulusSequence(ThisTrial) > 8) & (StimulusSequence(ThisTrial) < 17 ) )
            CurrTrialType{ThisTrial} = 'Incongruent';
            Modality{ThisTrial} = 'Visual';
            
        elseif ( (StimulusSequence(ThisTrial) > 16) & (StimulusSequence(ThisTrial) < 25 ) )
            CurrTrialType{ThisTrial} = 'Congruent';
            Modality{ThisTrial} = 'Auditory';
            
        elseif ( (StimulusSequence(ThisTrial) > 24) & (StimulusSequence(ThisTrial) < 33 ) )
            CurrTrialType{ThisTrial} = 'Incongruent';
            Modality{ThisTrial} = 'Auditory';
            
        end
        
        %PrevTrialType and PrevModality
        if (ThisTrial == 1)
            PrevTrialType{ThisTrial} = 'None';
            PrevModality{ThisTrial} = 'None';
        else
            PrevTrialType{ThisTrial} = CurrTrialType{ThisTrial -1};
            PrevModality{ThisTrial} = Modality{ThisTrial - 1};
        end
        
    end%ThisTrial
    
    %Code the run label (practice or test block number) & convert to cell
    run = cell(nRuns, 1);
    for iii = 1:nRuns
            run{iii} = sprintf('%d', iii);

    end
    
    
    
    %%=============== PRESENT THE STIMULI FOR THIS RUN ===============%
    
        %if practice is completed, we don't have the instruction screen before the next block.
        %Thus, we need to tell the subject to press the 5 key to start the
        %next block of trials (5 key also used for the new fMRI scanner
        %Wait until the 5 key is pressed on the upper row of the keyboard
        %before starting the next run
        Screen('TextSize',windowPtr, FontSizeResp);
        InstructionScreen = ['This test block will last approximately 5 minutes and 20 seconds. \n\n' ...
                             'There will be a break half-way through the test block. \n\n'...
                             sprintf('When you are ready, press the space bar to start Block %d of %d. \n\n', Run, nRuns)];
                         
        DrawFormattedText(windowPtr, InstructionScreen, 'center', 'center', TextColor);
       % Screen('DrawText', windowPtr, sprintf('When you are ready, press the space bar to start Block %d of %d. \n\n', Run, nRuns), CenterX-round(AdvanceScreenSize(3)/2), CenterY-round(AdvanceScreenSize(4)/2),TextColor);
        Screen('Flip', windowPtr);
        KeyBoardAdvance;
    
    %Draw a fixation point at the beginning of each run
    Screen('TextSize',windowPtr, FontSizeFix);
    Screen('DrawText', windowPtr,'+', CenterX-round(FixSize(3)/2), CenterY-round(FixSize(4)/2),TextColor);
    [Start_Time] = Screen('Flip',windowPtr);
    
    
    %Show each of the trials in this run
    for i = 1:nTrialsPerRun
   
        trialpos = 1:nTrialsPerRun;
        
        if (trialpos(i) == 65)
            tic;
            Screen('TextSize',windowPtr, FontSizeResp);
            Screen('DrawText', windowPtr, sprintf('Please press the spacebar when you are ready to continue Block %d', Run), CenterX-round(BreakScreenSize(3)/2), CenterY-round(BreakScreenSize(4)/2),TextColor);
            Screen('Flip', windowPtr);
            KeyBoardAdvance;
            
            Screen('TextSize',windowPtr, FontSizeFix);
            Screen('DrawText', windowPtr,'+', CenterX-round(FixSize(3)/2), CenterY-round(FixSize(4)/2),TextColor);
            Screen('Flip',windowPtr);
            x = toc;
            
            [Start_Time] = Start_Time + x;
        end
        
        Screen('TextSize',windowPtr, FontSizeDistracterText);
        
        %Primes
        switch StimulusSequence(i)
            %case 1 LL RR; UU DD; BB DD; CC PP; LR RL; UD DU; BD DB; CP PC
            case 1
                %LL_Visual
                Screen('DrawText', windowPtr, LEFT, CenterX-round(LEFT_Size(3)/2), CenterY-round(LEFT_Size(4)/2),TextColor);
                
            case 2
                %RR_Visual
                Screen('DrawText', windowPtr, RIGHT, CenterX-round(RIGHT_Size(3)/2), CenterY-round(RIGHT_Size(4)/2),TextColor);
                
            case 3
                %UU_Visual
                Screen('DrawText', windowPtr, UP, CenterX-round(UP_Size(3)/2), CenterY-round(UP_Size(4)/2),TextColor);
                
            case 4
                %DD_Visual
                Screen('DrawText', windowPtr, DOWN, CenterX-round(DOWN_Size(3)/2), CenterY-round(DOWN_Size(4)/2),TextColor);
                
            case 5
                %BB_Visual
                Screen('DrawText', windowPtr, BIRD, CenterX-round(BIRD_Size(3)/2), CenterY-round(BIRD_Size(4)/2),TextColor);
                
            case 6
                %DD_Visual
                Screen('DrawText', windowPtr, DOG, CenterX-round(DOG_Size(3)/2), CenterY-round(DOG_Size(4)/2),TextColor);
                
            case 7
                %CC_Visual
                Screen('DrawText', windowPtr, CAT, CenterX-round(CAT_Size(3)/2), CenterY-round(CAT_Size(4)/2),TextColor);
                
            case 8
                %PP_Visual
                Screen('DrawText', windowPtr, PIG, CenterX-round(PIG_Size(3)/2), CenterY-round(PIG_Size(4)/2),TextColor);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            case 9
                %LR_Visual
                Screen('DrawText', windowPtr, LEFT, CenterX-round(LEFT_Size(3)/2), CenterY-round(LEFT_Size(4)/2),TextColor);
                
            case 10
                %RL_Visual
                Screen('DrawText', windowPtr, RIGHT, CenterX-round(RIGHT_Size(3)/2), CenterY-round(RIGHT_Size(4)/2),TextColor);
                
            case 11
                %UD_Visual
                Screen('DrawText', windowPtr, UP, CenterX-round(UP_Size(3)/2), CenterY-round(UP_Size(4)/2),TextColor);
                
            case 12
                %DU_Visual
                Screen('DrawText', windowPtr, DOWN, CenterX-round(DOWN_Size(3)/2), CenterY-round(DOWN_Size(4)/2),TextColor);
                
            case 13
                %BD_Visual
                Screen('DrawText', windowPtr, BIRD, CenterX-round(BIRD_Size(3)/2), CenterY-round(BIRD_Size(4)/2),TextColor);
                
            case 14
                %DB_Visual
                Screen('DrawText', windowPtr, DOG, CenterX-round(DOG_Size(3)/2), CenterY-round(DOG_Size(4)/2),TextColor);
                
            case 15
                %CP_Visual
                Screen('DrawText', windowPtr, CAT, CenterX-round(CAT_Size(3)/2), CenterY-round(CAT_Size(4)/2),TextColor);
                
            case 16
                %PC_Visual
                Screen('DrawText', windowPtr, PIG, CenterX-round(PIG_Size(3)/2), CenterY-round(PIG_Size(4)/2),TextColor);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            case 17
                %LL_Auditory
                PsychPortAudio('FillBuffer', pahandle, LEFT_spoken');
                
            case 18
                %RR_Auditory
                PsychPortAudio('FillBuffer', pahandle, RIGHT_spoken');
                
            case 19
                %UU_Auditory
                PsychPortAudio('FillBuffer', pahandle, UP_spoken');
                
            case 20
                %DD_Auditory
                PsychPortAudio('FillBuffer', pahandle, DOWN_spoken');
                
            case 21
                %BB_Auditory
                PsychPortAudio('FillBuffer', pahandle, BIRD_spoken');
                
            case 22
                %DD_Auditory
                PsychPortAudio('FillBuffer', pahandle, DOG_spoken');
                
            case 23
                %CC_Auditory
                PsychPortAudio('FillBuffer', pahandle, CAT_spoken');
                
            case 24
                %PP_Auditory
                PsychPortAudio('FillBuffer', pahandle, PIG_spoken');
                
            case 25
                %LR_Auditory
                PsychPortAudio('FillBuffer', pahandle, LEFT_spoken');
                
            case 26
                %RL_Auditory
                PsychPortAudio('FillBuffer', pahandle, RIGHT_spoken');
                
            case 27
                %UD_Auditory
                PsychPortAudio('FillBuffer', pahandle, UP_spoken');
                
            case 28
                %DU_Auditory
                PsychPortAudio('FillBuffer', pahandle, DOWN_spoken');
                
            case 29
                %BD_Auditory
                PsychPortAudio('FillBuffer', pahandle, BIRD_spoken');
                
            case 30
                %DB_Auditory
                PsychPortAudio('FillBuffer', pahandle, DOG_spoken');
                
            case 31
                %CP_Auditory
                PsychPortAudio('FillBuffer', pahandle, CAT_spoken');
                
            case 32
                %PC_Auditory
                PsychPortAudio('FillBuffer', pahandle, PIG_spoken');
                
        end
        
        %Go through a loop until we're ready for the next trial to prevent
        %a high-pitched noise from the CRT monitor during the fixation ITI!
        while (GetSecs < (Start_Time + StartFixationDuration + Trial_Duration*(i-1)-slack))
        end
        
        %Present the trials at regular intervals after the start fixation ends
        %Also, record the time when the screen flips in VBL_stimulus
        if (StimulusSequence(i) < 17) %visual prime
            
            [VBL_stimulus] = Screen('Flip',windowPtr, (Start_Time + StartFixationDuration + Trial_Duration*(i-1)-slack));
            
        else
            
            PsychPortAudio('Start', pahandle);
            
            VBL_stimulus = GetSecs;
            
        end
        
        %Log when the stimulus was presented
        Stimulus_Times = [Stimulus_Times VBL_stimulus - Start_Time];
        
        %Go through a loop for a while until we're ready to clear the prime
        while (GetSecs < (Start_Time + StartFixationDuration + Trial_Duration*(i-1)-slack) + PrimeDuration);
        end
        
        %Draw a fixation during the prime-probe interval
        Screen('TextSize',windowPtr, FontSizeFix);
        Screen('DrawText', windowPtr,' ', CenterX-round(FixSize(3)/2), CenterY-round(FixSize(4)/2),TextColor);
        Screen('Flip',windowPtr);
        
        %Go through a loop for the rest of the prime-probe interval
        while (GetSecs < (Start_Time + StartFixationDuration + Trial_Duration*(i-1)-slack) + PrimeDuration + Prime_Probe_Interval);
        end
        
        %Present the probe
        
        Screen('TextSize',windowPtr, FontSizeDistracterText);
        
        %Probes
        switch StimulusSequence(i)
            
            case 1
                %LL_Visual
                Screen('DrawText', windowPtr, LEFT, CenterX-round(LEFT_Size(3)/2), CenterY-round(LEFT_Size(4)/2),TextColor);
                
            case 2
                %RR_Visual
                Screen('DrawText', windowPtr, RIGHT, CenterX-round(RIGHT_Size(3)/2), CenterY-round(RIGHT_Size(4)/2),TextColor);
                
            case 3
                %UU_Visual
                Screen('DrawText', windowPtr, UP, CenterX-round(UP_Size(3)/2), CenterY-round(UP_Size(4)/2),TextColor);
                
            case 4
                %DD_Visual
                Screen('DrawText', windowPtr, DOWN, CenterX-round(DOWN_Size(3)/2), CenterY-round(DOWN_Size(4)/2),TextColor);
                
            case 5
                %BB_Visual
                Screen('DrawText', windowPtr, BIRD, CenterX-round(BIRD_Size(3)/2), CenterY-round(BIRD_Size(4)/2),TextColor);
                
            case 6
                %DD_Visual
                Screen('DrawText', windowPtr, DOG, CenterX-round(DOG_Size(3)/2), CenterY-round(DOG_Size(4)/2),TextColor);
                
            case 7
                %CC_Visual
                Screen('DrawText', windowPtr, CAT, CenterX-round(CAT_Size(3)/2), CenterY-round(CAT_Size(4)/2),TextColor);
                
            case 8
                %PP_Visual
                Screen('DrawText', windowPtr, PIG, CenterX-round(PIG_Size(3)/2), CenterY-round(PIG_Size(4)/2),TextColor);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            case 9
                %LR_Visual
                Screen('DrawText', windowPtr, RIGHT, CenterX-round(RIGHT_Size(3)/2), CenterY-round(RIGHT_Size(4)/2),TextColor);
                
            case 10
                %RL_Visual
                Screen('DrawText', windowPtr, LEFT, CenterX-round(LEFT_Size(3)/2), CenterY-round(LEFT_Size(4)/2),TextColor);
                
            case 11
                %UD_Visual
                Screen('DrawText', windowPtr, DOWN, CenterX-round(DOWN_Size(3)/2), CenterY-round(DOWN_Size(4)/2),TextColor);
            case 12
                %DU_Visual
                Screen('DrawText', windowPtr, UP, CenterX-round(UP_Size(3)/2), CenterY-round(UP_Size(4)/2),TextColor);
                
            case 13
                %BD_Visual
                Screen('DrawText', windowPtr, DOG, CenterX-round(DOG_Size(3)/2), CenterY-round(DOG_Size(4)/2),TextColor);
                
            case 14
                %DB_Visual
                Screen('DrawText', windowPtr, BIRD, CenterX-round(BIRD_Size(3)/2), CenterY-round(BIRD_Size(4)/2),TextColor);
                
            case 15
                %CP_Visual
                Screen('DrawText', windowPtr, PIG, CenterX-round(PIG_Size(3)/2), CenterY-round(PIG_Size(4)/2),TextColor);
            case 16
                %PC_Visual
                Screen('DrawText', windowPtr, CAT, CenterX-round(CAT_Size(3)/2), CenterY-round(CAT_Size(4)/2),TextColor);
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            case 17
                %LL_Auditory
                PsychPortAudio('FillBuffer', pahandle, LEFT_spoken');
                
            case 18
                %RR_Auditory
                PsychPortAudio('FillBuffer', pahandle, RIGHT_spoken');
                
            case 19
                %UU_Auditory
                PsychPortAudio('FillBuffer', pahandle, UP_spoken');
                
            case 20
                %DD_Auditory
                PsychPortAudio('FillBuffer', pahandle, DOWN_spoken');
                
            case 21
                %BB_Auditory
                PsychPortAudio('FillBuffer', pahandle, BIRD_spoken');
                
            case 22
                %DD_Auditory
                PsychPortAudio('FillBuffer', pahandle, DOG_spoken');
                
            case 23
                %CC_Auditory
                PsychPortAudio('FillBuffer', pahandle, CAT_spoken');
                
            case 24
                %PP_Auditory
                PsychPortAudio('FillBuffer', pahandle, PIG_spoken');
                
            case 25
                %LR_Auditory
                PsychPortAudio('FillBuffer', pahandle, RIGHT_spoken');
                
            case 26
                %RL_Auditory
                PsychPortAudio('FillBuffer', pahandle, LEFT_spoken');
                
            case 27
                %UD_Auditory
                PsychPortAudio('FillBuffer', pahandle, DOWN_spoken');
                
            case 28
                %DU_Auditory
                PsychPortAudio('FillBuffer', pahandle, UP_spoken');
                
            case 29
                %BD_Auditory
                PsychPortAudio('FillBuffer', pahandle, DOG_spoken');
                
            case 30
                %DB_Auditory
                PsychPortAudio('FillBuffer', pahandle, BIRD_spoken');
                
            case 31
                %CP_Auditory
                PsychPortAudio('FillBuffer', pahandle, PIG_spoken');
                
            case 32
                %PC_Auditory
                PsychPortAudio('FillBuffer', pahandle, CAT_spoken');
                
        end
        
        
        %Turn on the probe and log the time it is presented
        if (StimulusSequence(i) < 17) %visual probe
            
            [Probe_Time] = Screen('Flip',windowPtr, (Start_Time + StartFixationDuration + Trial_Duration*(i-1)-slack) + PrimeDuration + Prime_Probe_Interval);
            
        else
            PsychPortAudio('Start', pahandle); %auditory probe
            
            Probe_Time = GetSecs;
            % PsychPortAudio('Stop', pahandle, 1);
        end
        
        %Go through a loop for a while until we're ready to clear the probe
        while (GetSecs < (Start_Time + StartFixationDuration + Trial_Duration*(i-1)-slack) + PrimeDuration + Prime_Probe_Interval + ProbeDuration);
        end
        
        %Clear the probe by drawing the fixation cross
        Screen('TextSize',windowPtr, FontSizeFix);
        Screen('DrawText', windowPtr,' ', CenterX-round(FixSize(3)/2), CenterY-round(FixSize(4)/2),TextColor);
        [VBL_fixation] = Screen('Flip',windowPtr);
        
        %Log when the fixation was presented
        Fixation_Times = [Fixation_Times VBL_fixation - Start_Time];
        
        
        %%%%%%%%%%%%%%%%Check for response%%%%%%%%%%%%%%%%
        %Initialize variables for this trial
        KeyIsDown = 0;
        Secs = 0;
        KeyCode = [];
        RT =[];
        keys =[];
        nKeys = 0;
        
        %Check for a response for about MaxResponseInterval seconds
        %minus the time that has already passed
        while (GetSecs < Probe_Time + MaxResponseInterval)
            
            [KeyIsDown, Secs, KeyCode] = KbCheck;
            KeyButton = find(KeyCode, 1, 'first');
            if KeyIsDown %a key is down: record the key and time pressed
                nKeys = nKeys+1;
                RT(nKeys) = Secs-Probe_Time;%RT is key press time - time when probe appeared (not prime)
                keys{nKeys} = KbName(KeyButton);
                
                if strcmp(keys(nKeys),'ESCAPE')
                    Screen('CloseAll')
                    ShowCursor;
                    error('User pressed the escape key to abort');
                    return
                end
                
                %clear the keyboard buffer
                while KbCheck; end
                
            end
        end
        
        %If no response is made
        if (nKeys == 0)
            
            nKeys = nKeys + 1;
            RT(nKeys) = 5000;
            keys{nKeys} = 'Omission';
            
        end%if
        
        
        %Only use the first key press to compute accuracy and RT
        nKeys = 1;
        
        %Calculate Acc
        if strcmp (keys(nKeys), CorrectResponse{i})
            Acc{i} = 'Correct';
        elseif strcmp(keys{nKeys}, 'Omission')
            Acc{i} = 'Omission';
        else
            Acc{i} = 'Error';
        end
        
        if (strcmp(Acc{i}, 'Omission') | (strcmp (Acc{i}, 'Error')))
            Screen('TextSize',windowPtr, FontSizeError);
            Screen('DrawText', windowPtr,'Error', CenterX-round(ErrorScreenSize(3)/2), CenterY-round(ErrorScreenSize(4)/2),TextColor);
            [Feedback_Time] = Screen('Flip', windowPtr);
            
            Screen('TextSize',windowPtr, FontSizeFix);
            Screen('DrawText', windowPtr,' ', CenterX-round(FixSize(3)/2), CenterY-round(FixSize(4)/2),TextColor);
            Screen('Flip',windowPtr, Feedback_Time + 0.200);
        end
        
        %Calculate PrevAcc
        if (i==1)
            PrevAcc{i} = 'None';
        else
            PrevAcc{i} = Acc{i-1};
        end
        
        %=====================================Save Output After Each Trial=================%
        fprintf(fid, '%s\t %d\t %s\t %s\t %s\t %s\t %s\t %s\t %f\t %f\t %s\t %f\t %s\t %s\n', run{Run}, i, Task{i}, Stimulus{i}, CurrTrialType{i}, PrevTrialType{i}, Modality{i}, PrevModality{i}, Stimulus_Times(i), Fixation_Times(i), keys{nKeys}, RT(nKeys), Acc{i}, PrevAcc{i});
        
    end% nTrialsPerRun
    
    %================End of Run Details=================%
    
    %Draw a Fixation at the end of the run for a few seconds if desired
    Screen('TextSize',windowPtr, FontSizeFix);
    Screen('DrawText', windowPtr,' ', CenterX-round(FixSize(3)/2), CenterY-round(FixSize(4)/2),TextColor);
    Screen('Flip',windowPtr);
    
    tic;
    while (toc < EndFixationDuration)
    end
    
end% Run loop

%=========End of Experiment Details============%
Screen('Close', windowPtr);% End of experiment
fclose(fid);
ShowCursor;
clear all;


%===============================================
% function: KeyBoard Advance
% purpose: wait for space bar to be pressed to advance to next screen
%===============================================

function KeyBoardAdvance

FlushEvents('keyDown');
KeepChecking = 1;
while KeepChecking == 1;
    [keyIsDown, secs, keyCode] = KbCheck;
    
    if keyIsDown
        if find(keyCode ~= 0) == KbName('space')
            KeepChecking = 0;
        end
    end
    WaitSecs(0.001);
end
while KbCheck; end
clear keyIsDown;
return

