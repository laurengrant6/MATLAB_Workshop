 %set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

% Get the centre coordinate of the window
[CenterX, CenterY] = RectCenter(windowRect);

% Make a base Rect of 200 by 250 pixels for centering oval
baseRect = [0 0 100 100];

%oval variables
% Set the color of the oval
rectColor = [255 255 255];

% For Ovals we set a miximum diameter up to which it is perfect for
maxDiameter = max(baseRect) * 1.01;

% Center the oval on the screen
centeredRect1 = CenterRectOnPointd(baseRect, CenterX, CenterY);

Screen('FillOval', windowPtr, rectColor, centeredRect1, maxDiameter);

Screen('Flip', windowPtr);
KbWait;

%===========Wait for response and close the screen window==============%

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor 
