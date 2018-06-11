 %set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
Pathway = '/Users/laurengrant/Dropbox/2018/MATLAB_WORKSHOP/Day1/Image_Stimuli/Sample_Images/';

%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

%Make a variable with the image you want to present

Image = imread(strcat(Pathway,'sample_image1.jpg'));

%Make a texture of the image so it can be presented on the screen later

Image1 = Screen('MakeTexture', windowPtr, Image);

%Present the image on the screen

Screen('DrawTexture', windowPtr, Image1);

Screen('Flip',windowPtr);%presents the image on the screen

%=============Wait for response and close the screen window==============%
 
KbStrokeWait;%wait for response

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor

            
