
function Cookie_Visual_Search(SubNum)

Screen('Preference', 'SkipSyncTests', 1);

%enable unified code of KbName
KbName('UnifyKeyNames');

%=============================Open Log File===============================%

%check whether a logfile with the SAME NAME already exists
switch (exist (sprintf(sprintf('Cookie_Visual_Search_Subject_%i_log.txt', SubNum))))
    
    case 0 % the file doesn't exist = create it
        
        logFileName = sprintf('Cookie_Visual_Search_Subject_%i_log.txt',SubNum);
        fid = fopen(logFileName, 'w+');
        fprintf(fid,'Experiment ID\t Cookie_Visual_Search\n');
        fprintf(fid, 'Subject\t %d\n', SubNum);
        fprintf(fid, 'Run Time\t %s\n\n', datestr(now));
        fprintf(fid,'Run Number \tTrial Number \tTask \tStimulus \tCurrent Trial Type \tPrevious Trial Type\t Fix_Value\t Fix Onset\t Array Onset\t Array_Feedback_Interval_Screen Onset\t Feedback_Onset\t ITI_Fix Onset\t ITI_End\t Response \tRT \tAccuracy \tPreviousAccuracy\n');
        
        
    case 2% the file already exists: ask to overwrite it
        
        sprintf('An output file for subject %i already exists.',SubNum)
        Decision = input('Overwrite this file? (1 = yes, 2 = abort)');
        
        if (Decision == 1) %Overwrite the file
            
            logFileName = sprintf('Cookie_Visual_Search_%i_log.txt', SubNum);
            fid=fopen(logFileName, 'w+');
            fprintf(fid, 'Experiment ID\t Cookie_Visual_Search\n');
            fprintf(fid, 'Subject\t %d\n',SubNum);
            fprintf(fid, 'Run Time\t %s\n\n', datestr(now));
            
            fprintf(fid,'Run Number \tTrial Number \tTask \tStimulus \tCurrent Trial Type \tPrevious Trial Type\t Fix_Value\t Fix Onset\t Array Onset\t Array_Feedback_Interval_Screen Onset\t Feedback_Onset\t ITI_Fix Onset\t ITI_End\t Response \tRT \tAccuracy \tPreviousAccuracy\n');
            
        else %Don't overwrite the file and abort the script
            error('User chose to abort because a logfile for this subject already exists');
            return
            
            
        end%if
        
end%switch
%=================== Screen & Display ==================%
Pathway = '/Users/laurengrant/Dropbox/2018/MATLAB_WORKSHOP/Day3/Sample_Images/';

%Background and Text format
BackColor = [0 0 0]; %black
TextColor = [255 255 255];%white
FontSizeResp = 30; %instruction font for beginning training run
FontSizeFix = 50;
InstructionSizeText = 16;
FontSizeError = 50;

%Task parameters
nRuns = 2; %the first run is practice so there are really nRuns - 1 runs
nTrialTypes = 2; %Cookie and Pie
nPracticeTrials = 48;
nTrainingTrials = 240; 
StartFixationDuration = 2;%this is just to give the Ps some time before the trial begins
EndFixationDuration = 2;%same reason, just at the end. it is optional.

Array_Duration = 0.800;
Array_Feedback_Interval = 1.0;
Feedback_Duration = 1.5;
nUniqueStimuli = 8;
ITI = 1.0;

%Distracters
image1 = {'sample_image1.jpg'};
image2 = {'sample_image2.jpg'};
image3 = {'sample_image3.jpg'};
image4 = {'sample_image4.jpg'};
image5 = {'sample_image5.jpg'};

%Targets
Cookie_image1 = imread(strcat(Pathway,'sample_image6.jpg'));
Pie_image1 = imread(strcat(Pathway,'sample_image7.jpg'));

%Possible keyboard responses
PossibleResponses = {'z','m'};

%==========Open a window on screen and set more screen parameters=========%

%Set ScreenNum as MainScreen(0)
ScreenNum = 0;

if ismac == 1
    RestrictKeysForKbCheck([29, 16,44,41]);

else
    %Enable KbCheck to look only for task-relevant button presses.
    RestrictKeysForKbCheck([90, 77, 32, 27]); %90 = z; 77 = m; 32 = space; 27 = escape
    
    ShowHideWinTaskbarMex(0);
