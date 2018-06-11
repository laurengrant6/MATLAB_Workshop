 %set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
Pathway = '/Users/laurengrant/Dropbox/2018/MATLAB_WORKSHOP/Day1/Image_Stimuli/Sample_Images/';

Shuffle(rng);%helps with randomization: rng is "random number generator"

%=========Open a window on screen and set more screen parameters==========%
 
%Set ScreenNum as MainScreen(0)
ScreenNum = 0;

%Open a window & hide the task bar and cursor
[windowPtr] = Screen('OpenWindow', ScreenNum, BackColor);

%define center of screen
ScreenRect = Screen('Rect', windowPtr);
x0 = ScreenRect(3)/2;
y0 = ScreenRect (4)/2;

%number of trials
nTrials = 5;

%Add Timing Variables
Start_Duration = 1;
Drawing_Duration = 2;     

%Stimuli Size
ysize = 200;
xsize = 200;

%read in images
image11 = imread(strcat(Pathway,'sample_image1.jpg'));
image22 = imread(strcat(Pathway,'sample_image2.jpg'));
image33 = imread(strcat(Pathway,'sample_image3.jpg'));
image44 = imread(strcat(Pathway,'sample_image4.jpg'));
image55 = imread(strcat(Pathway,'sample_image5.jpg'));
image66 = imread(strcat(Pathway,'sample_image6.jpg'));

%Coordinates
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

%3.2_Plotting coordinates
%Up (upper half of circle)
up_destrect = [x0-xsize/2+x_up, y0-ysize/2+ y_up, x0+xsize/2+x_up,y0+ysize/2+y_up];
up_left_destrect = [x0-xsize/2+x_up_left, y0-ysize/2+ y_up_left, x0+xsize/2+x_up_left,y0+ysize/2+y_up_left];
up_right_destrect = [x0-xsize/2+x_up_right, y0-ysize/2+ y_up_right, x0+xsize/2+x_up_right,y0+ysize/2+y_up_right];

%Down (lower half of circle)
down_destrect = [x0-xsize/2+x_down, y0-ysize/2+ y_down, x0+xsize/2+x_down,y0+ysize/2+y_down];
down_left_destrect = [x0-xsize/2+x_down_left, y0-ysize/2+ y_down_left, x0+xsize/2+x_down_left,y0+ysize/2+y_down_left];
down_right_destrect = [x0-xsize/2+x_down_right, y0-ysize/2+ y_down_right, x0+xsize/2+x_down_right,y0+ysize/2+y_down_right];

for ThisTrial = 1:nTrials
    
%now shuffle all the images
image_shuffle = Shuffle({image11 image22 image33 image44 image55 image66});

%make textures for all randomized images
im1= Screen('MakeTexture', windowPtr, image_shuffle{1});
im2= Screen('MakeTexture', windowPtr, image_shuffle{2});
im3= Screen('MakeTexture', windowPtr, image_shuffle{3});
im4= Screen('MakeTexture', windowPtr, image_shuffle{4});
im5= Screen('MakeTexture', windowPtr, image_shuffle{5});
im6= Screen('MakeTexture', windowPtr, image_shuffle{6});

%Draw images
%Up (upper half of circle)
Screen('DrawTexture', windowPtr, im1, [], up_destrect);
Screen('DrawTexture', windowPtr, im2, [], up_left_destrect);
Screen('DrawTexture', windowPtr, im3, [], up_right_destrect);

%Down (lower half of circle)
Screen('DrawTexture', windowPtr, im4, [], down_destrect);
Screen('DrawTexture', windowPtr, im5, [], down_left_destrect);
Screen('DrawTexture', windowPtr, im6, [], down_right_destrect);

[Drawing_Time] = Screen('Flip',windowPtr, (Start_Time + Start_Duration));

while (GetSecs < Drawing_Time + Drawing_Duration)
end   

end  
sca;
