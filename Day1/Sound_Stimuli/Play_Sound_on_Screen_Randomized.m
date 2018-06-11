%set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.

Pathway = '/Users/laurengrant/Dropbox/2018/MATLAB_WORKSHOP/Day1/Sound_Stimuli/Sample_Sounds/';

Shuffle(rng);
%=========Open a window on screen and set more screen parameters==========%

ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

%number of trials
nTrials = 5;

%Initialize some important sound parameters
InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [], 1, [0],16000, 1, [], 0.020);

%Load the auditory targets and distracters that participants will hear;
[sample_sound1 soundfreq] = audioread(strcat(Pathway,'sample_sound1.wav'));
[sample_sound2 soundfreq] = audioread(strcat(Pathway,'sample_sound2.wav'));
[sample_sound3 soundfreq] = audioread(strcat(Pathway,'sample_sound3.wav'));
[sample_sound4 soundfreq] = audioread(strcat(Pathway,'sample_sound4.wav'));

for ThisTrial = 1:nTrials
    
%shuffle sounds
Shuffle_Sound = Shuffle({sample_sound1' sample_sound2' sample_sound3' sample_sound4'});

%Present the sound on the screen
PsychPortAudio('FillBuffer', pahandle, Shuffle_Sound{1});

PsychPortAudio('Start', pahandle);%presents 1st sound on the screen

%=============Wait for response and close the screen window==============%

KbStrokeWait;%wait for response

end
     
sca%close the screen

ShowCursor(windowPtr);%show mouse cursor

            
