%s키 기다릴 때 화면이 안 뜸
% SETUP: time
letter_time =  0.15*4;   %0.15*4
period_time = 3;
comma_time = 1.5;
base_time = 0;
rating_interval = 10;

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

% data save
basedir = '/Users/hongji/Dropbox/MATLAB_hongji/github_hongji/Pico_v0/story_display/';
cd(basedir); addpath(genpath(basedir));

subject_ID = input('Subject ID? (P001_KJH):', 's');
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
data.datafile = fullfile(savedir, [subjdate, '_PICO_', subject_ID, sprintf('%.3d', subject_ID), '_run', sprintf('%.2d', run_number), '.mat']);
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
end

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
%[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/3 1440/3]);
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
data.text_file_name = myFile;
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

% WAITING FOR INPUT FROM THE SCANNER
while (1)
    [~,~,keyCode] = KbCheck;
    
    if keyCode(KbName('s'))==1
        break
    elseif keyCode(KbName('q'))==1
        abort_experiment('manual');
    end
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    ready_prompt = double('참가자가 준비되었으면, 이미징을 시작합니다 (s).');
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
start_msg = double('시작하겠습니다. \n\n 화면의 중앙에 단어가 나타날 예정이니 화면에 집중해주세요. \n\n 글의 내용에 최대한 몰입해주세요. ') ;
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
    %     % rating start (FAST)
    %     % Emotion Rating
    %     if rem(i,rating_interval) == 0
    %         data.dat{i}.emotion_starttime = GetSecs;  % rating start timestamp
    %         [data.dat{i}.emotion_word, data.dat{i}.emotion_time, ...
    %             data.dat{i}.emotion_trajectory] = emotion_rating(data.dat{i}.emotion_starttime); % sub-function
    %
    % %         % Blank for ITI
    % %         if USE_EYELINK
    % %             Eyelink('Message','ITI blank');
    % %         end
    %         data.dat{i}.iti_starttime = GetSecs;    % ITI start timestamp
    %         Screen(theWindow,'FillRect',bgcolor, window_rect);
    %         Screen('Flip', theWindow);
    %         waitsec_fromstarttime(data.dat{i}.trial_starttime, wordT+ts{ts_i}{2}+rT+ts{ts_i}{3});
    %
    %
    %         % Concentration Qustion
    %     elseif i == round(my_length/2)
    % %         if USE_EYELINK
    % %             Eyelink('Message','Concentration present');
    % %         end
    %         data.dat{i}.concent_starttime = GetSecs;  % rating start timestamp
    %         [data.dat{i}.concentration, data.dat{i}.concent_time, ...
    %             data.dat{i}.concent_trajectory] = concent_rating(data.dat{i}.concent_starttime); % sub-function
    %
    %         % Blank for ITI
    % %         if USE_EYELINK
    % %             Eyelink('Message','ITI blank');
    % %         end
    %         data.dat{i}.iti_starttime = GetSecs;    % ITI start timestamp
    %         Screen(theWindow,'FillRect',bgcolor, window_rect);
    %         Screen('Flip', theWindow);
    %
    %         waitsec_fromstarttime(data.dat{i}.trial_starttime, wordT+ts{ts_i}{2}+cqT+ts{ts_i}{3});
    %
    %
    %         % The last question
    %     elseif i == my_length
    %         data.dat.last_question_start = GetSecs;
    % %         if USE_EYELINK
    % %             Eyelink('Message','Final Rating');
    % %         end
    %         data.dat{i}.emotion_starttime = GetSecs;  % rating start timestamp
    %         [data.dat{i}.emotion_word, data.dat{i}.emotion_time, ...
    %             data.dat{i}.emotion_trajectory] = emotion_rating(data.dat{i}.emotion_starttime); % sub-function
    %
    % %         if USE_EYELINK
    % %             Eyelink('Message','Final Concentration');
    % %         end
    %         data.dat{i}.concent_starttime = GetSecs;  % rating start timestamp
    %         [data.dat{i}.concentration, data.dat{i}.concent_time, ...
    %             data.dat{i}.concent_trajectory] = concent_rating(data.dat{i}.concent_starttime); % sub-function
    %
    %     end
    %
    %     % save data every even trial
    %     if mod(i, 2) == 0
    %         save(data.datafile, 'data', '-append'); % 'append' overwrite with adding new columns to 'data'
    %     end
    
    % rating end (FAST)
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

end_msg = double('끝입니다.') ;
DrawFormattedText(theWindow, end_msg, 'center', 'center', 0);
Screen('Flip', theWindow);

KbStrokeWait;
sca;

% function from FAST

function [emotion_word, trajectory_time, trajectory] = emotion_rating(starttime)

global W H orange bgcolor window_rect theWindow red rT

rng('shuffle');        % it prevents pseudo random number
rand_z = randperm(14); % random seed
[choice, xy_rect] = display_emotion_words(rand_z);

