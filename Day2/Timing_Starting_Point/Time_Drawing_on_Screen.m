 %set the display parameters

BackColor = [0 0 0];%sets the background color

%turn off MATLAB warnings
warning('off')

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

%Add Timing Variables
Start_Duration = 1;
Drawing_Duration = 1;

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

%Have a time period right before the oval appears
Screen('DrawText', windowPtr,'');
[Start_Time] = Screen('Flip',windowPtr);

%Have the time period when the oval appears
Screen('FillOval', windowPtr, rectColor, centeredRect1, maxDiameter);
[Drawing_Time] = Screen('Flip',windowPtr, (Start_Time + Start_Duration));

while (GetSecs < Drawing_Time + Drawing_Duration)
end

%Have a time period right after the oval appears
Screen('DrawText', windowPtr,' ');
[End_Time] = Screen('Flip', windowPtr);

%===========Wait and then close the screen window==============%

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor 
