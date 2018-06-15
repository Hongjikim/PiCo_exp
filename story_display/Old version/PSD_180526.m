%data�� run, text file name ����
% SETUP: time
letter_time =  0.15*4;   %0.15*4
period_time = 3;
comma_time = 1.5;
base_time = 0;

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

% data save
basedir = '/Users/hongji/Dropbox/MATLAB_hongji/github_hongji/Pico_v0/story_display/';
cd(basedir); addpath(genpath(basedir));

subject_ID = input('Subject num?(PIC-000):');
%subject_ID = trim(subject_ID);
%subject_number = input('Subject number?:', 's');
run_number = input('run number?:');

savedir = fullfile(basedir, 'Data_Pico');
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = subject_ID;
data.datafile = fullfile(savedir, [subjdate, '_PICO_', sprintf('%.3d', subject_ID), '_run', sprintf('%.2d', run_number), '.mat']);
data.version = 'PICO_v0_05-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

save(data.datafile, 'data');

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
%myFile = fopen('sample_1.txt', 'r'); %fopen('pico_story_kor_ANSI.txt', 'r');
Filename = input('***** Write the exact file name(Ex. pico_story.txt):', 's');
myFile = fopen(Filename,'r'); %fopen('pico_story_kor_ANSI.txt', 'r');
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
        fprintf('��ǥ ��ġ: %s \n', myText(comma_loc(j)-15:comma_loc(j)))
        sca
        break
    end
    for k = 1:length(ending_loc)
        if sum(ending_loc(k) + 1 == space_loc) == 0
            disp ('*** error in contents! ***')
            fprintf('��ħǥ ��ġ: %s', myText(ending_loc(k)-15:ending_loc(k)))
            sca
            return
        end
    end
end

duration = zeros(my_length,2);

for i = 1:my_length
    letter_num = space_loc(i+1) - space_loc(i);
    if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
        duration(i,1) = 2; % comma
        duration(i,2) = letter_time + base_time + comma_time + abs(time_interval(i));
        data.dat{i}.word_type = 'comma';
        
    elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
        duration(i,1) = 3; % period
        duration(i,2) = letter_time + base_time + period_time + abs(time_interval(i));
        data.dat{i}.word_type = 'period';
    else
        duration(i,1) = 1; % nothing
        duration(i,2) = letter_time + base_time + abs(time_interval(i));
        data.dat{i}.word_type = 'nothing';
    end
    
end

fprintf('\n*************************\n\ntotal time: %.2f seconds \n', sum(duration(:,2)));
fprintf('total words: %.f words \n\n*************************\n', my_length);

data.total_time = sum(duration(:,2));

% Start display
start_msg = double('�����ϰڽ��ϴ�. \n\n ȭ���� �߾ӿ� �ܾ ��Ÿ�� �����̴� ȭ�鿡 �������ּ���. \n\n ���� ���뿡 �ִ��� �������ּ���. ') ;
DrawFormattedText(theWindow, start_msg, 'center', 'center', 0);
Screen('Flip', theWindow);

sTime_2 = GetSecs;
while GetSecs - sTime_2 < 5 % when the story is starting, wait for 5 seconds.
end

data.dat{1}.loop_start_time_stamp = GetSecs;

for i = 1:my_length
    sTime = GetSecs;
    data.dat{i}.text_start_time_stamp = sTime;
    msg = doubleText(space_loc(i)+1:space_loc(i+1));
    data.dat{i}.msg = char(msg);
    letter_num = space_loc(i+1) - space_loc(i);
    DrawFormattedText(theWindow, msg, 'center', 'center', 0);
    Screen('Flip', theWindow);
    while GetSecs - sTime < letter_time + base_time + abs(time_interval(i)) %0.31 %duration(i,2)
    end
    data.dat{i}.text_end_time_stamp = GetSecs;
    if duration(i,1) > 1
        DrawFormattedText(theWindow, ' ', 'center', 'center', 0);
        Screen('Flip', theWindow);
        while GetSecs - sTime < duration(i,2)
            %duration(i,2) - (letter_time + base_time + abs(time_interval(i)))
        end
        data.dat{i}.blank_end_time_stamp = GetSecs;
    end
    if rem(i,5) == 0
        save(data.datafile, 'data', '-append');
    end
end

data.dat{1}.loop_end_time_stamp = GetSecs;


while GetSecs - sTime < 5
    % when the story is done, wait for 5 seconds. (in Blank)
end

data.endtime_getsecs = GetSecs;
save(data.datafile, 'data', '-append');

end_msg = double('���Դϴ�.') ;
DrawFormattedText(theWindow, end_msg, 'center', 'center', 0);
Screen('Flip', theWindow);

KbStrokeWait;
sca;