SetMouse(880, 500);
% SetMouse(W/2, H/2);

trajectory = [];
trajectory_time = [];

j = 0;

while(1)
    j = j + 1;
    [x, y, button] = GetMouse(theWindow);
    mx = x*1.1;
    my = y*1.1;
    
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    display_emotion_words(rand_z);
    Screen('DrawDots', theWindow, [mx my], 10, orange, [0, 0], 1); % draw orange dot on the cursor
    Screen('Flip', theWindow);
    
    trajectory(j,:) = [mx my];                  % trajectory of location of cursor
    trajectory_time(j) = GetSecs - starttime; % trajectory of time
    
    if trajectory_time(end) >= rT  % maximum time of rating is 8s
        button(1) = true;
    end
    
    if button(1)  % After click, the color of cursor dot changes.
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        display_emotion_words(rand_z);
        Screen('DrawDots', theWindow, [mx;my], 10, red, [0 0], 1);
        Screen('Flip', theWindow);
        
        % which word based on x y from mouse click
        choice_idx = mx > xy_rect(:,1) & mx < xy_rect(:,3) & my > xy_rect(:,2) & my < xy_rect(:,4);
        if any(choice_idx)
            emotion_word = choice{choice_idx};
        else
            emotion_word = '';
        end
        
        WaitSecs(0.3);
        
        break;
    end
end

end

function [choice, xy_rect] = display_emotion_words(z)
    function [concentration, trajectory_time, trajectory] = concent_rating(starttime)
        
        global W H orange bgcolor window_rect theWindow red fontsize white cqT
        intro_prompt1 = double('지금, 나타나는 단어들에 대해 얼마나 주의를 잘 기울이고 계신가요?');
        intro_prompt2 = double('8초 안에 트랙볼을 움직여서 집중하고 있는 정도를 클릭해주세요.');
        title={'전혀 기울이지 않음','보통', '매우 집중하고 있음'};
        
        SetMouse(W/2, H/2);
        
        trajectory = [];
        trajectory_time = [];
        xy = [W/3 W*2/3 W/3 W/3 W*2/3 W*2/3;
            H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7];
        
        j = 0;
        
        while(1)
            j = j + 1;
            [mx, my, button] = GetMouse(theWindow);
            
            x = mx;
            y = H/2;
            if x < W/3, x = W/3;
            elseif x > W*2/3, x = W*2/3;
            end
            
            Screen('TextSize', theWindow, fontsize);
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('DrawLines',theWindow, xy, 5, 255);
            DrawFormattedText(theWindow, intro_prompt1,'center', H/4, white);
            DrawFormattedText(theWindow, intro_prompt2,'center', H/4+40, white);
            % Draw scale letter
            DrawFormattedText(theWindow, double(title{1}),'center', 'center', white, ...
                [],[],[],[],[], [xy(1,1)-70, xy(2,1), xy(1,1)+20, xy(2,1)+60]);
            DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, ...
                [],[],[],[],[], [W/2-15, xy(2,1), W/2+20, xy(2,1)+60]);
            DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, ...
                [],[],[],[],[], [xy(1,2)+45, xy(2,1), xy(1,2)+20, xy(2,1)+60]);
            
            Screen('DrawDots', theWindow, [x y], 10, orange, [0, 0], 1); % draw orange dot on the cursor
            Screen('Flip', theWindow);
            
            trajectory(j,:) = [(x-W/2)/(W/3)];    % trajectory of location of cursor
            trajectory_time(j) = GetSecs - starttime; % trajectory of time
            
            if trajectory_time(end) >= cqT  % maximum time of rating is 5s
                button(1) = true;
            end
            
            if button(1)  % After click, the color of cursor dot changes.
                Screen(theWindow,'FillRect',bgcolor, window_rect);
                Screen('DrawLines',theWindow, xy, 5, 255);
                DrawFormattedText(theWindow, intro_prompt1,'center', H/4, white);
                DrawFormattedText(theWindow, intro_prompt2,'center', H/4+40, white);
                % Draw scale letter
                DrawFormattedText(theWindow, double(title{1}),'center', 'center', white, ...
                    [],[],[],[],[], [xy(1,1)-70, xy(2,1), xy(1,1)+20, xy(2,1)+60]);
                DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, ...
                    [],[],[],[],[], [W/2-15, xy(2,1), W/2+20, xy(2,1)+60]);
                DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, ...
                    [],[],[],[],[], [xy(1,2)+45, xy(2,1), xy(1,2)+20, xy(2,1)+60]);
                Screen('DrawDots', theWindow, [x;y], 10, red, [0 0], 1);
                Screen('Flip', theWindow);
                
                concentration = (x-W/3)/(W/3);  % 0~1
                
                WaitSecs(0.3);
                break;
            end
        end
    end
end

