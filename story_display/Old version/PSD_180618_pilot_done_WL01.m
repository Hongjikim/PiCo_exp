%data에 run, text file name 들어가기 (file name error, duration필요)
% story text 미리 넣어놓으면 run number만 쳐도 나올 수 있게
% SETUP: time
text_color = 255;
text_size = 42; %38?
 %클수록 화면 작아짐.

% data save
% basedir = '/Users/hongji/Dropbox/MATLAB_hongji/github_hongji/Pico_v0/story_display/';
basedir = 'C:\Users\Cocoanlab_WL01\Desktop\story_display'
cd(basedir); addpath(genpath(basedir));

subject_ID = input('Subject ID? (P001_KJH):', 's');
% %subject_ID = trim(subject_ID);
% %subject_number = input('Subject number?:', 's');
run_number = input('run number?:');
%subject_ID = 'test_OJW';
%run_number = 4;
savedir = fullfile(basedir, 'Data_PSD');
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = subject_ID;
data.datafile = fullfile(savedir, [subjdate, '_PICO_', subject_ID, '_run', sprintf('%.2d', run_number), '.mat']);
data.version = 'PICO_v0_05-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

if exist(data.datafile, 'file')
    cont_or_not = input(['\nYou type the run number that is inconsistent with the data previously saved.', ...
        '\nWill you go on with your run number that typed just before?', ...
        '\n1: Yes, continue with typed run number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Breaked.')
    elseif cont_or_not == 1
        save(data.datafile, 'data');
    end
else
    save(data.datafile, 'data');
end

Filename = {'sample_1.txt', 'sample_2.txt'} ;
% Filename = {'story_7_YSE.txt', 'story_10_PKH.txt'} ;
% Filename(2) = 'sample_2.txt';
% Filename = input('***** Write the exact file name(Ex. pico_story.txt):', 's');

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect % lb tb recsize barsize rec; % rating scale
global letter_time period_time comma_time base_time window_ratio
% display time
letter_time =  0.15*4;   %0.15*4
period_time = 3;
comma_time = 1.5;
base_time = 0;

window_ratio = 1 ;

% Screen setting
bgcolor = 100;

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/window_ratio; %0 0 1920 1080

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

fontsize = 24; %30

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];


for s_num = 1:2
    [duration, doubleText, my_length, space_loc, comma_loc, ending_loc, time_interval, data] ...
        = text_duration(Filename, s_num, data);
end
data.text_file_name{1} = Filename{1};
data.text_file_name{2} = Filename{2};

ready = input(['Check the time. Ready to start with full screen? \n', ...
    '\n1: Yes, continue  ,   2: No,  I`ll break.\n:  ']);
if ready == 2
    error('Breaked.')
end

% %Screen('Preference', 'SkipSyncTests', 1);
% theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen(FULL)

%Screen(theWindow, 'FillRect', bgcolor, window_rect);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], window_rect/window_ratio);%[0 0 2560/2 1440/2]
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font = 'AppleGothic';
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, text_size);
% HideCursor;

% TEXT file - check if it's formatted

% load Text file
for s_num = 1:2
    [duration, doubleText, my_length, space_loc, comma_loc, ending_loc, time_interval, data] ...
        = text_duration(Filename, s_num, data);
    data.total_time{s_num} = sum(duration(:,2));
    
    
    if s_num == 1
        % WAITING FOR INPUT FROM THE SCANNER
        while (1)
            [~,~,keyCode] = KbCheck;
            
            if keyCode(KbName('s'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment('manual');
            end
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            ready_prompt = double('참가자가 준비되었으면, \n 이미징을 시작합니다 (s).');
            DrawFormattedText(theWindow, ready_prompt,'center', textH, white);
            Screen('Flip', theWindow);
            
        end
        
        % FOR DISDAQ 10 SECONDS
        
        % gap between 's' key push and the first stimuli (disdaqs: data.disdaq_sec)
        % 4 seconds: "시작합니다..."
        data.runscan_starttime = GetSecs; % run start timestamp
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        sTime_3 = GetSecs;
        while GetSecs - sTime_3 < 4 % wait 4 seconds for disdaq
        end
        % Blank
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        
        % Start display
        start_msg = double('첫 번째 이야기를 시작하겠습니다. \n\n 화면의 중앙에 단어가 나타날 예정이니 화면에 집중해주세요. \n\n 글의 내용에 최대한 몰입해주세요. ') ;
        DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        sTime_2 = GetSecs;
        while GetSecs - sTime_2 < 5 % when the story is starting, wait for 5 seconds.
        end
        
        
    else
        % Start display
        start_msg = double('두 번째 이야기를 시작하겠습니다. \n\n 화면의 중앙에 단어가 나타날 예정이니 화면에 집중해주세요. \n\n 글의 내용에 최대한 몰입해주세요. ') ;
        DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        sTime_2 = GetSecs;
        while GetSecs - sTime_2 < 5 % when the story is starting, wait for 5 seconds.
        end
    end
    
    data.loop_start_time{s_num} = GetSecs;
    
    for i = 1:my_length
        sTime = GetSecs;
        data.dat{s_num}{i}.text_start_time = sTime;
        msg = doubleText(space_loc(i)+1:space_loc(i+1));
        data.dat{s_num}{i}.msg = char(msg);
        data.dat{s_num}{i}.duration = duration(i,2);
        letter_num = space_loc(i+1) - space_loc(i);
        DrawFormattedText(theWindow, msg, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        while GetSecs - sTime < letter_time + base_time + abs(time_interval(i)) %0.31 %duration(i,2)
        end
        data.dat{s_num}{i}.text_end_time = GetSecs;
        if duration(i,1) > 1
            DrawFormattedText(theWindow, ' ', 'center', 'center', text_color);
            Screen('Flip', theWindow);
            while GetSecs - sTime < duration(i,2)
                %duration(i,2) - (letter_time + base_time + abs(time_interval(i)))
            end
            data.dat{s_num}{i}.blank_end_time = GetSecs;
        end
        data.dat{s_num}{i}.text_end_time = GetSecs;
        if rem(i,5) == 0
            save(data.datafile, 'data', '-append');
        end
    end
    
    data.loop_end_time{s_num} = GetSecs;
    save(data.datafile, 'data', '-append');
    while GetSecs - sTime < 5
        % when the story is done, wait for 5 seconds. (in Blank)
    end
    
    
    resting_msg = double('이야기의 끝입니다.\n 지금부터는 중앙의 십자 표시를 바라보시며 \n 자유롭게 생각을 하시면 됩니다. \n 중간중간 과제가 나타날 예정입니다.') ;
    DrawFormattedText(theWindow, resting_msg, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    
    sTime = GetSecs;
    while GetSecs - sTime < 15
        % when the story is done, wait for 5 seconds. (in Blank)
    end
    
    fixation_point = double('+') ;
    DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    
    sTime = GetSecs;
    data.resting_start_time{s_num} = GetSecs;
    while GetSecs - sTime < 120
        % when the story is done, wait for 5 seconds. (in Blank)
    end
    data.resting_end_time{s_num} = GetSecs;
    
    end_msg = double('끝입니다.') ;
    DrawFormattedText(theWindow, end_msg, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    
    save(data.datafile, 'data', '-append');
end

data.endtime_getsecs = GetSecs;
save(data.datafile, 'data', '-append');

KbStrokeWait;
sca;
