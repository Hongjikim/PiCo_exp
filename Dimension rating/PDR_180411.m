%% drawing x, y axis for PDR(PiCo Dimension Rating) and TEXT

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

% from fast
Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]); %screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
%theWindow = Screen('OpenWindow', 0, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', windowPtr, font);
% Screen('TextSize', windowPtr, fontsize);
% HideCursor;

% Draw texts!!  only ANSI works for Korean (from window notepad only, unicode and UTF doesn't work)
myFile = fopen('pico_story_kor_ANSI.txt', 'r');
myText = fgetl(myFile);
re_Text = reshape(myText,195,5)'; %150자 7페이지
doubleText = double(re_Text);
fclose(myFile);

%DrawFormattedText(window, text, xposition, yposition, color, wrapat, fliph, flipv, vspacing)
%DrawFormattedText(windowPtr, doubleText, 80, 90, 0, 70, 0, 0, 9.2);

for i = 1:5
    DrawFormattedText(windowPtr, doubleText(i,:), 80, 90, 0, 65, 0, 0, 9.2);
    
    for b= [200:210:620] % draw lines and arrows ((auto) - 2 lines and 2 arrows in one set)
        % starting_point (coordinate a,b -- the number of b equals the number of lines)
        a = 70;
        w = 1150; % width of line (horizontal length == length of x axis)
        l = 70; % length of line (vertical length == height of y axis)
        a_w= 10; % arrow width
        
        % making lines and arrows
        line1_2 = [a a+w a a;b b b-l b+l];
        arrow1_2 = [a a-a_w a a+a_w; b+l b+l-a_w b+l b+l-a_w];
        arrow3_4 = [a a-a_w a a+a_w; b-l b-l+a_w b-l b-l+a_w];
        
        all_lines = horzcat(line1_2, arrow1_2, arrow3_4);
        width = 5;      
        colors = 0;
        
        Screen('DrawLines', windowPtr, all_lines, width, colors); %, [xCenter,yCenter]
    end
    Screen('Flip', windowPtr)
    KbStrokeWait;
end

KbStrokeWait;
sca;