%% version
% draw_axix_PDR 완성
%% to do
% make function of  1) ANSI file load 2)reshape and 3) double

%% drawing x, y axis for PDR(PiCo Dimension Rating) and TEXT
      
% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

% from fast
Screen('Preference', 'SkipSyncTests', 1);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]); %screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
%theWindow = Screen('OpenWindow', 0, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', theWindow, font);
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

for ii = 1:5
    DrawFormattedText(theWindow, doubleText(ii,:), 80, 75, 0, 65, 0, 0, 9.2);
    draw_axis_PDR([200 550]);
    Screen('Flip', theWindow)
    KbStrokeWait;
end
KbStrokeWait;
sca;