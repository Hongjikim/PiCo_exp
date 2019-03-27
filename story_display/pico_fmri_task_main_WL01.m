function pico_fmri_task_main(varargin)


%% DEFAULT
global USE_EYELINK

testmode = false;
USE_EYELINK = false;
USE_BIOPAC = false;

basedir =  'C:\Users\Cocoanlab_WL01\Desktop\Dropbox\fMRI_task_data';
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
                channel_n = 3;
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
data.datafile = fullfile(subject_dir, [subjdate, '_', sid, '_S_run', sprintf('%.2d', run_n), '.mat']);
data.version = 'PICO_v1_09-2018_Cocoanlab';
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
global fontsize window_rect text_color IVqT ; %lb tb recsize barsize rec;
global ptb_drawformattedtext_disableClipping

ptb_drawformattedtext_disableClipping = 1;
% Screen setting
bgcolor = 50;

text_color = 255;
fontsize = [28, 32, 41, 54];

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]; %for mac, [0 0 2560 1600];

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

white = 255;
red = [190 0 0];
blue = [0 85 169];
orange = [255 145 0];

%% READY?

fprintf('\n*************************\n RUN %d FIRST story: %s\n', run_n, ts{run_n}{1}{1}.story_name);
fprintf('total time: %.2f seconds \n ', ts{run_n}{1}{1}.story_time);
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
    [theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
%     font = 'NanumBarunGothic'; % check
%     Screen('TextFont', theWindow, font);
    Screen('TextSize', theWindow, fontsize(2));
    if ~testmode, HideCursor; end
    
    %% SETUP: Eyelink
    % need to be revised when the eyelink is here.
    if USE_EYELINK
        edf_filename = ['E' sid(5:7), '_S' sprintf('%.1d', run_n)]; % name should be equal or less than 8
        % E_S for STORY
        edfFile = sprintf('%s.EDF', edf_filename);
        eyelink_main(edfFile, 'Init');
        
        status = Eyelink('Initialize');
        if status
            error('Eyelink is not communicating with PC. Its okay baby.');
        end
        Eyelink('Command', 'set_idle_mode');
        waitsec_fromstarttime(GetSecs, 0.5);
    end
    
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
                Screen('TextSize', theWindow, fontsize(2));
                ready_prompt = double('참가자가 준비되었으면, \n 이미징을 시작합니다 (s).');
                DrawFormattedText(theWindow, ready_prompt,'center', 'center', white, [], [], [], 1.5); %'center', 'textH'
                Screen('Flip', theWindow);
                
            end
            %% FOR DISDAQ 10 SECONDS
            
            % gap between 's' key push and the first stimuli (disdaqs: data.disdaq_sec)
            % 4 seconds: "시작합니다..."
            
            test.scanstart = GetSecs;
            data.runscan_starttime = GetSecs; % run start timestamp
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            
            Screen('TextSize', theWindow, fontsize(2));
            start_msg = double('곧 화면 중앙에 단어가 나타날 예정이니 \n\n 글의 내용에 최대한 몰입해주세요.') ;
            DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color, [], [], [], 1.5);
            Screen('Flip', theWindow);
            waitsec_fromstarttime(data.runscan_starttime, 2);
            
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            waitsec_fromstarttime(data.runscan_starttime, 8); % For disdaq (total disdaq = 8 seconds)
            
            %% EYELINK AND BIOPAC START
            
            if USE_EYELINK
                Eyelink('StartRecording');
                data.eyetracker_starttime = GetSecs; % eyelink timestamp
                Eyelink('Message','Story Run start');
            end
            
            if USE_BIOPAC
                data.biopac_starttime = GetSecs; % biopac timestamp
                BIOPAC_trigger(ljHandle, biopac_channel, 'on');
                waitsec_fromstarttime(data.biopac_starttime, 1.5);
                BIOPAC_trigger(ljHandle, biopac_channel, 'off');
            end
            
            %% START FIRST STORY
            
            % 4 seconds baseline (blank screen)
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            
            waitsec_fromstarttime(data.runscan_starttime, 12); % baseline (blank) = 4 seconds for 1st story
            
        else
            % Start second display
            story2_sTime = GetSecs;
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            waitsec_fromstarttime(story2_sTime, 4) % baseline (blank) = 4 seconds for 2nd story
        end
        
        data.loop_start_time{story_num} = GetSecs;
        sTime = data.loop_start_time{story_num};
        duration = 0;
        test.loopstart{story_num} = GetSecs;
        
        for word_i = 1:numel(data.trial_sequence{story_num})
            
            data.dat{story_num}{word_i}.text_start_time = GetSecs;
            msg = double(data.trial_sequence{story_num}{word_i}.msg);
            data.dat{story_num}{word_i}.msg = char(msg);
            data.dat{story_num}{word_i}.total_duration = data.trial_sequence{story_num}{word_i}.total_duration;
            data.dat{story_num}{word_i}.word_duration = data.trial_sequence{story_num}{word_i}.word_duration;
            Screen('TextSize', theWindow, fontsize(3));
            DrawFormattedText(theWindow, msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
            
            duration = duration + data.trial_sequence{story_num}{word_i}.word_duration;
            
            waitsec_fromstarttime(sTime, duration);
            if USE_EYELINK
                Eyelink('Message','story word');
            end
            
            data.dat{story_num}{word_i}.text_end_time = GetSecs;
            if ~strcmp(data.trial_sequence{story_num}{word_i}.word_type, 'words')
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                Screen('Flip', theWindow);
                
                duration = duration + data.trial_sequence{story_num}{word_i}.total_duration ...
                    - data.trial_sequence{story_num}{word_i}.word_duration;
                
                waitsec_fromstarttime(sTime, duration);
                
                data.dat{story_num}{word_i}.blank_end_time = GetSecs;
                
                % 최대 시간 맞추기
                if sum(word_i == data.trial_sequence{story_num}{1}.rating_period_loc) == 1
                    IVqT = 5;
                    duration = duration + IVqT + 2; % inter valence question time (Question 5 + blank 2)
                    e_i = find(data.trial_sequence{story_num}{1}.rating_period_loc == word_i);
                    data.taskdat{story_num}{e_i}.valence_starttime = GetSecs;  % rating start timestamp
                    data = pico_int_valence(data, story_num, e_i);
                    waitsec_fromstarttime(sTime, duration);
                end
            end
        end
        
        data.loop_end_time{story_num} = GetSecs;
        e_i = 3;
        data.taskdat{story_num}{e_i}.valence_starttime = GetSecs;  % rating start timestamp
        data = pico_int_valence(data, story_num, e_i); % sub-function
        
        waitsec_fromstarttime(data.taskdat{story_num}{3}.valence_starttime, IVqT + 2);
        
        Screen('TextSize', theWindow, fontsize(3));
        fixation_point = double('+') ;
        DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        
        save(data.datafile, 'data', '-append');
       
        if USE_BIOPAC % resting start trigger (after 250 buffer time)
            BIOPAC_trigger(ljHandle, biopac_channel, 'on');
            waitsec_fromstarttime(GetSecs, 0.2);
            BIOPAC_trigger(ljHandle, biopac_channel, 'off');
        end
        
        waitsec_fromstarttime(GetSecs, .1)
        
        if USE_EYELINK
            Eyelink('Message','Resting start');
        end
        
        waitsec_fromstarttime(sTime, 250); % flexible time (maximum 250 sec for each story)
        test.loop_250_end{story_num} = GetSecs;
        
        data = story_FT(data, story_num); %free thinking for story!
        
        if USE_EYELINK
            Eyelink('Message','Rest end');
        end
        
        Screen('TextSize', theWindow, fontsize(2));
        run_end_msg = double('이번 이야기와 자유생각이 끝났습니다. \n 나타나는 질문들에 답변해주세요.') ;
        DrawFormattedText(theWindow, run_end_msg, 'center', 'center', white, [], [], [], 1.5);
        Screen('Flip', theWindow);
        save(data.datafile, 'data', '-append');
        waitsec_fromstarttime(sTime, 410);
        
        data = pico_post_run_survey(data, story_num); % post_run questionnaire after each FT
        
        Screen('Flip', theWindow);
        %save(data.datafile, 'data', '-append');
        waitsec_fromstarttime(data.postrunQ{story_num}.response_endtime, 2)
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        Screen('Flip', theWindow);
        
        if story_num == 1
            waitsec_fromstarttime(data.postrunQ{story_num}.start_time, 27)
        else
            waitsec_fromstarttime(GetSecs, 3)
        end
    end
    %% RUN END MESSAGE
    
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('TextSize', theWindow, fontsize(2));
    run_end_msg = '잘하셨습니다. 잠시 대기해 주세요. \n 곧 이야기에 대한 질문들이 나타납니다.';
    DrawFormattedText(theWindow, double(run_end_msg), 'center', 'center', white, [], [], [], 1.5);
    Screen('Flip', theWindow);
    
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space')) == 1
            break
        end
    end
    
    if USE_EYELINK
        Eyelink('Message','Story Run END');
        eyelink_main(edfFile, 'Shutdown');
    end
    
    if USE_BIOPAC
        data.biopac_endtime = GetSecs; % biopac timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        ending_trigger = 0.1 * (run_n+1);
        waitsec_fromstarttime(data.biopac_endtime, ending_trigger); % BIOPAC TRIGGER for run 2~5 (story) = 0.2 ~ 0.6
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    data.endtime_getsecs = GetSecs;
    waitsec_fromstarttime(GetSecs, 3)
    
    % POST RUN QUESTIONNAIRE (about STORY 1 and 2)
    
    for story_num = 1:2
        story_titles{story_num} = data.trial_sequence{story_num}{1}.story_title;
        
        data.taskdat{story_num}{4}.concent_starttime = GetSecs;  % rating start timestamp
        [data.taskdat{story_num}{4}.concentration, data.taskdat{story_num}{4}.concent_time, ...
            data.taskdat{story_num}{4}.concent_trajectory] = concent_rating(data.taskdat{story_num}{4}.concent_starttime, story_titles, story_num); % sub-function
        
        data.taskdat{story_num}{5}.concent_starttime = GetSecs;  % rating start timestamp
        [data.taskdat{story_num}{5}.familiarity, data.taskdat{story_num}{5}.familiarity_time, ...
            data.taskdat{story_num}{5}.familiarity_trajectory] = familiar_rating(data.taskdat{story_num}{5}.concent_starttime, story_titles, story_num); % sub-function
       
    end
    data.run_including_5d_and_storyQ_endtime = GetSecs; 
     save(data.datafile, 'data', '-append');
     
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('TextSize', theWindow, fontsize(2));
    run_end_msg = '이번 이야기 세션이 모두 끝났습니다. \n 잠시 대기해주세요.';
    DrawFormattedText(theWindow, double(run_end_msg), 'center', 'center', white, [], [], [], 1.5);
    Screen('Flip', theWindow);
    
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space')) == 1
            break
        end
    end
    
    ShowCursor();
    Screen('Clear');
    Screen('CloseAll')
    
catch err
    
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment('error');
    
end
end

%% ====== SUBFUNCTIONS ======

function data = story_FT(data, story_num)

global theWindow W H; % window property
global  window_rect text_color textH % lb tb recsize barsize rec; % rating scale
global fontsize

Screen('TextSize', theWindow, fontsize(3));
fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

resting_sTime = GetSecs;
data.resting{story_num}.fixation_start_time = resting_sTime;

rng('shuffle')

sampling_time = [50 100] + randi(10,1,2) - 5;
story_ft_time = 150;

data.resting{story_num}.sampling_time = sampling_time;

while GetSecs - resting_sTime < story_ft_time
    for i = 1:2
        k = 0;
        while GetSecs - resting_sTime > (sampling_time(i) - 2.5) && GetSecs - resting_sTime < (sampling_time(i) + 2.5)
            k = k +1;
            if k == 1
                data.resting{story_num}.start_Sampling{i} = GetSecs;
            end
            data.resting{story_num}.end_Sampling{i} = GetSecs;
            Screen('TextSize', theWindow, fontsize(2));
            FT_msg = double('지금 무슨 생각을 하고 있는지 \n단어나 구로 말해주세요.') ;
            DrawFormattedText(theWindow, FT_msg, 'center', 'center', text_color, [], [], [], 1.5);
            Screen('Flip', theWindow);
        end
        Screen('TextSize', theWindow, fontsize(3));
        DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
        Screen('Flip', theWindow);
    end
end

data.resting{story_num}.fixation_end_time = GetSecs;
test.fixation_end{story_num} = GetSecs;

if story_num == 2
    data.runscan_endtime = GetSecs;
    test.scanend = GetSecs;
end

while GetSecs - data.resting{story_num}.fixation_end_time < 5
    Screen('TextSize', theWindow, fontsize(2));
    end_msg = double('지금 무슨 생각을 하고 있는지\n 단어나 구로 말해주세요.') ;
    DrawFormattedText(theWindow, end_msg, 'center', 'center', text_color, [], [], [], 1.5);
    Screen('Flip', theWindow);
end
test.lastWSend = GetSecs;
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

function [concentration, trajectory_time, trajectory] = concent_rating(starttime, story_titles, story_num)

global W H orange bgcolor window_rect theWindow red white cqT
global fontsize

title_prompt = [double('<') double(story_titles{story_num}) double('>')];
intro_prompt1 = double('위의 이야기에 얼마나 집중/몰입할 수 있었나요?');
intro_prompt2 = double('트랙볼을 움직여서 집중/몰입했던 정도를 클릭해주세요.');
title={'전혀', '보통', '매우'};

SetMouse(W/2, H/2);
cqT = 5;
trajectory = [];
trajectory_time = [];
xy = [W/3 W*2/3 W/3 W/3 W*2/3 W*2/3 W/2 W/2;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7 H/2-7 H/2+7];

j = 0;

while(1)
    j = j + 1;
    [mx, my, button] = GetMouse(theWindow);
    
    x = (mx-W/2).*1.3+W/2 ;
    y = H/2;
    if x < W/3, x = W/3;
    elseif x > W*2/3, x = W*2/3;
    end
    
    Screen('TextSize', theWindow, fontsize(2));
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('DrawLines',theWindow, xy, 5, 255);
    
    DrawFormattedText(theWindow, title_prompt,'center', H/4-100, white);
    DrawFormattedText(theWindow, intro_prompt1,'center', H/4-20, white);
    DrawFormattedText(theWindow, intro_prompt2,'center', H/4+65, white); % check
    % Draw scale letter
    Screen('TextSize', theWindow, fontsize(1));
    DrawFormattedText(theWindow, double(title{1}),'center', 'center', white, ...
        [],[],[],[],[], [xy(1,1)-70, xy(2,1), xy(1,1)+20, xy(2,1)+60]);
    DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, ...
        [],[],[],[],[], [W/2-15, xy(2,1), W/2+20, xy(2,1)+60]);
    DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, ...
        [],[],[],[],[], [xy(1,2)+45, xy(2,1), xy(1,2)+20, xy(2,1)+60]);
    
    % Screen('DrawDots', theWindow, [x y], 10, orange, [0, 0], 1); % draw orange dot on the cursor
    Screen('DrawLine', theWindow, orange, x, y+10, x, y-10, 6);
    Screen('Flip', theWindow);
    
    trajectory(j,1) = (x-W/2)/(W/3);    % trajectory of location of cursor
    trajectory_time(j,1) = GetSecs - starttime; % trajectory of time
    
    %     if trajectory_time(end) >= cqT  % maximum time of rating is 5s
    %         button(1) = true;
    %     end
    
    if button(1)  % After click, the color of cursor dot changes.
        rrtt = GetSecs;
        Screen('TextSize', theWindow, fontsize(2));
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('DrawLines',theWindow, xy, 5, 255);
        DrawFormattedText(theWindow, title_prompt,'center', H/4-100, white);
        DrawFormattedText(theWindow, intro_prompt1,'center', H/4-20, white);
        DrawFormattedText(theWindow, intro_prompt2,'center', H/4+65, white);
        % Draw scale letter
        Screen('TextSize', theWindow, fontsize(1));
        DrawFormattedText(theWindow, double(title{1}),'center', 'center', white, ...
            [],[],[],[],[], [xy(1,1)-70, xy(2,1), xy(1,1)+20, xy(2,1)+60]);
        DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, ...
            [],[],[],[],[], [W/2-15, xy(2,1), W/2+20, xy(2,1)+60]);
        DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, ...
            [],[],[],[],[], [xy(1,2)+45, xy(2,1), xy(1,2)+20, xy(2,1)+60]);
        %Screen('DrawDots', theWindow, [x;y], 10, red, [0 0], 1);
        Screen('DrawLine', theWindow, red, x, y+10, x, y-10, 6);
        Screen('Flip', theWindow);
        
        concentration = (x-W/3)/(W/3);  % 0~1
        waitsec_fromstarttime(rrtt, .5);
        Screen(theWindow, 'FillRect', bgcolor, window_rect)
        Screen('Flip', theWindow);
        %         waitsec_fromstarttime(starttime, cqT+2);
        break;
    end
end
end

function [familiarity, trajectory_time, trajectory] = familiar_rating(starttime, story_titles, story_num)

global W H orange bgcolor window_rect theWindow red fontsize white cqT


title_prompt = [double('<') double(story_titles{story_num}) double('>')];
intro_prompt1 = double('위의 이야기가 얼마나 익숙했나요?');
intro_prompt2 = double('트랙볼을 움직여서 익숙했던 정도를 클릭해주세요.');
title={'전혀','보통', '매우'};

SetMouse(W/2, H/2);
% cqT = 5;
trajectory = [];
trajectory_time = [];
xy = [W/3 W*2/3 W/3 W/3 W*2/3 W*2/3 W/2 W/2;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7 H/2-7 H/2+7];

j = 0;

while(1)
    j = j + 1;
    [mx, ~, button] = GetMouse(theWindow);
    
    x = (mx-W/2).*1.3+W/2 ;
    y = H/2;
    if x < W/3, x = W/3;
    elseif x > W*2/3, x = W*2/3;
    end
    
    Screen('TextSize', theWindow, fontsize(2));
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('DrawLines',theWindow, xy, 3, 255);
    DrawFormattedText(theWindow, title_prompt,'center',  H/4-100, white);
    DrawFormattedText(theWindow, intro_prompt1,'center', H/4-20, white);
    DrawFormattedText(theWindow, intro_prompt2,'center', H/4+65, white); % check
    % Draw scale letter
    Screen('TextSize', theWindow, fontsize(1));
    DrawFormattedText(theWindow, double(title{1}),'center', 'center', white, ...
        [],[],[],[],[], [xy(1,1)-70, xy(2,1), xy(1,1)+20, xy(2,1)+60]);
    DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, ...
        [],[],[],[],[], [W/2-15, xy(2,1), W/2+20, xy(2,1)+60]);
    DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, ...
        [],[],[],[],[], [xy(1,2)+45, xy(2,1), xy(1,2)+20, xy(2,1)+60]);
    
    %Screen('DrawDots', theWindow, [mx my], 10, orange, [0, 0], 1); % draw orange dot on the cursor
    Screen('DrawLine', theWindow, orange, x, y+10, x, y-10, 6);
    Screen('Flip', theWindow);
    
    trajectory(j,1) = (x-W/2)/(W/3);    % trajectory of location of cursor
    trajectory_time(j,1) = GetSecs - starttime; % trajectory of time
    %
    %         if trajectory_time(end) >= cqT  % maximum time of rating is 5s
    %             button(1) = true;
    %         end
    
    if button(1)  % After click, the color of cursor dot changes.
        rrtt = GetSecs;
        Screen('TextSize', theWindow, fontsize(2));
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('DrawLines',theWindow, xy, 3, 255);
        DrawFormattedText(theWindow, title_prompt,'center', H/4-100, white)
        DrawFormattedText(theWindow, intro_prompt1,'center', H/4-20, white);
        DrawFormattedText(theWindow, intro_prompt2,'center', H/4+65, white); % check
        % Draw scale letter
        Screen('TextSize', theWindow, fontsize(1));
        DrawFormattedText(theWindow, double(title{1}),'center', 'center', white, ...
            [],[],[],[],[], [xy(1,1)-70, xy(2,1), xy(1,1)+20, xy(2,1)+60]);
        DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, ...
            [],[],[],[],[], [W/2-15, xy(2,1), W/2+20, xy(2,1)+60]);
        DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, ...
            [],[],[],[],[], [xy(1,2)+45, xy(2,1), xy(1,2)+20, xy(2,1)+60]);
        %Screen('DrawDots', theWindow, [x;y], 10, red, [0 0], 1);
        Screen('DrawLine', theWindow, red, x, y+10, x, y-10, 6);
        Screen('Flip', theWindow);
        
        familiarity = (x-W/3)/(W/3);  % 0~1
        waitsec_fromstarttime(rrtt, .5);
        Screen(theWindow, 'FillRect', bgcolor, window_rect)
        Screen('Flip', theWindow);
        waitsec_fromstarttime(rrtt, .5);
        break
    end
end
end

function data = pico_post_run_survey(data, story_num)

global theWindow W H; % window property
global white red orange bgcolor tb rec recsize; % color
global window_rect USE_EYELINK
global fontsize barsize

%tb = H/5;
if story_num == 1
    rT_post = 5;
else
    rT_post = Inf;
end

lb=300; %W*3/128;     %110        when W=1280
tb=300; %H*12/80;     %180

recsize=[W*450/1280 H*175/1000];
barsizeO=[W*340/1280, W*180/1280, W*340/1280, W*180/1280, W*340/1280, 0;
    10, 10, 10, 10, 10, 0; 10, 0, 10, 0, 10, 0;
    10, 10, 10, 10, 10, 0; 1, 2, 3, 4, 5, 0]*1;
rec=[lb,tb; lb+recsize(1),tb; lb,tb+recsize(2); lb+recsize(1),tb+recsize(2);
    lb,tb+2*recsize(2); lb+recsize(1),tb+2*recsize(2)]; %6개 사각형의 왼쪽 위 꼭짓점의 좌표

% trajectory = [];
% trajectory_time = [];
%
% j = 0;
post_run.start_time = GetSecs;
question_type = {'Valence','Self','Time','Vividness','Safe&Threat'};

% save(data.datafile, 'data', '-append');

Screen(theWindow, 'FillRect', bgcolor, window_rect);
intro_prompt1 = double('방금 자유 생각 과제를 하는동안 자연스럽게 떠올린 생각에 대한 질문입니다.') ;
Screen('TextSize', theWindow, fontsize(2));
DrawFormattedText(theWindow, intro_prompt1,'center', H/5-80, white);

title={'','', '','', '', '';
    '부정', '전혀 나와\n관련이 없음', '과거', '전혀 생생하지 않음', '위협', '';
    '중립', '', '현재', '', '중립', '';
    '긍정','나와 관련이\n매우 많음', '미래','매우 생생함','안전','';
    '느껴지는 감정', '자신과 관련이 있는 정도', '가장 관련이 있는 자신의 시간', ...
    '어떤 상황이나 장면을\n얼마나 생생하게 떠올리게 하는지', '안전 또는 위협을\n의미하거나 느끼게 하는지', '';
    '그 생각이 일으킨 감정은?', '그 생각이 나와 관련이 있는 정도는?', '그 생각이 가장 관련이 있는 자신의 시간?', ...
    '그 생각이 어떤 상황이나 장면을\n생생하게 떠올리게 했나요?', '그 생각이 안전 또는 위협을\n의미하거나 느끼게 했나요?',''};


rng('shuffle');
z = randperm(6);
barsize = barsizeO(:,z);
title = title(:,z);


linexy = zeros(2,48);

for i=1:6       % 6 lines
    linexy(1,2*i-1)= rec(i,1)+(recsize(1)-barsize(1,i))/2;
    linexy(1,2*i)= rec(i,1)+(recsize(1)+barsize(1,i))/2;
    linexy(2,2*i-1) = rec(i,2)+recsize(2)/2;
    linexy(2,2*i) = rec(i,2)+recsize(2)/2;
end

for i=1:6       % 3 scales for one line, 18 scales
    linexy(1,6*(i+1)+1)= rec(i,1)+(recsize(1)-barsize(1,i))/2;
    linexy(1,6*(i+1)+2)= rec(i,1)+(recsize(1)-barsize(1,i))/2;
    linexy(1,6*(i+1)+3)= rec(i,1)+recsize(1)/2;
    linexy(1,6*(i+1)+4)= rec(i,1)+recsize(1)/2;
    linexy(1,6*(i+1)+5)= rec(i,1)+(recsize(1)+barsize(1,i))/2;
    linexy(1,6*(i+1)+6)= rec(i,1)+(recsize(1)+barsize(1,i))/2;
    linexy(2,6*(i+1)+1)= rec(i,2)+recsize(2)/2-barsize(2,i)/2;
    linexy(2,6*(i+1)+2)= rec(i,2)+recsize(2)/2+barsize(2,i)/2;
    linexy(2,6*(i+1)+3)= rec(i,2)+recsize(2)/2-barsize(3,i)/2;
    linexy(2,6*(i+1)+4)= rec(i,2)+recsize(2)/2+barsize(3,i)/2;
    linexy(2,6*(i+1)+5)= rec(i,2)+recsize(2)/2-barsize(4,i)/2;
    linexy(2,6*(i+1)+6)= rec(i,2)+recsize(2)/2+barsize(4,i)/2;
end

Screen('Flip', theWindow);

for j=1:numel(barsize(5,:))
    if ~barsize(5,j) == 0 % if barsize(5,j) = 0, skip the scale
        % if Self, Vivid question, set curson on the left.
        % the other, set curson on the center.
        if mod(barsize(5,j),2) == 0
            SetMouse(rec(j,1)+(recsize(1)-barsize(1,j))/2, rec(j,2)+recsize(2)/2);
        else
            SetMouse(rec(j,1)+recsize(1)/2, rec(j,2)+recsize(2)/2);
        end
        
        rec_i = 0;
        post_run.dat{barsize(5,j)}.trajectory = [];
        post_run.dat{barsize(5,j)}.time = [];
        post_run.dat{barsize(5,j)}.question_type = question_type{z(j)};
        post_run.dat{barsize(5,j)}.button_press = true;
        
        starttime = GetSecs; % Each question start time
        
        while(1)
            
            % Draw scale lines
            Screen('DrawLines',theWindow, linexy, 4, 255);
            Screen('TextSize', theWindow, fontsize(2));
            DrawFormattedText(theWindow, intro_prompt1,'center', H/5-80, white)
            % Draw scale letter
            
            for i = 1:numel(title(1,:))
                Screen('TextSize', theWindow, fontsize(1));
                DrawFormattedText(theWindow, double(title{1,i}),'center', 'center', white, [],[],[],[],[],...
                    [rec(i,1), rec(i,2)+5, rec(i,1)+recsize(1), rec(i,2)+recsize(2)/2]);
                Screen('TextSize', theWindow, fontsize(1)-5);
                DrawFormattedText(theWindow, double(title{2,i}),'center', 'center', white, [],[],[], 1.5,[],...
                    [linexy(1,2*i-1)-15, linexy(2,2*i-1), linexy(1,2*i-1)+20, linexy(2,2*i-1)+80]);
                DrawFormattedText(theWindow, double(title{3,i}),'center', 'center', white, [],[],[], 1.5,[],...
                    [rec(i,1)+recsize(1)/3, linexy(2,2*i-1), rec(i,1)+recsize(1)*2/3, linexy(2,2*i-1)+80]);
                DrawFormattedText(theWindow, double(title{4,i}),'center', 'center', white, [],[],[],1.5,[],...
                    [linexy(1,2*i)-20, linexy(2,2*i-1), linexy(1,2*i)+15, linexy(2,2*i-1)+80]);
            end
            
            % Track Mouse coordinate
            [mx, my, button] = GetMouse(theWindow);
            
            if mod(barsize(5,j),2) == 0
                cent_x = rec(j,1)+(recsize(1)-barsize(1,j))/2 ;
            else
                cent_x = rec(j,1)+recsize(1)/2 ;
            end
        
            x = (mx - cent_x).*1.3 + cent_x ;  % x of a color dot
            y = rec(j,2)+recsize(2)/2;
            if x < rec(j,1)+(recsize(1)-barsize(1,j))/2, x = rec(j,1)+(recsize(1)-barsize(1,j))/2;
            elseif x > rec(j,1)+(recsize(1)+barsize(1,j))/2, x = rec(j,1)+(recsize(1)+barsize(1,j))/2;
            end
            
            %                     % display scales and cursor
            %                     a_display_survey(z, seeds_i, target_i, words','whole');
            %Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
            Screen('DrawLines', theWindow, [x, x; y+10 y-10], 6, orange);
            Screen('Flip', theWindow);
            
            % Get trajectory
            rec_i = rec_i+1; % the number of recordings
            post_run.dat{barsize(5,j)}.trajectory(rec_i,1) = rating_5d(x, j);
            post_run.dat{barsize(5,j)}.time(rec_i,1) = GetSecs - starttime;
            
            if GetSecs - starttime >= rT_post
                post_run.dat{barsize(5,j)}.button_press = false;
                button(1) = true;
            end
            
            if button(1)
                
                % Draw scale lines
                Screen('DrawLines',theWindow, linexy, 4, 255);
                Screen('TextSize', theWindow, fontsize(2));
                DrawFormattedText(theWindow, intro_prompt1,'center', H/5-80, white)
                % Draw scale letter
                
                for i = 1:numel(title(1,:))
                    Screen('TextSize', theWindow, fontsize(1));
                    DrawFormattedText(theWindow, double(title{1,i}),'center', 'center', white, [],[],[],[],[],...
                        [rec(i,1), rec(i,2)+5, rec(i,1)+recsize(1), rec(i,2)+recsize(2)/2]);
                    Screen('TextSize', theWindow, fontsize(1)-5);
                    DrawFormattedText(theWindow, double(title{2,i}),'center', 'center', white, [],[],[], 1.5,[],...
                        [linexy(1,2*i-1)-15, linexy(2,2*i-1), linexy(1,2*i-1)+20, linexy(2,2*i-1)+80]);
                    DrawFormattedText(theWindow, double(title{3,i}),'center', 'center', white, [],[],[],1.5,[],...
                        [rec(i,1)+recsize(1)/3, linexy(2,2*i-1), rec(i,1)+recsize(1)*2/3, linexy(2,2*i-1)+80]);
                    DrawFormattedText(theWindow, double(title{4,i}),'center', 'center', white, [],[],[],1.5,[],...
                        [linexy(1,2*i)-20, linexy(2,2*i-1), linexy(1,2*i)+15, linexy(2,2*i-1)+80]);
                end
                
                post_run.dat{barsize(5,j)}.rating = rating_5d(x, j);
                post_run.dat{barsize(5,j)}.RT = post_run.dat{barsize(5,j)}.time(end) - ...
                    post_run.dat{barsize(5,j)}.time(1);
                
                %                         a_display_survey(z, seeds_i, target_i, words','whole');
                %Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
                %Screen('DrawLines', theWindow, [x, x; y+10 y-10], 6, orange);
                Screen('DrawLines', theWindow, [x, x; y+10 y-10], 6, red);
                
                Screen('Flip', theWindow);
                
                WaitSecs(.3);
                break;
            end
        end
    end
end

post_run.response_endtime = GetSecs;
Screen(theWindow, 'FillRect', bgcolor, window_rect);
if story_num ==1
    Screen('TextSize', theWindow, fontsize(2));
    start_msg = double('곧 다음 이야기를 시작하겠습니다. \n\n 글의 내용에 최대한 몰입해주세요. ') ;
    DrawFormattedText(theWindow, start_msg, 'center', 'center', white,  [], [], [], 1.5);
end

post_run.end_time = GetSecs;
data.postrunQ{story_num} = post_run;
    
end

function data = pico_int_valence(data, story_num, val_num)

global theWindow W H; % window property
global white red orange blue bgcolor tb ; % color
global window_rect text_color USE_EYELINK
global fontsize IVqT

tb = H/4;
IVqT = 5;

int_valence.start_time = GetSecs;
% QUESTION
title={'감정을 보고해주세요.'
    '부정' ;
    '보통' ;
    '긍정'};

linexy1 = [W/3 W*2/3 W/3 W/3 W/2 W/2 W*2/3 W*2/3;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7 H/2-7 H/2+7];
% linexy1 = [540 1380 540 540 960 960 1380 1380;
%     H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7 H/2-7 H/2+7];
% linexy2 = [W*3/8 W*5/8 W*3/8 W*3/8 W*5/8 W*5/8;
%     H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7];

question_start = GetSecs;
SetMouse(W/2, H/2);

while(1)
    % Track Mouse coordinate
    [mx, ~, button] = GetMouse(theWindow);
    
    x = (mx-W/2).*1.3+W/2;
    y = H/2;
    if x < W/3, x = W/3;
    elseif x > W*2/3, x = W*2/3;
    end
    Screen('TextSize', theWindow, fontsize(2));
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('DrawLines',theWindow, linexy1, 3, 255);
    DrawFormattedText(theWindow, double(title{1}), 'center', tb, white, [], [], [], 1.5);
    Screen('TextSize', theWindow, fontsize(1));
    DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, [],[],[],[],[],...
        [linexy1(1,1)-15, linexy1(2,1)+20, linexy1(1,1)+20, linexy1(2,1)+80]);
    DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, [],[],[],[],[],...
        [W/2-15, linexy1(2,1)+20, W/2+20, linexy1(2,1)+80]);
    DrawFormattedText(theWindow, double(title{4}),'center', 'center', white, [],[],[],[],[],...
        [linexy1(1,2)-15, linexy1(2,1)+20, linexy1(1,2)+20, linexy1(2,1)+80]);
    
    %Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
    Screen('DrawLine', theWindow, orange, x, y+10, x, y-10, 6);
    Screen('Flip', theWindow);
    
    if GetSecs - question_start >= IVqT
        button(1) = true;
    end
    
    if button(1)
        int_valence.rating{1} = 'during_story_valence';
        int_valence.rating{2} = (x-W/2)/(W/3);
        int_valence.rating{3} = GetSecs-question_start;
        rrtt = GetSecs;
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        Screen('TextSize', theWindow, fontsize(2));
        Screen('DrawLines',theWindow, linexy1, 3, 255);
        DrawFormattedText(theWindow, double(title{1}), 'center', tb, white, [], [], [], 1.5);
        Screen('TextSize', theWindow, fontsize(1));
        DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, [],[],[],[],[],...
            [linexy1(1,1)-15, linexy1(2,1)+20, linexy1(1,1)+20, linexy1(2,1)+80]);
        DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, [],[],[],[],[],...
            [W/2-15, linexy1(2,1)+20, W/2+20, linexy1(2,1)+80]);
        DrawFormattedText(theWindow, double(title{4}),'center', 'center', white, [],[],[],[],[],...
            [linexy1(1,2)-15, linexy1(2,1)+20, linexy1(1,2)+20, linexy1(2,1)+80]);
        
        % Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
        Screen('DrawLine', theWindow, red, x, y+10, x, y-10, 6)
        Screen('Flip', theWindow);
        waitsec_fromstarttime(rrtt, 0.5);
        Screen(theWindow, 'FillRect', bgcolor, window_rect)
        Screen('Flip', theWindow);
        int_valence.rating{4} = GetSecs;
        break;
    end
end

int_valence.end_time = GetSecs;
data.taskdat{story_num}{val_num}.int_valence = int_valence;

end

