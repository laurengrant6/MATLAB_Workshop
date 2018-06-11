 %set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
Shuffle(rng);          
%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

% Get the centre coordinate of the window
[CenterX, CenterY] = RectCenter(windowRect);

% Make a base Rect for centering oval: also determines size
baseRect = [0 0 80 80];

%number of trials
nTrials = 5;

%Midway points for each line: values are all in pixels
CenterX1 = -147.33-61;
CenterX2 = -8.66-61;
CenterX3 = 130.01-61;
CenterX4 = 268.68-61;
CenterY_Down = 50;

%oval variables:

% Set the color of the oval
rectColor1 = [255 255 255];
rectColor2 = [0 0 255];
rectColor3 = [255 0 0];     
rectColor4 = [255 255 0];     
 
% Center the oval on the screen in four different positions
centeredRect1 = CenterRectOnPointd(baseRect, CenterX + CenterX1, CenterY);
centeredRect2 = CenterRectOnPointd(baseRect, CenterX + CenterX2, CenterY);
centeredRect3 = CenterRectOnPointd(baseRect, CenterX + CenterX3, CenterY);
centeredRect4 = CenterRectOnPointd(baseRect, CenterX + CenterX4, CenterY);

for ThisTrial = 1:nTrials
    
Shuffle_Oval_Color = Shuffle({rectColor1 rectColor2 rectColor3 rectColor4});

Shuffle_Oval_Position = Shuffle({centeredRect1 centeredRect2 centeredRect3 centeredRect4});

% For Ovals we set a maximum diameter     
maxDiameter = max(baseRect) * 1.01;

Screen('FillOval', windowPtr, Shuffle_Oval_Color{1}, Shuffle_Oval_Position{1}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color{2}, Shuffle_Oval_Position{2}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color{3}, Shuffle_Oval_Position{3}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color{4}, Shuffle_Oval_Position{4}, maxDiameter);

Screen('Flip', windowPtr);
KbStrokeWait;
     
end            

%===========Wait for response and close the screen window==============%
sca;

ShowCursor(windowPtr);%show mouse cursor 
