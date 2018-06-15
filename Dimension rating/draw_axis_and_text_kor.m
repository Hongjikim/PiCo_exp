%% drawing x, y axis for PDR(PiCo Dimension Rating)
% final (auto) - 2 lines and 2 arrows in one set
% global korean

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb bodymap recsize barsize rec; % rating scale

% Screen('Preference', 'SkipSyncTests', 1);
% [windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);
% Screen('Preference', 'TextEncodingLocale', 'ko_KR.UTF-8');

% from fast
Screen('Preference', 'SkipSyncTests', 1); 
theWindow = Screen('OpenWindow', 0, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize);
HideCursor;

% starting_point (coordinate a,b -- the number of b equals the number of lines)
% a = 100;
% for b= [200:210:620]
%     
%     w = 1100; % width of line (horizontal length == length of x axis)
%     l = 70; % length of line (vertical length == height of y axis)
%     a_w= 10; % arrow width
%     
%     % making lines and arrows
%     line1_2 = [a a+w a a;b b b-l b+l];
%     arrow1_2 = [a a-a_w a a+a_w; b+l b+l-a_w b+l b+l-a_w];
%     arrow3_4 = [a a-a_w a a+a_w; b-l b-l+a_w b-l b-l+a_w];
%     
%     % lines = [100 1200 100 1200 100 100 100 100; 500 500 200 200 100 300 400 600];
%     % lines_arrow = [100 90 100 110 100 90 100 110 100 90 100 110 100 90 100 110 ; 100 110 100 110 300 290 300 290 400 410 400 410 600 590 600 590];
%     % all_lines = horzcat(lines,lines_arrow)
%     all_lines = horzcat(line1_2, arrow1_2, arrow3_4);
%     width = 5;
%     colors = 0;
%     
%     Screen('DrawLines', windowPtr, all_lines, width, colors); %, [xCenter,yCenter]
%     
% end

% Draw texts!!
% myFile = fopen('pico_story_kor_ANSI.txt', 'r');
% myText = fgetl(myFile);
% fclose(myFile);

%DrawFormattedText(window, text, xposition, yposition, color, wrapat, fliph, flipv, vspacing)
%DrawFormattedText(windowPtr, char(myText), 110, 105, 0, 105, 0, 0, 9); 
% font ='NanumBarunGothic';
msg='��';
Screen('TextFont', windowPtr, font);
DrawFormattedText(windowPtr, double(msg), 'center', 'center', 0, 105, 0, 0, 9); 
Screen('Flip', windowPtr);

KbStrokeWait;
sca;