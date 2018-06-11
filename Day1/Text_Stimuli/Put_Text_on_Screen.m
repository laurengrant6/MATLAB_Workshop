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

word1 = sprintf('Hello!');%the word you want to present

TextColor1 = [255 255 255];%sets the text color for word1

TextFont1 = 'Arial Unicode MS';%sets the text font for word1

FontSizeText1 = 80;%sets the text font size for word1

%choose the word location
word1_loc_x = 'center';
word1_loc_y = 'center';

%sets text in the font that you chose
Screen('TextFont', windowPtr, TextFont1);

%sets text in the text size that you chose
Screen('TextSize',windowPtr, FontSizeText1);

%gets the word ready to present on screen with the parameters you want
DrawFormattedText(windowPtr, word1, word1_loc_x, word1_loc_y, TextColor1);

%presents the word on the screen
Screen('Flip',windowPtr);

%=============Wait for response and close the screen window==============%
 
KbStrokeWait;%wait for response

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor