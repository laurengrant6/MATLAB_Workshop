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

%Add Timing Variables
Start_Duration = 2;
Drawing_Duration = .250; 
Interval_Duration = .500;
Drawing2_Duration = .250;
Trial_Duration = 2.5;
slack = Screen('GetFlipInterval', windowPtr)/2;

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

%Have a time period right before the oval appears
Screen('DrawText', windowPtr,'');
[Start_Time] = Screen('Flip',windowPtr);

for ThisTrial = 1:nTrials
    
Shuffle_Oval_Color1 = Shuffle({rectColor1 rectColor2 rectColor3 rectColor4});

Shuffle_Oval_Position1 = Shuffle({centeredRect1 centeredRect2 centeredRect3 centeredRect4});

Shuffle_Oval_Color2 = Shuffle({rectColor1 rectColor2 rectColor3 rectColor4});

Shuffle_Oval_Position2 = Shuffle({centeredRect1 centeredRect2 centeredRect3 centeredRect4});

% For Ovals we set a maximum diameter     
maxDiameter = max(baseRect) * 1.01;

Screen('FillOval', windowPtr, Shuffle_Oval_Color1{1}, Shuffle_Oval_Position1{1}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color1{2}, Shuffle_Oval_Position1{2}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color1{3}, Shuffle_Oval_Position1{3}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color1{4}, Shuffle_Oval_Position1{4}, maxDiameter);

%Go through a loop until we're ready for the next trial
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack))
end

%present the first drawing on the screen
[Drawing_Time] = Screen('Flip',windowPtr, (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack));

%go through a loop until we're ready to take it off the screen
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration);
end

%present the interval: this is a blank screen
Screen('DrawText', windowPtr,' ');
Screen('Flip',windowPtr);

%Go through a loop for the rest of the interval between drawings
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration + Interval_Duration);
end

%clear the interval with the next set of drawings
Screen('FillOval', windowPtr, Shuffle_Oval_Color2{1}, Shuffle_Oval_Position2{1}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color2{2}, Shuffle_Oval_Position2{2}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color2{3}, Shuffle_Oval_Position2{3}, maxDiameter);
Screen('FillOval', windowPtr, Shuffle_Oval_Color2{4}, Shuffle_Oval_Position2{4}, maxDiameter);

[Drawing2_Time] = Screen('Flip',windowPtr, (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration + Interval_Duration);

%Go through a loop for a while until we're ready to clear the second
%drawing
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration + Interval_Duration + Drawing2_Duration);
end

%present the second interval: this is a blank screen
Screen('DrawText', windowPtr,' ');
[End_Time] = Screen('Flip',windowPtr);

end

%===========Wait for response and close the screen window==============%
sca;

ShowCursor(windowPtr);%show mouse cursor 
