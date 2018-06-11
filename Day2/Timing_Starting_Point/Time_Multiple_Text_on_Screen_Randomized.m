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

for ThisTrial = 1:nTrials
    
Shuffle_words = Shuffle({word1 word2 word3});

Shuffle_Text_Color = Shuffle({TextColor1 TextColor2 TextColor3});

Shuffle_Text_Font = Shuffle({TextFont1 TextFont2 TextFont3});

Shuffle_Font_Size = Shuffle({FontSizeText1 FontSizeText2 FontSizeText3});

Shuffle_Word_Loc_X = Shuffle({'center' 'center' 'center'});
Shuffle_Word_Loc_Y = Shuffle({screenYpixels*.25 'center' screenYpixels*.75});
 
%Present the words:

%word1
Screen('TextFont', windowPtr, Shuffle_Text_Font{1});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size{1});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words{1}, Shuffle_Word_Loc_X{1}, Shuffle_Word_Loc_Y{1}, Shuffle_Text_Color{1});%gets word ready to present

%word2
Screen('TextFont', windowPtr, Shuffle_Text_Font{2});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size{2});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words{2}, Shuffle_Word_Loc_X{2}, Shuffle_Word_Loc_Y{2}, Shuffle_Text_Color{2});%gets word ready to present

%word3
Screen('TextFont', windowPtr, Shuffle_Text_Font{3});%sets text in the font that you chose
Screen('TextSize',windowPtr, Shuffle_Font_Size{3});%sets text in the text size that you chose
DrawFormattedText(windowPtr, Shuffle_words{3}, Shuffle_Word_Loc_X{3}, Shuffle_Word_Loc_Y{3}, Shuffle_Text_Color{3}    );%gets word ready to present

[Drawing_Time] = Screen('Flip',windowPtr, (Start_Time + Start_Duration));

while (GetSecs < Drawing_Time + Drawing_Duration)
end   

end


%=============Wait for response and close the screen window==============%
 

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor