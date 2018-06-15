% Clear the workspace and the screen
close all;
clearvars; 
sca
%% Screen setup
Screen('Preference', 'SkipSyncTests', 1);
% % Here we call some default settings for setting up Psychtoolbox
% PsychDefaultSetup(2);
% 
% % Get the screen numbers
% screens = Screen('Screens');

screens = Screen('Screens');

%% Select the external screen if it is present, else revert to the native
% screen
screenNumber = min(screens);

%% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2 ;
%% Open an on screen window and color it grey
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
[wPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);
%[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);


screen_mode = 'middle'; %'full';


%% Set the blend funciton for the screen
% Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% if ~show_cursor       
%     HideCursor;
% end

window_info = Screen('Resolution', window_num);
switch screen_mode
    case 'full'
        window_rect = [0 0 window_info.width window_info.height]; % full screen
    case 'semifull'
        window_rect = [0 0 window_info.width-100 window_info.height-100]; % a little bit distance
    case 'middle'
        window_rect = [0 0 window_info.width/2 window_info.height/2];
    case 'small'
        window_rect = [0 0 400 300]; % in the test mode, use a little smaller screen
end

% size
W = window_rect(3); % width
H = window_rect(4); % height

lb1 = W/4; % rating scale left bounds 1/4
rb1 = (3*W)/4; % rating scale right bounds 3/4

lb2 = W/3; % new bound for or not
rb2 = (W*2)/3;

scale_W = (rb1-lb1).*0.1; % Height of the scale (10% of the width)

anchor_lms = [0.014 0.061 0.172 0.354 0.533].*(rb1-lb1)+lb1;

% font
fontsize = 33;
font = 'Helvetica';
%font = 'NanumBarunGothic';
Screen('Preference', 'TextEncodingLocale', 'ko_KR.UTF-8');

% color
bgcolor = 50;
white = 255;
red = [158 1 66];
orange = [255 164 0];

% % open window
% theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
% %Screen('TextFont', theWindow, font);
% Screen('TextSize', theWindow, fontsize);
% 
% % get font parameter
% [~, ~, wordrect0, ~] = DrawFormattedText(theWindow, double(' '), lb1-30, H/2+scale_W+40, bgcolor);
% [~, ~, wordrect1, ~] = DrawFormattedText(theWindow, double('ÄÚ'), lb1-30, H/2+scale_W+40, bgcolor);
% [~, ~, wordrect2, ~] = DrawFormattedText(theWindow, double('p'), lb1-30, H/2+scale_W+40, bgcolor);
% [~, ~, wordrect3, ~] = DrawFormattedText(theWindow, double('^'), lb1-30, H/2+scale_W+40, bgcolor);
% [space.x space.y korean.x korean.y alpnum.x alpnum.y special.x special.y] = deal(wordrect0(3)-wordrect0(1), wordrect0(4)-wordrect0(2), ...
%     wordrect1(3)-wordrect1(1), wordrect1(4)-wordrect1(2), wordrect2(3)-wordrect2(1), wordrect2(4)-wordrect2(2), ...
%     wordrect3(3)-wordrect3(1), wordrect3(4)-wordrect3(2));
% 
% Screen(theWindow, 'FillRect', bgcolor, window_rect); % Just getting information, and do not show the scale.
% Screen('Flip', theWindow);

%%  Lets write three lines of text, the first and second right after one
% another, and the third with a line space in between. To add line spaces
% we use the special characters "\n"
line1 = 'Hello World';
line2 = '\n\n This is the second line';
line3 = '\n\n This is the third line';

% Draw all the text in one go
Screen('TextSize', window, 70);
DrawFormattedText(window, [line1 line2 line3],...
    'center', screenYpixels * 0.25, white);

% Draw lines
lines = [-300 300 -300 300; -50 -50 50 50];
colors = [255 0 0 255; 0 255 255 0 ; 0 0 0 0];
Screen('DrawLines',window,lines,10,colors,[xCenter,yCenter],0);

% Flip to the screen
Screen('Flip', window);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo
KbStrokeWait;

% Clear the screen
sca;

