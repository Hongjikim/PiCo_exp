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
myFile = fopen('story_1.txt', 'r'); %fopen('pico_story_kor_ANSI.txt', 'r');
% the_text = input('***** Write the exact file name(Ex. pico_story.txt):', 's'); %pico_story_kor_ANSI.txt
myText = fgetl(myFile);
fclose(myFile);
doubleText = double(myText);

if doubleText(end) ~= 32
    doubleText= [doubleText 32];
end

space_loc = find(doubleText==32); % location of space ' '
comma_loc = find(doubleText==44);
ending_loc = find(doubleText==46);

space_loc = [0 space_loc];
my_length = length(space_loc)-1;

time_interval = randn(1,my_length)*0.1;
%mean(time_interval);

for j = 1:length(comma_loc)
    if sum(comma_loc(j) + 1 == space_loc) == 0
        disp('*** error in contents! ***')
        fprintf('��ǥ ��ġ: %s \n', myText(comma_loc(j)-10:comma_loc(j)))
        sca;
        break
    end
    for k = 1:length(ending_loc)
        if sum(ending_loc(k) + 1 == space_loc) == 0
            disp ('*** error in contents! ***')
            fprintf('��ħǥ ��ġ: %s', myText(ending_loc(k)-10:ending_loc(k)))
            sca;
            return
        end
    end
    
    time_cal = length(comma_loc)*0.34 + length(ending_loc)*0.9 + length(space_loc)*0.31 + sum(abs(time_interval));
    
    sTime_2 = GetSecs;
    
    start_msg = double('�����ϰڽ��ϴ�. \n\n ȭ���� �߾ӿ� �ܾ ��Ÿ�� �����̴� ȭ�鿡 �������ּ���. \n\n ���� ���뿡 �ִ��� �������ּ���. ') ;
    DrawFormattedText(theWindow, start_msg, 'center', 'center', 0);
    Screen('Flip', theWindow)
    
    while GetSecs - sTime_2 < 10
    end
    
    for i = 1:my_length
        sTime = GetSecs;
        msg = doubleText(space_loc(i)+1:space_loc(i+1));
        DrawFormattedText(theWindow, msg, 'center', 'center', 0);
        Screen('Flip', theWindow);
        if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
            while GetSecs - sTime < (0.65) + abs(time_interval(i)) %0.65
            end
        elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
            while GetSecs - sTime < (1.2) + abs(time_interval(i)) %1.2
            end
        else
            while GetSecs - sTime < (0.31) + abs(time_interval(i)) %0.31
            end
        end
    end
    
    while GetSecs - sTime < 2
    end
    
    end_msg = double('���Դϴ�.') ;
    DrawFormattedText(theWindow, end_msg, 'center', 'center', 0);
    Screen('Flip', theWindow)
    KbStrokeWait;
    sca;
    
end
