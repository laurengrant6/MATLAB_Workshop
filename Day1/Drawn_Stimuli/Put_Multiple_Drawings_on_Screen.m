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
baseRect = [0 0 80 8 0];

%Midway points for each line: values are all in pixels
CenterX1 = -147.33-61;
CenterX2 = -8.66-61;
CenterX3 = 130.01-61;
CenterX4 = 268.68-61;
CenterY_Down = 50;

%oval variables
% Set the color of the oval
rectColor1 = [255 255 255];
rectColor2 = [0 0 255];
rectColor3 = [255 0 0];
rectColor4 = [255 255 0];

% For Ovals we set a miximum diameter up to which it is perfect for
maxDiameter = max(baseRect) * 1.01;

% Center the oval on the screen in four different positions
centeredRect1 = CenterRectOnPointd(baseRect, CenterX + CenterX1, CenterY);
centeredRect2 = CenterRectOnPointd(baseRect, CenterX + CenterX2, CenterY);
centeredRect3 = CenterRectOnPointd(baseRect, CenterX + CenterX3, CenterY);
centeredRect4 = CenterRectOnPointd(baseRect, CenterX + CenterX4, CenterY);

Screen('FillOval', windowPtr, rectColor1, centeredRect1, maxDiameter);
Screen('FillOval', windowPtr, rectColor2, centeredRect2, maxDiameter);
Screen('FillOval', windowPtr, rectColor3, centeredRect3, maxDiameter);
Screen('FillOval', windowPtr, rectColor4, centeredRect4, maxDiameter);

Screen('Flip', windowPtr);
KbWait;

%===========Wait for response and close the screen window==============%

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor 
