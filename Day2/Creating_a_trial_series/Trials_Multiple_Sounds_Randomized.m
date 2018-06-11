%set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.

Pathway = '/Users/laurengrant/Dropbox/2018/MATLAB_WORKSHOP/Day2/Sample_Stimuli/Sample_Sounds/';

Shuffle(rng);

%=========Open a window on screen and set more screen parameters==========%

ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

%number of trials
nTrials = 5;

%Add Timing Variables
Start_Duration = 2;
Drawing_Duration = .500; 
Interval_Duration = .250;
Drawing2_Duration = .500;
Trial_Duration = 2.5;
slack = Screen('GetFlipInterval', windowPtr)/2;

%fixation variable
Text_Color = [255 255 255];
Font_Size = 40;

%Initialize some important sound parameters
InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [], 1, [0],16000, 1, [], 0.020);

%Load the auditory targets and distracters that participants will hear;
[sample_sound1 soundfreq] = audioread(strcat(Pathway,'sample_sound1.wav'));
[sample_sound2 soundfreq] = audioread(strcat(Pathway,'sample_sound2.wav'));
[sample_sound3 soundfreq] = audioread(strcat(Pathway,'sample_sound3.wav'));
[sample_sound4 soundfreq] = audioread(strcat(Pathway,'sample_sound4.wav'));

%Have a time period right before the oval appears
Screen('DrawText', windowPtr,'');
[Start_Time] = Screen('Flip',windowPtr);

for ThisTrial = 1:nTrials
    
%shuffle sounds
Shuffle_Sound1 = Shuffle({sample_sound1' sample_sound2' sample_sound3' sample_sound4'});
Shuffle_Sound2 = Shuffle({sample_sound1' sample_sound2' sample_sound3' sample_sound4'});

%Present the sound on the screen
PsychPortAudio('FillBuffer', pahandle, Shuffle_Sound1{1});

%Go through a loop until we're ready for the next trial
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack))
end

PsychPortAudio('Start', pahandle);%presents 1st sound on the screen
Drawing_Time = GetSecs;
 
%go through a loop until we're ready to take it off the screen
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration);
end

%present the interval: this is a blank screen
DrawFormattedText(windowPtr,' ', 'center','center',Text_Color);
Screen('Flip',windowPtr);

%Go through a loop for the rest of the interval between drawings
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration + Interval_Duration);
end

%Present the second sound on the screen
PsychPortAudio('FillBuffer', pahandle, Shuffle_Sound2{1});
PsychPortAudio('Start', pahandle);%presents 2nd sound on the screen
Drawing_Time2 = GetSecs;

%Go through a loop for a while until we're ready to clear the second
%drawing
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration + Interval_Duration + Drawing2_Duration);
end

%present the second interval: this is a blank screen
Screen('TextSize',windowPtr, Font_Size);
DrawFormattedText(windowPtr,' ', 'center','center',Text_Color);
[End_Time] = Screen('Flip',windowPtr);

end
     
sca%close the screen

ShowCursor(windowPtr);%show mouse cursor

            
