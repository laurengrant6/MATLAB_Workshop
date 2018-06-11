 %set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
Pathway = '/Users/laurengrant/Dropbox/2018/MATLAB_WORKSHOP/Day2/Sample_Images/';

%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

%Add Timing Variables
Start_Duration = 1;
Drawing_Duration = 2;     

%Make a variable with the image you want to present
Image = imread(strcat(Pathway,'sample_image1.jpg'));

%Make a texture of the image so it can be presented on the screen later
Image1 = Screen('MakeTexture', windowPtr, Image);

%Have a time period right before the image appears: this is your starting
%point
Screen('DrawText', windowPtr,'');
[Start_Time] = Screen('Flip',windowPtr);

%Present the image on the screen 
Screen('DrawTexture', windowPtr, Image1);

[Drawing_Time] = Screen('Flip',windowPtr, (Start_Time + Start_Duration));

while (GetSecs < Drawing_Time + Drawing_Duration)
end

%=============Wait and then close the screen window==============%

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor

            
