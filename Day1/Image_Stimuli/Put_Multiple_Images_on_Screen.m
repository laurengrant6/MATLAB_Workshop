 %set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
Pathway = '/Users/laurengrant/Dropbox/2018/MATLAB_WORKSHOP/Day1/Image_Stimuli/Sample_Images/';

%=========Open a window on screen and set more screen parameters==========%
 
ScreenNum = 0;%sets the screen as the main screen

[windowPtr, windowRect] = Screen('OpenWindow', ScreenNum, BackColor);%opens a window on the main screeen in the background color you chose

HideCursor(windowPtr);%hides the mouse cursor on the screen

%define center of screen
ScreenRect = Screen('Rect', windowPtr);
x0 = ScreenRect(3)/2;
y0 = ScreenRect (4)/2; 

%Control image size
ysize = 200;
xsize = 200;

%get coordinates for image location

%up coordinates: (0, -300)
x_up = 0;  
y_up = -300;

%up_left coordinates: (-150, -300)
x_up_left = -300;  
y_up_left = -150;

%up_right coordinates: (-150, 300)
x_up_right = 300;  
y_up_right = -150;

%down coordinates: (0,300)
x_down = 0;  
y_down = 300;

%down_left coordinates: (-300,150)
x_down_left= -300;  
y_down_left = 150;

%down_right coordinates: (300,150)
x_down_right= 300;  
y_down_right = 150;

%Plotting coordinates

up_destrect = [x0-xsize/2+x_up, y0-ysize/2+ y_up, x0+xsize/2+x_up,y0+ysize/2+y_up];%top

up_left_destrect = [x0-xsize/2+x_up_left, y0-ysize/2+ y_up_left, x0+xsize/2+x_up_left,y0+ysize/2+y_up_left];%top-left

up_right_destrect = [x0-xsize/2+x_up_right, y0-ysize/2+ y_up_right, x0+xsize/2+x_up_right,y0+ysize/2+y_up_right];%top-right

down_destrect = [x0-xsize/2+x_down, y0-ysize/2+ y_down, x0+xsize/2+x_down,y0+ysize/2+y_down];%bottom

down_left_destrect = [x0-xsize/2+x_down_left, y0-ysize/2+ y_down_left, x0+xsize/2+x_down_left,y0+ysize/2+y_down_left];%bottom-left

down_right_destrect = [x0-xsize/2+x_down_right, y0-ysize/2+ y_down_right, x0+xsize/2+x_down_right,y0+ysize/2+y_down_right];%bottom-right

%Make a variable with the image you want to present
Image1 = imread(strcat(Pathway,'sample_image1.jpg'));
Image2 = imread(strcat(Pathway,'sample_image2.jpg'));
Image3 = imread(strcat(Pathway,'sample_image3.jpg'));
Image4 = imread(strcat(Pathway,'sample_image4.jpg'));
Image5 = imread(strcat(Pathway,'sample_image5.jpg'));
Image6 = imread(strcat(Pathway,'sample_image6.jpg'));

%Make a texture of the image so it can be presented on the screen later

Image11 = Screen('MakeTexture', windowPtr,Image1);
Image22 = Screen('MakeTexture', windowPtr,Image2);
Image33 = Screen('MakeTexture', windowPtr,Image3);
Image44 = Screen('MakeTexture', windowPtr,Image4);
Image55 = Screen('MakeTexture', windowPtr,Image5);
Image66 = Screen('MakeTexture', windowPtr,Image6);

%Present the image on the screen 

Screen('DrawTexture', windowPtr, Image11, [],up_destrect); 

Screen('DrawTexture', windowPtr, Image22, [],up_left_destrect);

Screen('DrawTexture', windowPtr, Image33, [],up_right_destrect);

Screen('DrawTexture', windowPtr, Image44, [],down_destrect);

Screen('DrawTexture', windowPtr, Image55, [],down_left_destrect);

Screen('DrawTexture', windowPtr, Image66, [],down_right_destrect);

Screen('Flip',windowPtr);%presents the image on the screen

%=============Wait for response and close the screen window==============%
 
KbStrokeWait;%wait for response

sca%close the screen

ShowCursor(windowPtr);%show mouse cursor