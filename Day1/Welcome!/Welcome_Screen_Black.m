%set the display parameters

BackColor = [0 0 0];%sets the background color

TextColor = [255 255 255];%sets the text color

TextFont = 'Arial Unicode MS';%sets the text font

FontSizeText = 80;%sets the text font size

 Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 

%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

Screen('TextFont', windowPtr, TextFont);%sets all text in the font that you chose


%Make a variable with the word you want to present

Hello = sprintf('Hello');


%Check the horizontal and vertical size of the word

Screen('TextSize',windowPtr, FontSizeText);%makes the word the text size that you chose

Word_Size = Screen('TextBounds', windowPtr, 'Hello');%gets the size parameters for the word


%Present the word on the screen

DrawFormattedText(windowPtr, Hello, 'Center', 'Center', TextColor);%gets the word ready to present on screen with the parameters you want


Screen('Flip',windowPtr);%presents the word on the screen

%=============Wait for response and close the screen window==============%
 
KbStrokeWait;%wait for response

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor

            
