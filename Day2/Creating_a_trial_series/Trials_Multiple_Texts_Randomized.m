%set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
Shuffle(rng);%helps with randomization: rng stands for "random number generator"   

%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

%Number of trials
nTrials = 5;

%Add Timing Variables
Start_Duration = 1;
Drawing_Duration = 2; 
Interval_Duration = .500;
Drawing2_Duration = 2;
Trial_Duration = 4.5;
slack = Screen('GetFlipInterval', windowPtr)/2;       

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', windowPtr);

% Get the center coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);

%Text Variables:

word1 = sprintf('welcome');%the 1st word you want to present
word2 = sprintf('bienvenidos');%the 2nd word you want to present
word3 = sprintf('willkommen');%the 3rd word you want to present

TextColor1 = [255 255 255];%sets the text color for word1
TextColor2 = [0 255 255];%sets the text color for word2
TextColor3 = [255 255 0];%sets the text color for word3

TextFont1 = 'Arial Unicode MS';%sets the text font for word1
TextFont2 = 'Times';%sets the text font for word2
TextFont3 = 'Calibri';%sets the text font for word3

FontSizeText1 = 80;%sets the text font size for word1
FontSizeText2 = 60;%sets the text font size for word2
FontSizeText3 = 70;%sets the text font size for word3

%choose the word location

%word1
word1_loc_x = 'center';
word1_loc_y = screenYpixels*.25;
 
%word2
word2_loc_x = 'center';
word2_loc_y = 'center';

%word3
word3_loc_x = 'center';
word3_loc_y = screenYpixels*.75;

%Have a time period right before the oval appears
Screen('DrawText', windowPtr,'');
[Start_Time] = Screen('Flip',windowPtr);

for ThisTrial = 1:nTrials

%for the first drawing
Shuffle_words1 = Shuffle({word1 word2 word3});

Shuffle_Text_Color1 = Shuffle({TextColor1 TextColor2 TextColor3});

Shuffle_Text_Font1 = Shuffle({TextFont1 TextFont2 TextFont3});

Shuffle_Font_Size1 = Shuffle({FontSizeText1 FontSizeText2 FontSizeText3});

Shuffle_Word_Loc_X1 = Shuffle({'center' 'center' 'center'});
Shuffle_Word_Loc_Y1 = Shuffle({screenYpixels*.25 'center' screenYpixels*.75});
 
%for the second drawing
Shuffle_words2 = Shuffle({word1 word2 word3});

Shuffle_Text_Color2 = Shuffle({TextColor1 TextColor2 TextColor3});

Shuffle_Text_Font2 = Shuffle({TextFont1 TextFont2 TextFont3});

Shuffle_Font_Size2 = Shuffle({FontSizeText1 FontSizeText2 FontSizeText3});

Shuffle_Word_Loc_X2 = Shuffle({'center' 'center' 'center'});
Shuffle_Word_Loc_Y2 = Shuffle({screenYpixels*.25 'center' screenYpixels*.75});
 
%Present the words:

%word1
Screen('TextFont', windowPtr, Shuffle_Text_Font1{1});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size1{1});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words1{1}, Shuffle_Word_Loc_X1{1}, Shuffle_Word_Loc_Y1{1}, Shuffle_Text_Color1{1});%gets word ready to present

%word2
Screen('TextFont', windowPtr, Shuffle_Text_Font1{2});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size1{2});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words1{2}, Shuffle_Word_Loc_X1{2}, Shuffle_Word_Loc_Y1{2}, Shuffle_Text_Color1{2});%gets word ready to present

%word3
Screen('TextFont', windowPtr, Shuffle_Text_Font1{3});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size1{3});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words1{3}, Shuffle_Word_Loc_X1{3}, Shuffle_Word_Loc_Y1{3}, Shuffle_Text_Color1{3});%gets word ready to present

%Go through a loop until we're ready for the next trial
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack))
end

[Drawing_Time] = Screen('Flip',windowPtr, (Start_Time + Start_Duration));

%go through a loop until we're ready to take it off the screen
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration);
end

%present the interval: this is a blank screen
Screen('DrawText', windowPtr,' ');
Screen('Flip',windowPtr);

%Go through a loop for the rest of the interval between drawings
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration + Interval_Duration);
end

%word1
Screen('TextFont', windowPtr, Shuffle_Text_Font2{1});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size2{1});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words2{1}, Shuffle_Word_Loc_X2{1}, Shuffle_Word_Loc_Y2{1}, Shuffle_Text_Color2{1});%gets word ready to present

%word2
Screen('TextFont', windowPtr, Shuffle_Text_Font2{2});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size2{2});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words2{2}, Shuffle_Word_Loc_X2{2}, Shuffle_Word_Loc_Y2{2}, Shuffle_Text_Color2{2});%gets word ready to present

%word3
Screen('TextFont', windowPtr, Shuffle_Text_Font2{3});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size2{3});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words2{3}, Shuffle_Word_Loc_X2{3}, Shuffle_Word_Loc_Y2{3}, Shuffle_Text_Color2{3});%gets word ready to present

[Drawing_Time2] = Screen('Flip',windowPtr, (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration + Interval_Duration);

%Go through a loop for a while until we're ready to clear the second
%drawing
while (GetSecs < (Start_Time + Start_Duration + Trial_Duration*(ThisTrial-1)-slack) + Drawing_Duration + Interval_Duration + Drawing2_Duration);
end

%present the second interval: this is a blank screen
Screen('DrawText', windowPtr,' ');
[End_Time] = Screen('Flip',windowPtr);
end


%=============Wait for response and close the screen window==============%
 

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor