ffunction pico_fmri_task_main(varargin)


%% DEFAULT

testmode = false;
USE_EYELINK = false;
USE_BIOPAC = false;

basedir =  'C:\Users\Cocoanlab_WL01\Desktop\PiCo-master_0905';
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
data.datafile = fullfile(subject_dir, [subjdate, '_PICO_', sid, '_run', sprintf('%.2d', run_n), '.mat']);
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
global fontsize window_rect text_color rT USE_EYELINK ; %lb tb recsize barsize rec;

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
    [theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    font = 'Hangyeoregyeolche'; % check
    Screen('TextFont', theWindow, font);
    Screen('TextSize', theWindow, fontsize(2));
    if ~testmode, HideCursor; end
    
    %% SETUP: Eyelink
    % need to be revised when the eyelink is here.
    if USE_EYELINK
        edf_filename = ['E_S' sid(5:end), '_' sprintf('%.1d', run_n)]; % name should be equal or less than 8
        % E_S for STORY
        edfFile = sprintf('%s.EDF', edf_filename);
        eyelink_main(edfFile, 'Init');
        
        status = Eyelink('Initialize');
        if status
            error('Eyelink is not communicating with PC. Its okay baby.');
        end
        Eyelink('Command', 'set_idle_mode');
        waitsec_fromstarttime(GetSecs, .5);
    end
    
    %     %% PRACTICE: emotion rating
    %     practice_time = GetSecs;
    %     while (1)
    %         [~,~,keyCode] = KbCheck;
    %
    %         if keyCode(KbName('a'))==1
    %             break
    %         elseif keyCode(KbName('q'))==1
    %             abort_experiment('manual');
    %         end
    %
    %         Screen(theWindow, 'FillRect', bgcolor, window_rect);
    %         practice_emo = true;
    %         [practice.emotion_word, practice.emotion_time, ...
    %             practice.emotion_trajectory] = emotion_rating(practice_time, 'practice'); % sub-function
    %
    %         Screen('Flip', theWindow);
    %         practice_emo = false;
    %
    %     end
    %     WaitSecs(0.1);
    %     while (1)
    %         [~,~,keyCode] = KbCheck;
    %
    %         if keyCode(KbName('b'))==1
    %             break
    %         elseif keyCode(KbName('q'))==1
    %             abort_experiment('manual');
    %         end
    %
    %         Screen(theWindow, 'FillRect', bgcolor, window_rect);
    %         ready_prompt = double('잘하셨습니다! 이제 스캔을 시작하겠습니다. 불편한 점이 있다면, 지금 실험자에게 알려주세요.');
    %         DrawFormattedText(theWindow, ready_prompt,'center', 'center', white); %'center', 'textH'
    %         Screen('Flip', theWindow);
    %
    %     end
    %
    %
    %
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
                DrawFormattedText(theWindow, ready_prompt,'center', 'center', white, [], [], [], 1.5);
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
            
            waitsec_fromstarttime(data.runscan_starttime, 10); % For disdaq
            
            %% EYELINK AND BIOPAC START
            
            if USE_EYELINK
                Eyelink('StartRecording');
                data.eyetracker_starttime = GetSecs; % eyelink timestamp
                Eyelink('Message','Story Run start');
            end
            
            if USE_BIOPAC
                data.biopac_starttime = GetSecs; % biopac timestamp
                BIOPAC_trigger(ljHandle, biopac_channel, 'on');
                waitsec_fromstarttime(data.biopac_starttime, 1); %BIOPAC TRIGGER for START = 1sec
                BIOPAC_trigger(ljHandle, biopac_channel, 'off');
            end
            
            %% START FIRST STORY
            
            % 6 seconds for being ready
            
            %Screen('TextFont', theWindow, 'NanumGothicCoding');
            Screen('TextSize', theWindow, fontsize(3));
            start_msg = double('(디폴트)곧 화면 중앙에 단어가 나타날 예정이니 \n\n 글의 내용에 최대한 몰입해주세요. 123학착') ;
            DrawFormattedText(theWindow, start_msg, 'center', H/10, text_color);
            
            
            Screen('TextFont', theWindow, 'NanumGothicCoding');
            Screen('TextSize', theWindow, fontsize(3));
            start_msg = double('(코딩체)곧 화면 중앙에 단어가 나타날 예정이니 \n\n 글의 내용에 최대한 몰입해주세요. 123학착') ;
            DrawFormattedText(theWindow, start_msg, 'center', H/4+20, text_color);
            
            Screen('TextFont', theWindow, 'NanumGothic');
            Screen('TextSize', theWindow, fontsize(3));
            start_msg = double('(나눔고딕)곧 화면 중앙에 단어가 나타날 예정이니 \n\n 글의 내용에 최대한 몰입해주세요. 123학착') ;
            DrawFormattedText(theWindow, start_msg, 'center', H/2, text_color);
            
            
            
            
            % original
            %    Screen('TextSize', theWindow, fontsize(2));
            %             start_msg = double('곧 화면 중앙에 단어가 나타날 예정이니 \n\n 글의 내용에 최대한 몰입해주세요. 123학착') ;
            %             DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
            
            waitsec_fromstarttime(data.runscan_starttime, 14);
            
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            
            waitsec_fromstarttime(data.runscan_starttime, 17);
            
        else
            % Start second display
            Screen('TextSize', theWindow, fontsize(2));
            start_msg = double('다음 이야기를 시작하겠습니다. \n\n 곧 화면 중앙에 단어가 나타날 예정이니 \n\n 글의 내용에 최대한 몰입해주세요. ') ;
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
            Screen('TextSize', theWindow, fontsize(4));
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
                    rT = 6;
                    duration = duration + rT;
                    e_i = find(data.trial_sequence{story_num}{1}.rating_period_loc == word_i);
                    data.taskdat{story_num}{e_i}.valence_starttime = GetSecs;  % rating start timestamp
                    data.taskdat{story_num}{e_i}.int_valence = pico_int_valence(data, story_num)
                    waitsec_fromstarttime(sTime, duration);
                end
                
            end
            
            if rem(word_i,5) == 0
                save(data.datafile, 'data', '-append');
            end
        end
        
        data.loop_end_time{story_num} = GetSecs;
        save(data.datafile, 'data', '-append');
        
        while GetSecs - data.loop_end_time{story_num} < 5
            % when the story is done, wait for 5 seconds. (in Blank)
        end
        
        data.taskdat{story_num}{3}.valence_starttime = GetSecs;  % rating start timestamp
        data.tskdat{story_num}{3}.int_valence = pico_int_valence(data, story_num); % sub-function
        
        while GetSecs - data.taskdat{story_num}{3}.valence_starttime < 2 + rT
        end
        
        sTime_3 = GetSecs;
        while GetSecs - sTime_3 < 5
        end
        
        Screen('TextSize', theWindow, fontsize(4));
        fixation_point = double('+') ;
        DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        
        waitsec_fromstarttime(data.runscan_starttime, 140); % flexible time (maximum 300 sec of story)
        
        if USE_BIOPAC % resting start trigger (after 300 buffer time)
            BIOPAC_trigger(ljHandle, biopac_channel, 'on');
            waitsec_fromstarttime(GetSecs, 0.2); %BIOPAC TRIGGER for resting start (after buffer) = 0.2 secs
            BIOPAC_trigger(ljHandle, biopac_channel, 'off');
        end
        
        waitsec_fromstarttime(GetSecs, .1)
        
        if USE_EYELINK
            Eyelink('Message','Resting start');
        end
        
        data = story_free(data, story_num); %free thinking for story!
        
        save(data.datafile, 'data', '-append');
        
        if USE_EYELINK
            Eyelink('Message','Rest end');
        end
        
        nTime = GetSecs;
        while GetSecs - nTime <5
            Screen('TextSize', theWindow, fontsize(2));
            run_end_msg = double('이번 이야기가 끝났습니다. 나타나는 질문들에 답변해주세요.') ;
            DrawFormattedText(theWindow, run_end_msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
        end
        data.taskdat{story_num}{4}.concent_starttime = GetSecs;  % rating start timestamp
        [data.taskdat{story_num}{4}.concentration, data.taskdat{story_num}{4}.concent_time, ...
            data.taskdat{story_num}{4}.concent_trajectory] = concent_rating(data.taskdat{story_num}{4}.concent_starttime); % sub-function
        
        data.taskdat{story_num}{5}.concent_starttime = GetSecs;  % rating start timestamp
        [data.taskdat{story_num}{5}.familiarity, data.taskdat{story_num}{5}.familiarity_time, ...
            data.taskdat{story_num}{5}.familiarity_trajectory] = familiar_rating(data.taskdat{story_num}{5}.concent_starttime); % sub-function
        
        data = story_survey(data, story_num); % post_run questionnaire after each FT
        
        save(data.datafile, 'data', '-append');
        
    end
    
    %% RUN END MESSAGE
    save(data.datafile, 'data', '-append');
    
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('TextSize', theWindow, fontsize(2));
    run_end_msg = '잘하셨습니다. 잠시 대기해 주세요.';
    DrawFormattedText(theWindow, double(run_end_msg), 'center', 'center', white);
    Screen('Flip', theWindow);
    
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
    save(data.datafile, 'data', '-append');
    
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space')) == 1
            break
        end
    end
    
    ShowCursor();
    Screen('Clear');
    Screen('CloseAll');
    
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


function data = story_free(data, story_num)

global theWindow W H; % window property
global  window_rect text_color window_ratio textH % lb tb recsize barsize rec; % rating scale
global fontsize

Screen('TextSize', theWindow, fontsize(4));
fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

resting_sTime = GetSecs;
data.resting{story_num}.fixation_start_time = resting_sTime;

rng('shuffle')
% sampling_time = [50 100] + randi(10,1,2) - 5;
sampling_time = [10 20] + randi(10,1,2) - 5;  % EDIT
data.resting{story_num}.sampling_time = sampling_time;


while GetSecs - resting_sTime < 40 %150 EDIT
    for i = 1:2
        while GetSecs - resting_sTime > (sampling_time(i) - 2.5) && GetSecs - resting_sTime < (sampling_time(i) + 2.5)
            data.resting{story_num}.start_Sampling{i} = GetSecs;
            Screen('TextSize', theWindow, fontsize(3));
            FT_msg = double('지금 무슨 생각을 하고 있는지 단어나 구로 말해주세요.') ;
            DrawFormattedText(theWindow, FT_msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
        end
        data.resting{story_num}.end_Sampling{i} = GetSecs;
        Screen('TextSize', theWindow, fontsize(4));
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

while GetSecs - data.resting{story_num}.fixation_end_time <5
    Screen('TextSize', theWindow, fontsize(3));
    end_msg = double('지금 무슨 생각을 하고 있는지 단어나 구로 말해주세요.') ;
    DrawFormattedText(theWindow, end_msg, 'center', 'center', text_color);
    Screen('Flip', theWindow);
end


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
    %     practice_msg = double('이야기 중간중간에 나오는 감정 평가를 연습해보겠습니다. \n 실험자의 지시에 따라 트랙볼을 움직여주세요.');
    %
    %     if practice_emo == true;
    %         DrawFormattedText(theWindow, practice_msg,'center', H/4-20, white, [], [], [], 1.2);
    %     end
    
    
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
    Screen('FrameRect', theWindow, colors, CenterRectOnPoint(square,xy(i,1),xy(i,2)),5); %check, 3
end
% Choice letter
for i = 1:numel(choice)
    fontsize = 36;
    Screen('TextSize', theWindow, fontsize);
    DrawFormattedText(theWindow, double(choice{i}), 'center', 'center', white, [],[],[],[],[],xy_word(i,:));
end

end

function [concentration, trajectory_time, trajectory] = concent_rating(starttime)

global W H orange bgcolor window_rect theWindow red white cqT
global fontsize
intro_prompt1 = double('방금 나타난 이야기에 얼마나 집중할 수 있었나요?');
intro_prompt2 = double('트랙볼을 움직여서 집중한 정도를 클릭해주세요.');
title={'전혀','보통', '매우'};

SetMouse(W/2, H/2);
cqT = 8;
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
    
    Screen('TextSize', theWindow, fontsize(2));
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('DrawLines',theWindow, xy, 5, 255);
    
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
    
    Screen('DrawDots', theWindow, [x y], 10, orange, [0, 0], 1); % draw orange dot on the cursor
    Screen('Flip', theWindow);
    
    trajectory(j,1) = (x-W/2)/(W/3);    % trajectory of location of cursor
    trajectory_time(j,1) = GetSecs - starttime; % trajectory of time
    
    if trajectory_time(end) >= cqT  % maximum time of rating is 5s
        button(1) = true;
    end
    
    if button(1)  % After click, the color of cursor dot changes.
        Screen('TextSize', theWindow, fontsize(2));
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('DrawLines',theWindow, xy, 5, 255);
        DrawFormattedText(theWindow, intro_prompt1,'center', H/4, white);
        DrawFormattedText(theWindow, intro_prompt2,'center', H/4+40, white);
        % Draw scale letter
        Screen('TextSize', theWindow, fontsize(1));
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

function [familiarity, trajectory_time, trajectory] = familiar_rating(starttime)

global W H orange bgcolor window_rect theWindow red fontsize white cqT

intro_prompt1 = double('방금 나타난 이야기가 얼마나 새로웠나요?');
intro_prompt2 = double('트랙볼을 움직여서 새로웠던 정도를 클릭해주세요.');
title={'전혀','보통', '매우'};

SetMouse(W/2, H/2);
cqT = 8;
trajectory = [];
trajectory_time = [];
xy = [W/3 W*2/3 W/3 W/3 W*2/3 W*2/3;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7];

j = 0;

while(1)
    j = j + 1;
    [mx, ~, button] = GetMouse(theWindow);
    
    x = mx;
    y = H/2;
    if x < W/3, x = W/3;
    elseif x > W*2/3, x = W*2/3;
    end
    
    Screen('TextSize', theWindow, fontsize(2));
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('DrawLines',theWindow, xy, 5, 255);
    
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
    
    Screen('DrawDots', theWindow, [x y], 10, orange, [0, 0], 1); % draw orange dot on the cursor
    Screen('Flip', theWindow);
    
    trajectory(j,1) = (x-W/2)/(W/3);    % trajectory of location of cursor
    trajectory_time(j,1) = GetSecs - starttime; % trajectory of time
    
    if trajectory_time(end) >= cqT  % maximum time of rating is 5s
        button(1) = true;
    end
    
    if button(1)  % After click, the color of cursor dot changes.
        Screen('TextSize', theWindow, fontsize(2));
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('DrawLines',theWindow, xy, 5, 255);
        DrawFormattedText(theWindow, intro_prompt1,'center', H/4, white);
        DrawFormattedText(theWindow, intro_prompt2,'center', H/4+40, white);
        % Draw scale letter
        Screen('TextSize', theWindow, fontsize(1));
        DrawFormattedText(theWindow, double(title{1}),'center', 'center', white, ...
            [],[],[],[],[], [xy(1,1)-70, xy(2,1), xy(1,1)+20, xy(2,1)+60]);
        DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, ...
            [],[],[],[],[], [W/2-15, xy(2,1), W/2+20, xy(2,1)+60]);
        DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, ...
            [],[],[],[],[], [xy(1,2)+45, xy(2,1), xy(1,2)+20, xy(2,1)+60]);
        Screen('DrawDots', theWindow, [x;y], 10, red, [0 0], 1);
        Screen('Flip', theWindow);
        
        familiarity = (x-W/3)/(W/3);  % 0~1
        
        WaitSecs(0.3);
        
        break;
    end
end
end

function data = pico_post_run_survey(data, story_num)

global theWindow W H; % window property
global white red orange blue bgcolor tb ; % color
global window_rect USE_EYELINK
global fontsize

tb = H/5;
rT_post = 6;

post_run.start_time = GetSecs;

question_type = {'Valence','Self','Time','Vividness','Safe&Threat'};

save(data.datafile, 'data', '-append');

% QUESTION
title={'방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 일으킨 감정은 무엇인가요?',...
    '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 나와 관련이 있는 정도는 어느 정도인가요?',...
    '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 가장 관련이 있는 자신의 시간은 언제인가요?', ...
    '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 어떤 상황이나 장면을 생생하게 떠올리게 했나요?',...
    '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 안전 또는 위협을 의미하거나 느끼게 했나요?',...
    '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 방금 연상한 단어와 관련된 생각이었나요?';
    '부정', '전혀 나와\n관련이 없음', '과거', '전혀 생생하지 않음', '위협', '전혀 관련 없음';
    '보통', '보통', '현재', '보통', '보통', '보통';
    '긍정','나와 관련이\n매우 많음', '미래','매우 생생함','안전','매우 관련 있음'};

linexy1 = [W/4 W*3/4 W/4 W/4 W/2 W/2 W*3/4 W*3/4;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7 H/2-7 H/2+7];
linexy2 = [W*3/8 W*5/8 W*3/8 W*3/8 W*5/8 W*5/8;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7];
rng('shuffle');
z = randperm(5);


for i = 1:(numel(title(1,:))-1)
    if mod(z(i),2) % odd number, valence, time, safe&threat
        question_start = GetSecs;
        SetMouse(W/2, H/2);
        
        while(1)
            % Track Mouse coordinate
            [mx, ~, button] = GetMouse(theWindow);
            
            x = mx;
            y = H/2;
            if x < W/4, x = W/4;
            elseif x > W*3/4, x = W*3/4;
            end
            fontsize = fontsize_m;
            Screen('TextSize', theWindow, fontsize);
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            Screen('DrawLines',theWindow, linexy1, 3, 255);
            DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
            fontsize = fontsize_s;
            Screen('TextSize', theWindow, fontsize);
            DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [linexy1(1,1)-15, linexy1(2,1)+20, linexy1(1,1)+20, linexy1(2,1)+80]);
            DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [W/2-15, linexy1(2,1)+20, W/2+20, linexy1(2,1)+80]);
            DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [linexy1(1,2)-15, linexy1(2,1)+20, linexy1(1,2)+20, linexy1(2,1)+80]);
            
            Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
            Screen('Flip', theWindow);
            
            if GetSecs - question_start >= rT_post
                button(1) = true;
            end
            
            if button(1)
                post_run.rating{1,z(i)} = question_type{z(i)};
                post_run.rating{2,z(i)} = (x-W/2)/(W/4);
                post_run.rating{3,z(i)} = GetSecs-question_start;
                rrtt = GetSecs;
                
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                fontsize = fontsize_m;
                Screen('TextSize', theWindow, fontsize);
                Screen('DrawLines',theWindow, linexy1, 3, 255);
                DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
                fontsize = fontsize_s;
                Screen('TextSize', theWindow, fontsize);
                DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy1(1,1)-15, linexy1(2,1)+20, linexy1(1,1)+20, linexy1(2,1)+80]);
                DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [W/2-15, linexy1(2,1)+20, W/2+20, linexy1(2,1)+80]);
                DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy1(1,2)-15, linexy1(2,1)+20, linexy1(1,2)+20, linexy1(2,1)+80]);
                
                Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
                Screen('Flip', theWindow);
                waitsec_fromstarttime(rrtt, 0.5);
                post_run.rating{4,z(i)} = GetSecs;
                break;
            end
        end
        
    else   % even number, self-relevance, vividness
        question_start = GetSecs;
        SetMouse(W*3/8, H/2);
        
        while(1)
            % Track Mouse coordinate
            [mx, ~, button] = GetMouse(theWindow);
            
            x = mx;
            y = H/2;
            if x < W*3/8, x = W*3/8;
            elseif x > W*5/8, x = W*5/8;
            end
            fontsize = fontsize_m;
            Screen('TextSize', theWindow, fontsize);
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            Screen('DrawLines',theWindow, linexy2, 3, 255);
            DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
            fontsize = fontsize_s;
            Screen('TextSize', theWindow, fontsize);
            DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [linexy2(1,1)-15, linexy2(2,1)+20, linexy2(1,1)+20, linexy2(2,1)+80]);
            DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [W/2-15, linexy2(2,1)+20, W/2+20, linexy2(2,1)+80]);
            DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [linexy2(1,2)-15, linexy2(2,1)+20, linexy2(1,2)+20, linexy2(2,1)+80]);
            
            Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
            Screen('Flip', theWindow);
            
            if GetSecs - question_start >= rT_post
                button(1) = true;
            end
            
            if button(1)
                post_run.rating{1,z(i)} = question_type{z(i)};
                post_run.rating{2,z(i)} = (x-W*3/8)/(W/4);
                post_run.rating{3,z(i)} = GetSecs-question_start;
                rrtt = GetSecs;
                fontsize = fontsize_s;
                Screen('TextSize', theWindow, fontsize);
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                Screen('DrawLines',theWindow, linexy2, 3, 255);
                DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
                fontsize = fontsize_m;
                Screen('TextSize', theWindow, fontsize);
                DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy2(1,1)-15, linexy2(2,1)+20, linexy2(1,1)+20, linexy2(2,1)+80]);
                DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [W/2-15, linexy2(2,1)+20, W/2+20, linexy2(2,1)+80]);
                DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy2(1,2)-15, linexy2(2,1)+20, linexy2(1,2)+20, linexy2(2,1)+80]);
                
                Screen('DrawDots', theWindow, [x;y], 9, red, [0 0], 1);
                Screen('Flip', theWindow);
                if USE_EYELINK
                    Eyelink('Message','Rest Question response');
                end
                waitsec_fromstarttime(rrtt, 0.5);
                post_run.rating{4,z(i)} = GetSecs;
                break;
            end
        end
    end
