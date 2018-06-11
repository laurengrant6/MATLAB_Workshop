%set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 

%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', windowPtr);

% Get the center coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);

%Text Variables:

word1 = sprintf('Hello.');%the 1st word you want to present
word2 = sprintf('Hello!');%the 2nd word you want to present
word3 = sprintf('Hello?');%the 3rd word you want to present

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

 
%Present the words:

%word1
Screen('TextFont', windowPtr, TextFont1);%sets text in the font that you chose
Screen('TextSize',windowPtr, FontSizeText1);%sets text in the text size that you chose
DrawFormattedText(windowPtr, word1, word1_loc_x, word1_loc_y, TextColor1);%gets word ready to present

%word2
Screen('TextFont', windowPtr, TextFont2);%sets text in the font that you chose
Screen('TextSize',windowPtr, FontSizeText2);%sets text in the text size that you chose
DrawFormattedText(windowPtr, word2, word2_loc_x, word2_loc_y, TextColor2);%gets word ready to present

%word3
Screen('TextFont', windowPtr, TextFont3);%sets text in the font that you chose
Screen('TextSize',windowPtr, FontSizeText3);%sets text in the text size that you chose
DrawFormattedText(windowPtr, word3, word3_loc_x, word3_loc_y, TextColor3);%gets word ready to present

%presents the word on the screen
Screen('Flip',windowPtr);

%=============Wait for response and close the screen window==============%
 
KbStrokeWait;%wait for response

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor