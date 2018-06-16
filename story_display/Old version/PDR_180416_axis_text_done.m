%% version
% draw_axix_PDR ¿Ï¼º
%% to do
% make function of  1) ANSI file load 2)reshape and 3) double

%% drawing x, y axis for PDR(PiCo Dimension Rating) and TEXT
      
% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

Screen('Preference', 'SkipSyncTests', 1);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]); %screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', theWindow, font);
% Screen('TextSize', windowPtr, fontsize);
% HideCursor;

the_text = input('***** Write the exact file name(Ex. pico_story.txt):', 's'); %Copy_of_pico_story_kor_ANSI.txt
[k, double_text] = make_text_PDR(the_text);

%DrawFormattedText(window, text, xposition, yposition, color, wrapat, fliph, flipv, vspacing)

for ii = 1:k
    DrawFormattedText(theWindow, double_text(ii,:), 85, 75, 0, 65, 0, 0, 14.5);
    draw_axis_PDR([200 550]);
    Screen('Flip', theWindow)
    KbStrokeWait;
end
%KbStrokeWait;
sca;