end

WaitSecs(.1);

post_run.end_time = GetSecs;

data.postrunQ{story_num} = post_run ;

save(data.datafile, 'data', '-append');

end

function data = pico_int_valence(data, story_num)

global theWindow W H; % window property
global white red orange blue bgcolor tb ; % color
global window_rect text_color USE_EYELINK
global fontsize

tb = H/5;
rT_valence = 6;

int_valence.start_time = GetSecs;

save(data.datafile, 'data', '-append');

% QUESTION
title={'감정을 보고해주세요.'
    '부정' ;
    '보통' ;
    '긍정'};

linexy1 = [W/4 W*3/4 W/4 W/4 W/2 W/2 W*3/4 W*3/4;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7 H/2-7 H/2+7];
linexy2 = [W*3/8 W*5/8 W*3/8 W*3/8 W*5/8 W*5/8;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7];

question_start = GetSecs;
% SetMouse(W/2, H/2);

while(1)
    % Track Mouse coordinate
    [mx, ~, button] = GetMouse(theWindow);
    
    x = mx;
    y = H/2;
    if x < W/4, x = W/4;
    elseif x > W*3/4, x = W*3/4;
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
    
    Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
    Screen('Flip', theWindow);
    
    if GetSecs - question_start >= rT_valence
        button(1) = true;
    end
    
    if button(1)
        int_valence.rating{1} = 'during_story_valence';
        int_valence.rating{2} = (x-W/2)/(W/4);
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
        
        Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(rrtt, 0.5);
        int_valence.rating{4} = GetSecs;
        break;
    end