end

%Open a window
[windowPtr] = Screen('OpenWindow', ScreenNum, BackColor);
HideCursor(windowPtr);

%define center of screen
ScreenRect = Screen('Rect', windowPtr);
x0 = ScreenRect(3)/2;
y0 = ScreenRect (4)/2;

%===============Stimuli Size, Coordinates, & Stimuli======================%
%Stimuli Size
ysize = 121;
xsize = 121;

%Coordinates

%up coordinates:
x_up = 0;
y_up = -181;

%up_left coordinates:
x_up_left = -181;
y_up_left = -91;

%up_right coordinates:
x_up_right = 181;
y_up_right = -91;

%down coordinates:
x_down = 0;
y_down = 181;

%down_left coordinates:
x_down_left= -181;
y_down_left = 91;

%down_right coordinates:
x_down_right= 181;
y_down_right = 91;

%Plotting coordinates
%Up (upper half of circle)
up_destrect = [x0-xsize/2+x_up, y0-ysize/2+ y_up, x0+xsize/2+x_up,y0+ysize/2+y_up];
up_left_destrect = [x0-xsize/2+x_up_left, y0-ysize/2+ y_up_left, x0+xsize/2+x_up_left,y0+ysize/2+y_up_left];
up_right_destrect = [x0-xsize/2+x_up_right, y0-ysize/2+ y_up_right, x0+xsize/2+x_up_right,y0+ysize/2+y_up_right];

%Down (lower half of circle)
down_destrect = [x0-xsize/2+x_down, y0-ysize/2+ y_down, x0+xsize/2+x_down,y0+ysize/2+y_down];
down_left_destrect = [x0-xsize/2+x_down_left, y0-ysize/2+ y_down_left, x0+xsize/2+x_down_left,y0+ysize/2+y_down_left];
down_right_destrect = [x0-xsize/2+x_down_right, y0-ysize/2+ y_down_right, x0+xsize/2+x_down_right,y0+ysize/2+y_down_right];

%Get instruction screen sizes
Screen('TextSize', windowPtr, FontSizeResp);
AdvanceScreenSize = Screen('TextBounds', windowPtr, 'When you are ready to begin the test block, press the space bar.');

%Task Instructions
InstructionScreen = ['\n\nIn each trial, you will see 6 images in the center of the screen.\n\n'...
    '\n\nOne of the images will be a cookie or a pie.\n\n'...
    '\n\nPlease indicate whether a cookie or a pie appears in each trial.\n\n'...
    '\n\nIf there is a cookie, press the Z key with your left index finger.\n\n'...
    '\n\nIf there is a pie, press the M key with your right index finger.\n\n'...
    '\n\nTo make sure you understand the task, we will give you a few practice trials.\n\n' ...
    '\n\nPress the space bar when you are ready to start the practice trials.'];

%Get slack time for the monitor
slack = Screen('GetFlipInterval', windowPtr)/2;

%Hide the cursor
HideCursor(windowPtr);

%=======================Present Task Instructions=========================%
Screen('TextSize', windowPtr, InstructionSizeText);
DrawFormattedText(windowPtr,InstructionScreen, 'center', 'center', TextColor);
Screen('Flip', windowPtr);
KeyBoardAdvance;%function so you can press the space bar to start practice trials

%====================Start Cycling through the runs ======================%

