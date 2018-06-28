function pico_fmri_task_main(varargin)


%% DEFAULT

testmode = false;
USE_EYELINK = false;
USE_BIOPAC = false;

basedir = '/Users/hongji/Dropbox/PiCo_git';
% basedir = pwd;
datdir = fullfile(basedir, 'data'); % (, 'data');
if ~exist(datdir, 'dir'), error('You need to run this code within the PiCo directory.'); end
addpath(genpath(basedir));


%% PARSING VARARGIN

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'test', 'testmode'}
                testmode = true;
            case {'savedir'}
                savedir = varargin{i+1};
            case {'eyelink', 'eye', 'eyetrack'}
                USE_EYELINK = true;
            case {'biopac'}
                USE_BIOPAC = true;
                channel_n = 1;
                biopac_channel = 0;
                ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
        end
    end
end

%% LOAD TRIAL SEQUENCE AND GET RUN NUMBER

sid = input('Subject ID? (e.g., pico001): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');
[~, sid] = fileparts(subject_dir);

ts_fname = filenames(fullfile(subject_dir, 'trial_sequence*.mat'));
if numel(ts_fname)>1
    error('There are more than one ts file. Please check and delete the wrong files.')
else
    load(ts_fname{1}); %Q?? ts_fname
end

run_n = input('Run number? (e.g., 1): ');

%% CREATE AND SAVE DATA

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = sid;
data.datafile = fullfile(subject_dir, [subjdate, '_PICO_', sid, '_run', sprintf('%.2d', run_n), '.mat']);
data.version = 'PICO_v0_05-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;
data.trial_sequence = ts{run_n};

if exist(data.datafile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', data.subject, subjdate);
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

%% EXPERIMENT START

%SETUP: global

global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect text_color window_ratio % lb tb recsize barsize rec; % rating scale

% Screen setting
bgcolor = 100;

if testmode == true
    window_ratio = 1.6;
else
    window_ratio = 1;
end


text_color = 255;
fontsize = 42; %38?
%fontsize = 24; %30

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 0); % Q?? 1
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/window_ratio; %for mac, [0 0 2560 1600];


W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];

%% READY?

fprintf('\n*************************\n RUN %d FIRST story: %s\n', run_n, ts{run_n}{1}{1}.story_name);
fprintf('total time: %.2f seconds \n \n ', ts{run_n}{1}{1}.story_time);
fprintf('RUN %d SECOND story: %s\n', run_n, ts{run_n}{2}{1}.story_name);
fprintf('total time: %.2f seconds \n*************************\n', ts{run_n}{2}{1}.story_time);


ready = input(['Check the time. Ready to start with full screen? \n', ...
    '\n1: Yes, continue  ,   2: No,  I`ll break.\n:  ']);
if ready == 2
    error('Breaked.')
end

%% FULL SCREEN

try
    
    % %Screen('Preference', 'SkipSyncTests', 1);
    % theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen(FULL)
    
    %Screen(theWindow, 'FillRect', bgcolor, window_rect);
    [theWindow, rect]=Screen('OpenWindow',0, bgcolor, window_rect/window_ratio);%[0 0 2560/2 1440/2]
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    font = 'NanumBarunGothic.ttf'; % check
    Screen('TextFont', theWindow, font);
    Screen('TextSize', theWindow, fontsize);
    if ~testmode, HideCursor; end
    
    
    %% STORY START
    for story_num = 1:2
        
        if story_num  == 1
            
            % INPUT FROM THE SCANNER
            while (1)
                [~,~,keyCode] = KbCheck;
                
                if keyCode(KbName('s'))==1
                    break
                elseif keyCode(KbName('q'))==1
                    abort_experiment('manual');
                end
                
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                ready_prompt = double('참가자가 준비되었으면, \n 이미징을 시작합니다 (s).');
                DrawFormattedText(theWindow, ready_prompt,'center', 'center', white); %'center', 'textH'
                Screen('Flip', theWindow);
                
            end
            
            %% FOR DISDAQ 10 SECONDS
            
            % gap between 's' key push and the first stimuli (disdaqs: data.disdaq_sec)
            % 4 seconds: "시작합니다..."
            
            data.runscan_starttime = GetSecs; % run start timestamp
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2);
            Screen('Flip', theWindow);
            
            waitsec_fromstarttime(data.runscan_starttime, 4); % For disdaq
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            
            % biopac
            % eyelink
            
            waitsec_fromstarttime(data.runscan_starttime, 10); % For disdaq
            
            
            %% START FIRST STORY
            
            % 6 seconds for being ready
            start_msg = double('곧 화면 중앙에 단어가 나타날 예정이니 \n\n 글의 내용에 최대한 몰입해주세요.') ;
            DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
            
            waitsec_fromstarttime(data.runscan_starttime, 14);
            
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            
            waitsec_fromstarttime(data.runscan_starttime, 17);
            
        else
            % Start second display
            start_msg = double('두 번째 이야기를 시작하겠습니다. \n\n 곧 화면 중앙에 단어가 나타날 예정이니 \n\n 글의 내용에 최대한 몰입해주세요. ') ;
            DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
            sTime_2 = GetSecs;
            waitsec_fromstarttime(sTime_2, 4)
            
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            waitsec_fromstarttime(sTime_2, 7)
        end
        
        data.loop_start_time{story_num} = GetSecs;
        sTime = data.loop_start_time{story_num};
        duration = 0;
        
        for word_i = 1:numel(data.trial_sequence{story_num})
            
            data.dat{story_num}{word_i}.text_start_time = GetSecs;
            msg = double(data.trial_sequence{story_num}{word_i}.msg);
            data.dat{story_num}{word_i}.msg = char(msg);
            data.dat{story_num}{word_i}.total_duration = data.trial_sequence{story_num}{word_i}.total_duration;
            data.dat{story_num}{word_i}.word_duration = data.trial_sequence{story_num}{word_i}.word_duration;
            DrawFormattedText(theWindow, msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
            
            duration = duration + data.trial_sequence{story_num}{word_i}.word_duration;
            
            waitsec_fromstarttime(sTime, duration);
            
            data.dat{story_num}{word_i}.text_end_time = GetSecs;
            if ~strcmp(data.trial_sequence{story_num}{word_i}.word_type, 'words')
                DrawFormattedText(theWindow, ' ', 'center', 'center', text_color);
                Screen('Flip', theWindow);
                
                duration = duration + data.trial_sequence{story_num}{word_i}.total_duration ...
                    - data.trial_sequence{story_num}{word_i}.word_duration;
                
                waitsec_fromstarttime(sTime, duration);
                
                data.dat{story_num}{word_i}.blank_end_time = GetSecs;
            end
            
            if rem(word_i,5) == 0
                save(data.datafile, 'data', '-append');
            end
        end
        
        data.loop_end_time{story_num} = GetSecs;
        save(data.datafile, 'data', '-append');
        
        
        
        while GetSecs - sTime < 5
            % when the story is done, wait for 5 seconds. (in Blank)
        end
        
        data = story_free(data, story_num); %free thinking for story!
        
        save(data.datafile, 'data', '-append');
        
        data.endtime_getsecs = GetSecs;
        save(data.datafile, 'data', '-append');
        
    end
    
    KbStrokeWait;
    sca;
    
catch err
    
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    %     fclose(t);
    %     fclose(r);  % Q??
    abort_experiment('error');
    
end

end



%% ====== SUBFUNCTIONS ======


function data = story_free(data, story_num)

global theWindow W H; % window property
global fontsize window_rect text_color window_ratio textH % lb tb recsize barsize rec; % rating scale

resting_msg = double('이야기의 끝입니다.\n 지금부터는 중앙의 십자 표시를 바라보시며 \n 자유롭게 생각을 하시면 됩니다. \n') ;
DrawFormattedText(theWindow, resting_msg, 'center', 'center', text_color, [], [], [], 1.5);
Screen('Flip', theWindow);

resting_instruction = GetSecs;
waitsec_fromstarttime(resting_instruction, 7)
data.resting{story_num}.instructon_start_time = resting_instruction;

resting_msg2 = double('중간중간 십자표시가 사라질 때 마다 \n 하고 계신 생각을 단어나 구로 표현해주세요. \n 준비가 되시면 ''시작''이라고 말씀해주시기 바랍니다.\n') ;
DrawFormattedText(theWindow, resting_msg2, 'center', 'center', text_color, [], [], [], 1.5);
Screen('Flip', theWindow);

waitsec_fromstarttime(resting_instruction, 15)

fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

resting_sTime = GetSecs;
data.resting{story_num}.fixation_start_time = resting_sTime;


sampling_time = [30 60 90 120] + randi(10,1,4) ;
data.resting{story_num}.sampling_time = sampling_time;


while GetSecs - resting_sTime < 150
    for i = 1:4
        while GetSecs - resting_sTime > (sampling_time(i) - 2.5) && GetSecs - resting_sTime < (sampling_time(i) + 2.5)
            data.resting{story_num}.start_Sampling{i} = GetSecs;
            blank = double(' ') ;
            DrawFormattedText(theWindow, blank, 'center', 'center', text_color);
            Screen('Flip', theWindow);
        end
        data.resting{story_num}.end_Sampling{i} = GetSecs;
        fixation_point = double('+') ;
        DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        

    end
%     else
%         fixation_point = double('+') ;
%         DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
%         Screen('Flip', theWindow);
%     end
 
end

data.resting{story_num}.fixation_end_time = GetSecs;

end_msg = double('끝입니다.') ;
DrawFormattedText(theWindow, end_msg, 'center', 'center', text_color);
Screen('Flip', theWindow);
end

function abort_experiment(varargin)

% ABORT the experiment
%
% abort_experiment(varargin)

str = 'Experiment aborted.';

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'error'}
                str = 'Experiment aborted by error.';
            case {'manual'}
                str = 'Experiment aborted by the experimenter.';
        end
    end
