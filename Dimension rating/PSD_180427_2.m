% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

Screen('Preference', 'SkipSyncTests', 1);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);
%screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
% font ='NanumBarunGothic';
font = 'AppleGothic';
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, 32);
% HideCursor;

% load Text file
myFile = fopen('pico_story_kor_ANSI.txt', 'r');
% the_text = input('***** Write the exact file name(Ex. pico_story.txt):', 's'); %pico_story_kor_ANSI.txt
myText = fgetl(myFile);
space_loc = find(myText==32); % location of space ' '
doubleText = double(myText);
fclose(myFile);
space_loc = [0 space_loc];
my_length = length(space_loc)-1;
time_interval = randn(1,my_length)*0.1;
%mean(time_interval);

for i = 1:my_length
    sTime = GetSecs;
    msg = doubleText(space_loc(i)+1:space_loc(i+1));
    DrawFormattedText(theWindow, msg, 'center', 'center', 0);
    Screen('Flip', theWindow);
    while GetSecs - sTime < (0.31) + abs(time_interval)
    end
end


end_msg = double('끝입니다.') ;
DrawFormattedText(theWindow, end_msg, 'center', 'center', 0);
Screen('Flip', theWindow)
KbStrokeWait;
sca;
