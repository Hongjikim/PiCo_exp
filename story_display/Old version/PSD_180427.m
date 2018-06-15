%% PSD (PiCo story display - in fMRI)

%% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

Screen('Preference', 'SkipSyncTests', 1);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]); 
%screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', theWindow, font);
% Screen('TextSize', windowPtr, fontsize);
% HideCursor;

% load Text file
myFile = fopen('pico_story_kor_ANSI.txt', 'r');
% the_text = input('***** Write the exact file name(Ex. pico_story.txt):', 's'); %pico_story_kor_ANSI.txt
% myFile = fopen(the_text)
myText = fgetl(myFile);
space_loc = find(myText==32); % location of space ' '
% doubleText = zeros(length(space_loc),length(myText));
% doubleText(1,:) = double(myText);
doubleText = double(myText);
fclose(myFile);

% make the story into word pieces

wc = 1; %word_count
for i = 1:length(doubleText)
    if find(space_loc == i) == 1
        j = length(doubleText) - i;
        doubleText(wc+1,j) = doubleText(i+1:end);
        % doubleText(wc,i+1:end) = [];
        wc = wc + 1;
    end
end

% re_Text = reshape(myText,195,5)'; %150자 7페이지

%DrawFormattedText(window, text, xposition, yposition, color, wrapat, fliph, flipv, vspacing)
%DrawFormattedText(windowPtr, doubleText, 80, 90, 0, 70, 0, 0, 9.2);

for i = 1:5
    DrawFormattedText(windowPtr, doubleText(i,:), 80, 90, 0, 65, 0, 0, 9.2);
    
    
    end
    Screen('Flip', windowPtr)
    KbStrokeWait;
end

KbStrokeWait;
sca;

the_text = input('***** Write the exact file name(Ex. pico_story.txt):', 's'); %Copy_of_pico_story_kor_ANSI.txt

%[k, double_text] = make_text_PDR(the_text);

%DrawFormattedText(window, text, xposition, yposition, color, wrapat, fliph, flipv, vspacing)


sTime = GetSecs;
if GetSecs - sTime > 10
end


