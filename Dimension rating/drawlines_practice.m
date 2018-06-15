%% close all
close all;
clearvars;
sca
%% drawLines.m
Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

xCenter = rect(3)/2;
yCenter = rect(4)/2;
width = 5;

lines = [-500 500 -500 500; -100 -100 100 100];
% colors = [255 0 0 0; 0 255 0 0 ; 0 0 255 0];
colors = 0;
Screen('DrawLines', windowPtr, lines, width, colors, [xCenter,yCenter]);
Screen('Flip',windowPtr);

%% my practice
Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

% xCenter = rect(3)/2;
% yCenter = rect(4)/2;
width = 5;

%lines = [-500 500 -500 500 -500 -500 -500 -500; -100 -100 100 100 150 50 -50 -150];
lines = [100 1100 100 1100 100 100 100 100; 350 350 150 150 100 200 300 400];
% colors = [255 0 0 0; 0 255 0 0 ; 0 0 255 0];
colors = 0;
Screen('DrawLines', windowPtr, lines, width, colors); %, [xCenter,yCenter]
Screen('Flip',windowPtr);


%% arrow

Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

% create a triangle

head   = [ 100, 200 ]; % coordinates of head
width  = 20;           % width of arrow head
%     head   = [ -500, 150 ]; % coordinates of head
%     width  = 20;           % width of arrow head
points = [ head-[width,0]         % left corner
    head+[width,0]         % right corner
    head-[0,width] ];      % vertex
Screen('FillPoly', windowPtr,[255,0,0], points);

Screen('Flip',windowPtr);
%% practice _ 4 lines, 4 arrows (filled arrows)
Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

% xCenter = rect(3)/2;
% yCenter = rect(4)/2;
width = 5;

%lines = [-500 500 -500 500 -500 -500 -500 -500; -100 -100 100 100 150 50 -50 -150];
lines = [100 1100 100 1100 100 100 100 100; 350 350 150 150 100 200 300 400];
% colors = [255 0 0 0; 0 255 0 0 ; 0 0 255 0];
colors = 0;
Screen('DrawLines', windowPtr, lines, width, colors); %, [xCenter,yCenter]

% create a triangle 1

head   = [ 100, 100 ]; % coordinates of head
width  = 20;           % width of arrow head
points = [ head-[width,0]         % left corner
    head+[width,0]         % right corner
    head-[0,width] ];      % vertex
Screen('FillPoly', windowPtr,[255,0,0], points);

% create a triangle 2

head   = [ 100, 200 ]; % coordinates of head
width  = 20;           % width of arrow head
points = [ head-[width,0]         % left corner
    head+[width,0]         % right corner
    head+[0,width] ];      % vertex
Screen('FillPoly', windowPtr,[255,0,0], points);

% create a triangle 3

head   = [ 100, 300 ]; % coordinates of head
width  = 20;           % width of arrow head
points = [ head-[width,0]         % left corner
    head+[width,0]         % right corner
    head-[0,width] ];      % vertex
Screen('FillPoly', windowPtr,[255,0,0], points);

% create a triangle 4

head   = [ 100, 400 ]; % coordinates of head
width  = 20;           % width of arrow head
points = [ head-[width,0]         % left corner
    head+[width,0]         % right corner
    head+[0,width] ];      % vertex
Screen('FillPoly', windowPtr,[255,0,0], points);

Screen('Flip',windowPtr);

%% not.. final _ 4 lines, 4 arrows (unfilled arrows)
Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

% xCenter = rect(3)/2;
% yCenter = rect(4)/2;
width = 5;

lines = [100 1100 100 1100 100 100 100 100; 500 500 200 200 100 300 400 600];
% colors = [255 0 0 0; 0 255 0 0 ; 0 0 255 0];
colors = 0;
Screen('DrawLines', windowPtr, lines, width, colors); %, [xCenter,yCenter]

lines_arrow = [100 90 100 110 100 90 100 110 100 90 100 110 100 90 100 110 ; 100 110 100 110 300 290 300 290 400 410 400 410 600 590 600 590];
% colors = [255 0 0 0; 0 255 0 0 ; 0 0 255 0];
% red = [255, 0, 0]; 
colors = 0;
Screen('DrawLines', windowPtr, lines_arrow, width, colors); %, [xCenter,yCenter]

Screen('Flip',windowPtr);
%% real final (manual) - 4 lines, 4 arrows 

Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

% xCenter = rect(3)/2;
% yCenter = rect(4)/2;

lines = [100 1200 100 1200 100 100 100 100; 500 500 200 200 100 300 400 600];
lines_arrow = [100 90 100 110 100 90 100 110 100 90 100 110 100 90 100 110 ; 100 110 100 110 300 290 300 290 400 410 400 410 600 590 600 590];
all_lines = horzcat(lines,lines_arrow)
width = 5;
colors = 0;

Screen('DrawLines', windowPtr, all_lines, width, colors); %, [xCenter,yCenter]
Screen('Flip',windowPtr);

%% real final (auto) - 4 lines, 4 arrows 

Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

% starting_point
a = 100;
for b= [200:300:500]
    
    w = 1100; % width of line (horizontal length == length of x axis)
    l = 100; % length of line (vertical length == height of y axis)
    a_w= 10; % arrow width
    
    % making lines and arrows
    line1_2 = [a a+w a a;b b b-l b+l];
    arrow1_2 = [a a-a_w a a+a_w; b+l b+l-a_w b+l b+l-a_w];
    arrow3_4 = [a a-a_w a a+a_w; b-l b-l+a_w b-l b-l+a_w];
    
    % lines = [100 1200 100 1200 100 100 100 100; 500 500 200 200 100 300 400 600];
    % lines_arrow = [100 90 100 110 100 90 100 110 100 90 100 110 100 90 100 110 ; 100 110 100 110 300 290 300 290 400 410 400 410 600 590 600 590];
    % all_lines = horzcat(lines,lines_arrow)
    all_lines = horzcat(line1_2, arrow1_2, arrow3_4);
    width = 5;
    colors = 0;
    
    Screen('DrawLines', windowPtr, all_lines, width, colors); %, [xCenter,yCenter]
    
end

Screen('Flip',windowPtr);
%% turning off
% KbStrokeWait;
sca;