end

WaitSecs(.1);

int_valence.end_time = GetSecs;

data.int_valence{story_num} = int_valence ;

save(data.datafile, 'data', '-append');

end


function survey = story_survey(words, varargin)

global theWindow W H; % window property
global white red orange blue bgcolor tb ; % color
global window_rect text_color USE_EYELINK
global fontsize lb recsize barsize rec story_num; % rating scale

lb=W*8/128;     %110        when W=1280
tb=H*18/80;     %180

recsize=[W*450/1280 H*175/800];
barsizeO=[W*340/1280, W*180/1280, W*340/1280, W*180/1280, W*340/1280, 0;
    10, 10, 10, 10, 10, 0; 10, 0, 10, 0, 10, 0;
    10, 10, 10, 10, 10, 0; 1, 2, 3, 4, 5, 0];
rec=[lb,tb; lb+recsize(1),tb; lb,tb+recsize(2); lb+recsize(1),tb+recsize(2);
    lb,tb+2*recsize(2); lb+recsize(1),tb+2*recsize(2)]; %6개 사각형의 왼쪽 위 꼭짓점의 좌표

survey.start_time = GetSecs;

z= randperm(6);
barsize = barsizeO(:,z);

for j=1:numel(barsize(5,:))
    if ~barsize(5,j) == 0 % if barsize(5,j) = 0, skip the scale
        % if Self, Vivid question, set curson on the left.
        % the other, set curson on the center.
        if mod(barsize(5,j),2) == 0
            SetMouse(rec(j,1)+(recsize(1)-barsize(1,j))/2, rec(j,2)+recsize(2)/2);
        else
            SetMouse(rec(j,1)+recsize(1)/2, rec(j,2)+recsize(2)/2);
        end
        
        %         rec_i = 0;
        %         survey.dat{target_i, seeds_i}{barsize(5,j)}.trajectory = [];
        %         survey.dat{target_i, seeds_i}{barsize(5,j)}.time = [];
        
        starttime = GetSecs; % Each question start time
        rec_i = 0;
        
        while(1)
            % Track Mouse coordinate
            [mx, ~, button] = GetMouse(theWindow);
            
            x = mx;  % x of a color dot
            y = rec(j,2)+recsize(2)/2;
            if x < rec(j,1)+(recsize(1)-barsize(1,j))/2, x = rec(j,1)+(recsize(1)-barsize(1,j))/2;
            elseif x > rec(j,1)+(recsize(1)+barsize(1,j))/2, x = rec(j,1)+(recsize(1)+barsize(1,j))/2;
            end
            
            % display scales and cursor
            disp_inst = double('방금 자유 생각 시간에 하신 생각에 대해 답변해주세요.');
            b_display_survey(z, disp_inst, 'whole');
            % Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
            Screen('DrawLine', theWindow, orange, x, y+5, x, y-5, 6);
            Screen('Flip', theWindow);
            
            % Get trajectory
            rec_i = rec_i+1; % the number of recordings
            survey.dat{target_i, seeds_i}{barsize(5,j)}.trajectory(rec_i,1) = rating(x, j);
            survey.dat{target_i, seeds_i}{barsize(5,j)}.time(rec_i,1) = GetSecs - starttime;
            
            if button(1)
                survey.dat{target_i, seeds_i}{barsize(5,j)}.rating = rating(x, j);
                survey.dat{target_i, seeds_i}{barsize(5,j)}.RT = ...
                    survey.dat{target_i, seeds_i}{barsize(5,j)}.time(end) - ...
                    survey.dat{target_i, seeds_i}{barsize(5,j)}.time(1);
                
                a_display_survey(z, seeds_i, target_i, words,'whole');
                Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
                Screen('Flip', theWindow);
                
                WaitSecs(.3);
                break;
            end
        end
    end
    
    % save 5 questions data every trial (one word pair)
    data.post_survey{story_num} = survey ;
    save(data.datafile, 'data', '-append');
end

WaitSecs(.3);

data.post_survey{story_num} = survey ;
save(data.datafile, 'data', '-append');
end