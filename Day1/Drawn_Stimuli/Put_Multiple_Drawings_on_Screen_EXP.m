 %set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

% Get the centre coordinate of the window
[CenterX, CenterY] = RectCenter(windowRect);

% Make a base Rect of 200 by 250 pixels
baseRect = [0 0 52 52];

%Number of trials
nTrials = 5;
     
%line variables
LineWidth = 6;
LineColor = [255 255 255];

CenterX_Start = -171.33-61;
CenterX_Start2 = -34.66-61;
CenterX_Start3 = 104.01-61;
CenterX_Start4 = 242.68-61;

CenterX_End = -121.33-61;
CenterX_End2= 17.34-61;
CenterX_End3= 156.01-61;
CenterX_End4= 294.68-61;

%Midway points for each line
CenterX1 = -147.33-61;
CenterX2 = -8.66-61;
CenterX3 = 130.01-61;
CenterX4 = 268.68-61;
CenterY_Down = 50;

%oval variables
% Set the color of the oval
rectColor = [255 255 255];

% For Ovals we set a miximum diameter up to which it is perfect for
maxDiameter = max(baseRect) * 1.01;

% Center the oval on the screen
centeredRect1 = CenterRectOnPointd(baseRect, CenterX + CenterX1, CenterY);
centeredRect2 = CenterRectOnPointd(baseRect, CenterX + CenterX2, CenterY);
centeredRect3 = CenterRectOnPointd(baseRect, CenterX + CenterX3, CenterY);
centeredRect4 = CenterRectOnPointd(baseRect, CenterX + CenterX4, CenterY);

for ThisTrial = 1:nTrials
    
%Shuffle oval position
Shuffle_Oval_Pos = Shuffle({centeredRect1 centeredRect2 centeredRect3 centeredRect4});

%draw lines and ovals
Screen('DrawLine',windowPtr, LineColor, CenterX + CenterX_Start, CenterY+ CenterY_Down, CenterX + CenterX_End , CenterY+ CenterY_Down, LineWidth);
Screen('DrawLine',windowPtr, LineColor, CenterX + CenterX_Start2, CenterY+ CenterY_Down, CenterX + CenterX_End2, CenterY+ CenterY_Down, LineWidth);
Screen('DrawLine',windowPtr, LineColor, CenterX + CenterX_Start3, CenterY+ CenterY_Down, CenterX + CenterX_End3, CenterY+ CenterY_Down, LineWidth);
Screen('DrawLine',windowPtr, LineColor, CenterX + CenterX_Start4, CenterY+ CenterY_Down, CenterX + CenterX_End4 , CenterY+ CenterY_Down, LineWidth);
Screen('FillOval', windowPtr, rectColor, Shuffle_Oval_Pos{1}, maxDiameter);

Screen('Flip', windowPtr);
KbWait;

Screen('DrawText', windowPtr,' ');  
[Flip_Time] = Screen('Flip', windowPtr);

Screen('DrawText', windowPtr,' ');
Screen('Flip',windowPtr, Flip_Time + 0.200);

end  
%=============Wait for response and close the screen window==============%

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor 
