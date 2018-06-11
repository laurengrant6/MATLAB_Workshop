  %set the display parameters

BackColor = [0 0 0];%sets the background color

Screen('Preference', 'SkipSyncTests', 1);%ensures compatability for development purposes. Be sure to de-activate for a real experiment.
 
Pathway = '/Users/laurengrant/Dropbox/2018/MATLAB_WORKSHOP/Day1/Image_Stimuli/Visual_Search_Images/';

Shuffle(rng);

%=========Open a window on screen and set more screen parameters==========%
 
%Set ScreenNum as MainScreen(0)
ScreenNum = 0;
%Open a window & hide the task bar and cursor
[windowPtr] = Screen('OpenWindow', ScreenNum, BackColor);

%define center of screen
ScreenRect = Screen('Rect', windowPtr);
x0 = ScreenRect(3)/2; 
y0 = ScreenRect (4)/2;

%Number of trials
nTrials = 5;
     
%Stimuli Size
ysize = 200;
xsize = 200;

%introduce the two options of bar orientation for each distracter
yellow_circ = {'yellow_45_right.jpg' 'yellow_45_left.jpg'};
white_circ = {'white_45_right.jpg' 'white_45_left.jpg'};
orange_circ = {'orange_45_right.jpg' 'orange_45_left.jpg'};
cyan_circ = {'cyan_45_right.jpg' 'cyan_45_left.jpg'};
blue_circ = {'blue_45_right.jpg' 'blue_45_left.jpg'};
red_circ = {'red_horiz.jpg' 'red_vert.jpg'};

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

%Plotting coordinates
%Up (upper half of circle)
up_destrect = [x0-xsize/2+x_up, y0-ysize/2+ y_up, x0+xsize/2+x_up,y0+ysize/2+y_up];
up_left_destrect = [x0-xsize/2+x_up_left, y0-ysize/2+ y_up_left, x0+xsize/2+x_up_left,y0+ysize/2+y_up_left];
up_right_destrect = [x0-xsize/2+x_up_right, y0-ysize/2+ y_up_right, x0+xsize/2+x_up_right,y0+ysize/2+y_up_right];

%Down (lower half of circle)
down_destrect = [x0-xsize/2+x_down, y0-ysize/2+ y_down, x0+xsize/2+x_down,y0+ysize/2+y_down];
down_left_destrect = [x0-xsize/2+x_down_left, y0-ysize/2+ y_down_left, x0+xsize/2+x_down_left,y0+ysize/2+y_down_left];
down_right_destrect = [x0-xsize/2+x_down_right, y0-ysize/2+ y_down_right, x0+xsize/2+x_down_right,y0+ysize/2+y_down_right];

for ThisTrial = 1:nTrials
    
%Shuffle the two options for each color
yellow = Shuffle(yellow_circ);
white = Shuffle(white_circ);
orange = Shuffle(orange_circ);
cyan = Shuffle(cyan_circ);
blue = Shuffle(blue_circ);
red = Shuffle(red_circ);

%choose one of the options for each color and read it in
true_yellow = imread(strcat(Pathway,yellow{1}));
true_white = imread(strcat(Pathway,white{1}));
true_orange = imread(strcat(Pathway,orange{1}));
true_cyan = imread(strcat(Pathway,cyan{1}));
true_blue = imread(strcat(Pathway,blue{1}));
true_red = imread(strcat(Pathway,red{1}));
  
%now shuffle all the colors
color_shuffle = Shuffle({true_yellow true_white true_orange true_cyan true_blue true_red});

%make textures for a random color with a random bar orientation
circ1= Screen('MakeTexture', windowPtr, color_shuffle{1});
circ2= Screen('MakeTexture', windowPtr, color_shuffle{2});
circ3= Screen('MakeTexture', windowPtr, color_shuffle{3});
circ4= Screen('MakeTexture', windowPtr, color_shuffle{4});
circ5= Screen('MakeTexture', windowPtr, color_shuffle{5});
circ6= Screen('MakeTexture', windowPtr, color_shuffle{6});

%Draw images
%Up (upper half of circle)
Screen('DrawTexture', windowPtr, circ1, [], up_destrect);
Screen('DrawTexture', windowPtr, circ2, [], up_left_destrect);
Screen('DrawTexture', windowPtr, circ3, [], up_right_destrect);

%Down (lower half of circle)
Screen('DrawTexture', windowPtr, circ4, [], down_destrect);
Screen('DrawTexture', windowPtr, circ5, [], down_left_destrect);
Screen('DrawTexture', windowPtr, circ6, [], down_right_destrect);

Screen('Flip', windowPtr);
KbStrokeWait;%wait for response     

end  
sca;