end

ShowCursor; %unhide mouse
Screen('CloseAll'); %relinquish screen control
disp(str); %present this text in command window

end


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

global W H white theWindow window_rect bgcolor square fontsize

square = [0 0 140 80];  % size of square of word
r=350;
t=360/28;
theta=[t, t*3, t*5, t*7, t*9, t*11, t*13, t*15, t*17, t*19, t*21, t*23, t*25, t*27];
xy=[W/2+r*cosd(theta(1)) H/2-r*sind(theta(1)); W/2+r*cosd(theta(2)) H/2-r*sind(theta(2)); ...
    W/2+r*cosd(theta(3)) H/2-r*sind(theta(3)); W/2+r*cosd(theta(4)) H/2-r*sind(theta(4));...
    W/2+r*cosd(theta(5)) H/2-r*sind(theta(5)); W/2+r*cosd(theta(6)) H/2-r*sind(theta(6));...
    W/2+r*cosd(theta(7)) H/2-r*sind(theta(7)); W/2+r*cosd(theta(8)) H/2-r*sind(theta(8));...
    W/2+r*cosd(theta(9)) H/2-r*sind(theta(9)); W/2+r*cosd(theta(10)) H/2-r*sind(theta(10));...
    W/2+r*cosd(theta(11)) H/2-r*sind(theta(11)); W/2+r*cosd(theta(12)) H/2-r*sind(theta(12));...
    W/2+r*cosd(theta(13)) H/2-r*sind(theta(13)); W/2+r*cosd(theta(14)) H/2-r*sind(theta(14))];

xy_word = [xy(:,1)-square(3)/2, xy(:,2)-square(4)/2-15, xy(:,1)+square(3)/2, xy(:,2)+square(4)/2];
xy_rect = [xy(:,1)-square(3)/2, xy(:,2)-square(4)/2, xy(:,1)+square(3)/2, xy(:,2)+square(4)/2];

colors = 200;

%% words

choice = {'기쁨', '괴로움', '희망', '두려움', '행복', '실망', '자부심', '부끄러움', '후회', '슬픔', '분노', '사랑', '미움', '없음'};
choice = choice(z);

%%
Screen(theWindow,'FillRect',bgcolor, window_rect);
Screen('TextSize', theWindow, fontsize);
% Rectangle
for i = 1:numel(theta)
    Screen('FrameRect', theWindow, colors, CenterRectOnPoint(square,xy(i,1),xy(i,2)),3);
end
% Choice letter
for i = 1:numel(choice)
    DrawFormattedText(theWindow, double(choice{i}), 'center', 'center', white, [],[],[],[],[],xy_word(i,:));
end

end

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