for Run = 1:nRuns
    
    
    %==========Create the trial and stimulus sequences for this run===========%
    
    %Goal: Create a first-order counterbalanced trial sequence of Cookie and Pie target types (2 trial types)
    
    if (Run==1) %practice trials
        
        nTrialsPerRun = nPracticeTrials;
        TrialSequence = Counterbalanced_Order_Odd_Even(nTrialTypes, nTrialsPerRun);
        
        
    else %training trials
        
        nTrialsPerRun = nTrainingTrials;
        
        %Shuffle trials
        TrialSequence = Counterbalanced_Order_Odd_Even(nTrialTypes, nTrialsPerRun);
        
    end
    
    Trial_Duration = 4.3*(ones(1,nTrialsPerRun));
    Fix_Value = (zeros(1,nTrialsPerRun));
    True_Trial_Duration = zeros(1, nTrialsPerRun);
    
    %====Convert trial sequence into stimulus sequence using nTargetStimuli====%
    %These are listed as separate cases
    %Odd Cookie trials -> cookie - cases 1 & 2
    OddCookieTrials = Shuffle([1*ones(1,(nTrialsPerRun/nUniqueStimuli)) 2*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %even Pie trials -> pie - cases 3 and 4
    EvenPieTrials = Shuffle([3*ones(1,(nTrialsPerRun/nUniqueStimuli)) 4*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %odd pie trials ->  Pierepeat - cases 5 & 6
    OddPieTrialsRepeat = Shuffle([5*ones(1,(nTrialsPerRun/nUniqueStimuli)) 6*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %Even Cookie trials -> Cookie repeat - cases 7 & 8
    EvenCookieTrialsRepeat = Shuffle([7*ones(1,(nTrialsPerRun/nUniqueStimuli)) 8*1*ones(1,(nTrialsPerRun/nUniqueStimuli))]);
    
    %=============Initialize the stimulus sequence for this run===============%
    
    StimulusSequence = zeros(1, nTrialsPerRun);
    
    %Create the stimulus sequence for this run
    for ThisTrial = 1: nTrialsPerRun
        
        if mod(ThisTrial,2) %odd-Cookie trial
            
            switch TrialSequence(ThisTrial)
                
                case 1%odd Cookie Cookie trials
                    
                    StimulusSequence(ThisTrial) = OddCookieTrials(1);
                    
                    OddCookieTrials = OddCookieTrials (2:end);
                    
                    
                    
                case 2%odd Cookie Pie trials
                    
                    StimulusSequence(ThisTrial) = OddPieTrialsRepeat(1);
                    
                    OddPieTrialsRepeat = OddPieTrialsRepeat(2:end);
                    
            end%end switch
            
        else
            
            switch TrialSequence(ThisTrial)
                
                case 1 %even Pie trials repeat
                    
                    
                    StimulusSequence(ThisTrial) = EvenPieTrials(1);
                    
                    EvenPieTrials = EvenPieTrials(2:end);
                    
                case 2 %even Cookie trials repeat
                    
                    StimulusSequence(ThisTrial) = EvenCookieTrialsRepeat(1);
                    
                    EvenCookieTrialsRepeat = EvenCookieTrialsRepeat (2:end);
                    
            end%switch
        end%if
        
    end%for%ThisTrial = 1: nTrialsPerRun
    
    %=============Initialize reward variables===============%

    %==================Compute Output Codes for Later=========================%
    
    %Need Task, Stimulus, CurrTrialType, Correct Response, and
    %Run for each trial
    
    Task = cell(nTrialsPerRun, 1);
    Stimulus = cell(nTrialsPerRun, 1);
    CurrTrialType = cell(nTrialsPerRun, 1);
    CorrectResponse = cell(nTrialsPerRun, 1);
    PrevTrialType = cell(nTrialsPerRun, 1);
    
    
    Start = [];
    Start_Fix = [];
    Array = [];
    Array_Feedback_Interval_Screen = [];
    Feedback = [];
    ITI_Fix = [];
    ITI_End = [];
    
    %Initialize Acc and PrevAcc
    Acc = cell(nTrialsPerRun, 1);
    PrevAcc = cell(nTrialsPerRun, 1);
    
    %Code the trials for the current run
    for ThisTrial = 1:nTrialsPerRun
        
        %Task
        if mod(ThisTrial, 2)
            
            %Odd trial
            Task{ThisTrial} = 'Search_Task_odd';
            
        else
            
            %Even trial
            Task{ThisTrial} = 'Search_Task_even';
        end
        
        %Stimulus & CorrectResponse
        switch StimulusSequence(ThisTrial)
            
            case {1,8}
                Stimulus{ThisTrial} = double('Cookie');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case {2,7}
                Stimulus{ThisTrial} = double('Pie');
                CorrectResponse{ThisTrial} = PossibleResponses{2};
            case {3,6}
                Stimulus{ThisTrial} = double('Cookie');
                CorrectResponse{ThisTrial} = PossibleResponses{1};
            case {4,5}
                Stimulus{ThisTrial} = double('Pie'); 
                CorrectResponse{ThisTrial} = PossibleResponses{2};
        end
        
        %TrialType
        
        %CurrTrialType
        if (StimulusSequence(ThisTrial) < 3)
            
            CurrTrialType{ThisTrial} = 'Cookie';
            
        elseif ( (StimulusSequence(ThisTrial) > 2) & (StimulusSequence(ThisTrial) < 7) )
            
            CurrTrialType{ThisTrial} = 'Pie';
            
        elseif ( (StimulusSequence(ThisTrial) > 6))
            
            CurrTrialType{ThisTrial} = 'Cookie';
            
            
        end
        
        %PrevTrialType
        if (ThisTrial == 1)
            PrevTrialType{ThisTrial} = 'None';
        else
            PrevTrialType{ThisTrial} = CurrTrialType{ThisTrial-1};
        end
        
    end%This trial
    
    %Code the run label (practice or test block number) & convert to cell
    run = cell(nRuns, 1);
    for iii = 1:nRuns
        if (iii == 1)
            run{iii} ='practice';
        else
            run{iii} = 'training';
        end
    end
    
    
    %============= Present the Stimuli for This Run ===================%
        
    if (Run > 1)%starting point of the training trials
        Screen('TextSize', windowPtr, FontSizeResp);
        Screen('DrawText', windowPtr, sprintf('When you are ready to continue, press the space bar to begin. \n\n'), x0-round(AdvanceScreenSize(3)/2), y0-round(AdvanceScreenSize(4)/2));
        Screen('Flip', windowPtr);
        KeyBoardAdvance;
        
    end
    
    for trial = 1:nTrialsPerRun
        fix_values = [0.400 0.500 0.600];
        Rdm = Shuffle(fix_values);
        Fix_Value(1,trial) = Rdm(1);
        True_Trial_Duration(1,trial) = Fix_Value(1,trial) + Trial_Duration(1,trial); %Build True_Trial_Duration one trial at a time.
        
    end
    
    %Draw a fixation point at the beginning of each run

    Screen('TextSize', windowPtr, FontSizeFix);
    DrawFormattedText(windowPtr, '+', 'center','center',TextColor);
    [Start_Time] = Screen('Flip', windowPtr);
    
    for i = 1:nTrialsPerRun
        
        Fix_Chosen = Fix_Value(i);
        
        Screen('TextSize',windowPtr, FontSizeFix);
        DrawFormattedText(windowPtr,'+', 'center','center',TextColor);
        
        [VBL_stimulus] = Screen('Flip', windowPtr, (Start_Time + StartFixationDuration + sum(True_Trial_Duration(1:i-1))- slack), 1);
        
        Start_Fix = [Start_Fix VBL_stimulus - Start_Time];
        
        trick = 0;
        
        while (GetSecs < (Start_Time + StartFixationDuration + sum(True_Trial_Duration(1:i-1))+ Fix_Value(i) - slack));
            
            trick = trick + 1;
            if (trick == 1)
                %randomizing the image selection and location
                image11 = Shuffle(image1);
                image22 = Shuffle(image2);
                image33 = Shuffle(image3);
                image44 = Shuffle(image4);
                image55 = Shuffle(image5);
                
                %read it in
                true_image11 = imread(strcat(Pathway,image11{1}));
                true_image22 = imread(strcat(Pathway,image22{1}));
                true_image33 = imread(strcat(Pathway,image33{1}));
                true_image44 = imread(strcat(Pathway,image44{1}));
                true_image55 = imread(strcat(Pathway,image55{1}));
                
                switch StimulusSequence(i)
                    
                    case{1,8}
                
                        color_shuffle_Cookie = Shuffle({true_image11 true_image55 true_image22 true_image33 true_image44 Cookie_image1});
                        
                        %Cookie trials
                        image1_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{1});
                        image2_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{2});
                        image3_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{3});
                        image4_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{4});
                        image5_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{5});
                        image6_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{6});
                        
                    case {2,7}
                        
                        color_shuffle_Cookie = Shuffle({true_image11 true_image55 true_image22 true_image33 true_image44 Cookie_image1});
                        
                        %Cookie trials
                        image1_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{1});
                        image2_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{2});
                        image3_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{3});
                        image4_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{4});
                        image5_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{5});
                        image6_Cookie= Screen('MakeTexture', windowPtr, color_shuffle_Cookie{6});
                        
                    case {3,6}
                        
                        color_shuffle_Pie = Shuffle({true_image11 true_image55 true_image22 true_image33 true_image44 Pie_image1});
                        
                        %Pie trials
                        image1_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{1});
                        image2_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{2});
                        image3_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{3});
                        image4_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{4});
                        image5_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{5});
                        image6_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{6});
                    
                    case {4,5}
                        
                        color_shuffle_Pie = Shuffle({true_image11 true_image55 true_image22 true_image33 true_image44 Pie_image1});
                        
                        %Pie trials
                        image1_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{1});
                        image2_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{2});
                        image3_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{3});
                        image4_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{4});
                        image5_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{5});
                        image6_Pie= Screen('MakeTexture', windowPtr, color_shuffle_Pie{6});
                end
                
                switch StimulusSequence(i)
                    
                    case {1,8}
                        
                        Screen('DrawTexture', windowPtr, image1_Cookie, [], up_destrect);
                        Screen('DrawTexture', windowPtr, image2_Cookie, [], up_left_destrect);
                        Screen('DrawTexture', windowPtr, image3_Cookie, [], up_right_destrect);
                        Screen('DrawTexture', windowPtr, image4_Cookie, [], down_destrect);
                        Screen('DrawTexture', windowPtr, image5_Cookie, [], down_left_destrect);
                        Screen('DrawTexture', windowPtr, image6_Cookie, [], down_right_destrect);
                        
                        
                    case {2,7}
                       
                        Screen('DrawTexture', windowPtr, image1_Cookie, [], up_destrect);
                        Screen('DrawTexture', windowPtr, image2_Cookie, [], up_left_destrect);
                        Screen('DrawTexture', windowPtr, image3_Cookie, [], up_right_destrect);
                        Screen('DrawTexture', windowPtr, image4_Cookie, [], down_destrect);
                        Screen('DrawTexture', windowPtr, image5_Cookie, [], down_left_destrect);
                        Screen('DrawTexture', windowPtr, image6_Cookie, [], down_right_destrect);
                           
                    case {3,6}
                        
                        Screen('DrawTexture', windowPtr, image1_Pie, [], up_destrect);
                        Screen('DrawTexture', windowPtr, image2_Pie, [], up_left_destrect);
                        Screen('DrawTexture', windowPtr, image3_Pie, [], up_right_destrect);
                        Screen('DrawTexture', windowPtr, image4_Pie, [], down_destrect);
                        Screen('DrawTexture', windowPtr, image5_Pie, [], down_left_destrect);
                        Screen('DrawTexture', windowPtr, image6_Pie, [], down_right_destrect);
                        
                    case {4,5}
                        
                        Screen('DrawTexture', windowPtr, image1_Pie, [], up_destrect);
                        Screen('DrawTexture', windowPtr, image2_Pie, [], up_left_destrect);
                        Screen('DrawTexture', windowPtr, image3_Pie, [], up_right_destrect);
                        Screen('DrawTexture', windowPtr, image4_Pie, [], down_destrect);
                        Screen('DrawTexture', windowPtr, image5_Pie, [], down_left_destrect);
                        Screen('DrawTexture', windowPtr, image6_Pie, [], down_right_destrect);
                        
                end%switch
            end
        end%while
        
        
        %Turn on the array and log the time it is presented
        [Array_Time] = Screen('Flip',windowPtr,(Start_Time + StartFixationDuration + sum(True_Trial_Duration(1:i-1)) + Fix_Value(i) - slack));
        
        Array = [Array Array_Time - Start_Time];
        
        %===================Check for response====================
        %Initialize variables for this trial
        KeyIsDown = 0;
        Secs = 0;
        KeyCode = [];
        RT =[];
        keys =[];
        nKeys = 0;
        
        %Check for a response for about MaxResponseInterval seconds
        %minus the time that has already passed
        
        while (GetSecs < (Start_Time + StartFixationDuration + sum(True_Trial_Duration(1:i-1)) + Fix_Value(i) - slack + Array_Duration ))
            
            %+ MaxResponseInterval)
            [KeyIsDown, Secs, KeyCode] = KbCheck;
            KeyButton = find(KeyCode, 1, 'first');
            
            if KeyIsDown %a key is down: record the key and time pressed
                nKeys = nKeys+1;
                RT(nKeys) = Secs-Array_Time;%RT is key press time - time when array appears
                keys{nKeys} = KbName(KeyButton);
                
                if strcmp(keys(nKeys),'ESCAPE')
                    Screen('CloseAll')
                    ShowCursor;
                    
                    if mac == 1
                        
                        ShowCursor;
                        
                    else
                        
                    ShowHideWinTaskbarMex(1); %Turn on the task bar.
                    
                    end
                    error('User pressed the escape key to abort');
                    return
                end
                
                %clear the keyboard buffer
                while KbCheck; end
                
            end%end if
            
        end %while
        
        %If no response is made
        if (nKeys == 0)
            
            nKeys = nKeys + 1;
            RT(nKeys) = 5000;
            keys{nKeys} = 'Omission';
            
        end%if
        
        %Only use the first key press to compute accuracy and RT
        nKeys = 1;
        
        %Calculate Acc
        %Correct
        if strcmp (keys(nKeys), CorrectResponse{i})
            Acc{i} = 'Correct';
        elseif strcmp(keys{nKeys}, 'Omission')
            Acc{i} = 'Omission';
        else
            Acc{i} = 'Error';
        end
        
        %Calculate PrevAcc
        if (i==1)
            PrevAcc{i} = 'None';
        else
            PrevAcc{i} = Acc{i-1};
        end
        
        %Clear the array by drawing the blank screen
        Screen('TextSize',windowPtr, FontSizeFix);
        DrawFormattedText(windowPtr, ' ', 'center', 'center', TextColor);
        [Blank_Screen] = Screen('Flip', windowPtr);
        Array_Feedback_Interval_Screen = [Array_Feedback_Interval_Screen Blank_Screen - Start_Time];
        
        while (GetSecs < (Start_Time + StartFixationDuration + sum(True_Trial_Duration(1:i-1)) + Fix_Value(i) - slack + Array_Duration + Array_Feedback_Interval))
        end
        
        %=======================clear blank screen with feedback===========
        if (strcmp(Acc{i}, 'Omission') | (strcmp (Acc{i}, 'Error')))
            
            Screen('TextSize',windowPtr, FontSizeError);
            DrawFormattedText(windowPtr,'Error','center', 'center', TextColor);
            
        end%if
        
        %Present feedback on screen
        [Feedback_Time] = Screen('Flip',windowPtr);
        
        Feedback = [Feedback Feedback_Time - Start_Time];
        
        
        while (GetSecs < (Start_Time + StartFixationDuration + sum(True_Trial_Duration(1:i-1))+ Fix_Value(i) - slack) + Array_Duration + Array_Feedback_Interval + Feedback_Duration);
        end
        
        
        %Clear the feedback screen by drawing the fixation cross
        Screen('TextSize',windowPtr, FontSizeFix);
        DrawFormattedText(windowPtr, ' ', 'center', 'center', TextColor);
        [Blank_Screen_End] = Screen('Flip',windowPtr);
        
        ITI_Fix = [ITI_Fix Blank_Screen_End - Start_Time];
        
        while (GetSecs < (Start_Time + StartFixationDuration + sum(True_Trial_Duration(1:i-1))+ Fix_Value(i) - slack) + Array_Duration + Array_Feedback_Interval + Feedback_Duration + ITI);
       
        end

        ITI_End = [ITI_End GetSecs - Start_Time];
        
        %=====================================Save Output After Each Trial=================%
        fprintf(fid, '%s\t %d\t %s\t %s\t %s\t %s\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %s\t %f\t %s\t %s\n', run{Run}, i, Task{i}, Stimulus{i}, CurrTrialType{i}, PrevTrialType{i}, Fix_Chosen, Start_Fix(i), Array(i), Array_Feedback_Interval_Screen(i),Feedback(i), ITI_Fix(i), ITI_End (i), keys{nKeys}, RT(nKeys), Acc{i}, PrevAcc{i});
        
    end%nTrialsPerRun
    
    
    tic;
    %================End of Run Details=================%
    
    %Draw a Fixation at the end of the run for a few seconds
    DrawFormattedText(windowPtr,' ');
    Screen('Flip',windowPtr);
    
    while (toc < EndFixationDuration)
    end
    
end%Run loop

%=========end of experiment details============
Screen('CloseAll')
fclose(fid);
ShowCursor;
ShowHideWinTaskbarMex(1);
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



