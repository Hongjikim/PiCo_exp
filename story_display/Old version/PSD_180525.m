% SETUP: time
letter_time =  0.15*4;   %0.15*4
period_time = 3;
comma_time = 1.5;
base_time = 0;

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

% Screen setting
bgcolor = 100;

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]; %0 0 1920 1080

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

fontsize = 30;

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];

% %Screen('Preference', 'SkipSyncTests', 1);
% theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen(FULL)

%Screen(theWindow, 'FillRect', bgcolor, window_rect);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font = 'AppleGothic';
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, 28);
% HideCursor;


% TEXT file - check if it's formatted

% load Text file
myFile = fopen('sample_1.txt', 'r'); %fopen('pico_story_kor_ANSI.txt', 'r');
% the_text = input('***** Write the exact file name(Ex. pico_story.txt):', 's');
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

time_interval = randn(1,my_length)*.4; % *0.1
%mean(time_interval);

for j = 1:length(comma_loc)
    if sum(comma_loc(j) + 1 == space_loc) == 0
        disp('*** error in contents! ***')
        fprintf('쉼표 위치: %s \n', myText(comma_loc(j)-15:comma_loc(j)))
        sca
        break
    end
    for k = 1:length(ending_loc)
        if sum(ending_loc(k) + 1 == space_loc) == 0
            disp ('*** error in contents! ***')
            fprintf('마침표 위치: %s', myText(ending_loc(k)-15:ending_loc(k)))
            sca
            return
        end
    end
end

% time calculation

time_cal_comma = 0;
time_cal_ending = 0;
time_cal_space = 0;

for i = 1:my_length
    letter_num = space_loc(i+1) - space_loc(i);
    if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
        time_cal_comma = time_cal_comma + letter_time + base_time + comma_time + abs(time_interval(i));
    elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
        time_cal_ending = time_cal_ending + letter_time + base_time + period_time + abs(time_interval(i));
    else
        time_cal_space = time_cal_space + letter_time + base_time + abs(time_interval(i));
    end
end

time_cal = time_cal_comma + time_cal_ending + time_cal_space;
fprintf('total time: %.2f seconds \n', time_cal);

% Start display
start_msg = double('시작하겠습니다. \n\n 화면의 중앙에 단어가 나타날 예정이니 화면에 집중해주세요. \n\n 글의 내용에 최대한 몰입해주세요. ') ;
DrawFormattedText(theWindow, start_msg, 'center', 'center', 0);
Screen('Flip', theWindow);

sTime_2 = GetSecs;
while GetSecs - sTime_2 < 5% when the story is starting, wait for 5 seconds.
end

duration = zeros(my_length,2);

for i = 1:my_length
    sTime = GetSecs;
    msg = doubleText(space_loc(i)+1:space_loc(i+1));
    letter_num = space_loc(i+1) - space_loc(i);
    DrawFormattedText(theWindow, msg, 'center', 'center', 0);
    Screen('Flip', theWindow);
    if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
        duration(i,1) = 2; % comma
        duration(i,2) = letter_time + base_time + comma_time + abs(time_interval(i));
        
    elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
        duration(i,1) = 3; % period
        duration(i,2) = letter_time + base_time + period_time + abs(time_interval(i));
        
    else
        duration(i,1) = 1; % nothing
        duration(i,2) = letter_time + base_time + abs(time_interval(i));
        
    end
    
    while GetSecs - sTime < letter_time + base_time + abs(time_interval(i)) %0.31 %duration(i,2)
    end
    
    if duration(i,1) > 1
        DrawFormattedText(theWindow, ' ', 'center', 'center', 0);
        Screen('Flip', theWindow);
        
        while GetSecs - sTime < duration(i,2)
        end
    end
    
end

while GetSecs - sTime < 5
    % when the story is done, wait for 5 seconds. (in Blank)
end


end_msg = double('끝입니다.') ;
DrawFormattedText(theWindow, end_msg, 'center', 'center', 0);
Screen('Flip', theWindow);

KbStrokeWait;
sca;

