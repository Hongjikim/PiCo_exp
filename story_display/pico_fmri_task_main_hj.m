function pico_fmri_task_main_hj(varargin)


%% DEFAULT

testmode = false;
USE_EYELINK = false;
USE_BIOPAC = false;
datdir = fullfile(pwd, 'data');
if ~exist(datdir, 'dir'), error('You need to run this code within the PiCo directory.'); end
addpath(genpath(pwd));


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
    load(ts_fname);
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
global fontsize window_rect text_color  % lb tb recsize barsize rec; % rating scale

% Screen setting
bgcolor = 100;
% window_ratio = 1;

text_color = 255;
fontsize = 42; %38?
%fontsize = 24; %30

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
    [theWindow, rect]=Screen('OpenWindow',0, [128 128 128], window_rect);%[0 0 2560/2 1440/2]
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    font = 'AppleGothic'; % check
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
            
            waitsec_fromstarttime(data.runscan_starttime, 13); 
            
            Screen(theWindow,'FillRect',bgcolor, window_rect);
            Screen('Flip', theWindow);
            
            waitsec_fromstarttime(data.runscan_starttime, 17); 
            
        else
            % Start second display
            start_msg = double('두 번째 이야기를 시작하겠습니다. \n\n 화면의 중앙에 단어가 나타날 예정이니 화면에 집중해주세요. \n\n 글의 내용에 최대한 몰입해주세요. ') ;
            DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
            sTime_2 = GetSecs;
            while GetSecs - sTime_2 < 5 % when the story is starting, wait for 5 seconds.
            end
        end
        
        
        for word_i = 1:numel(data.trial_sequence{story_num})
            
        end
        
        
        %
        %     data.loop_start_time{s_num} = GetSecs;
        %
        %     for i = 1:my_length
        %         sTime = GetSecs;
        %         data.dat{s_num}{i}.text_start_time = sTime;
        %         msg = doubleText(space_loc(i)+1:space_loc(i+1));
        %         data.dat{s_num}{i}.msg = char(msg);
        %         data.dat{s_num}{i}.duration = duration(i,2);
        %         letter_num = space_loc(i+1) - space_loc(i);
        %         DrawFormattedText(theWindow, msg, 'center', 'center', text_color);
        %         Screen('Flip', theWindow);
        %         while GetSecs - sTime < letter_time + base_time + abs(time_interval(i)) %0.31 %duration(i,2)
        %         end
        %         data.dat{s_num}{i}.text_end_time = GetSecs;
        %         if duration(i,1) > 1
        %             DrawFormattedText(theWindow, ' ', 'center', 'center', text_color);
        %             Screen('Flip', theWindow);
        %             while GetSecs - sTime < duration(i,2)
        %                 %waitsec_fromstarttime(data.loop_start_time{s_num}, 4);
        %             end
        %             data.dat{s_num}{i}.blank_end_time = GetSecs;
        %         end
        %         data.dat{s_num}{i}.text_end_time = GetSecs;
        %         if rem(i,5) == 0
        %             save(data.datafile, 'data', '-append');
        %         end
        %     end
        %
        %     data.loop_end_time{s_num} = GetSecs;
        %     save(data.datafile, 'data', '-append');
        %
        while GetSecs - sTime < 5
            % when the story is done, wait for 5 seconds. (in Blank)
        end
        
        rest_dur = 20;
        [data] = story_resting(rest_dur, data, s_num);
        
        save(data.datafile, 'data', '-append');
    end
    
    data.endtime_getsecs = GetSecs;
    save(data.datafile, 'data', '-append');
    
    KbStrokeWait;
    sca;
    
    
catch err
    
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    fclose(t);
    fclose(r);
    abort_error;
    
end

end


%% ====== SUBFUNCTIONS ======

% story_free_thinking

function data = story_display(ts, data, story_num)

end

function data = story_resting(rest_dur, data, story_num)

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect text_color% lb tb recsize barsize rec; % rating scale
global letter_time period_time comma_time base_time %window_ratio

resting_msg = double('이야기의 끝입니다.\n 지금부터는 중앙의 십자 표시를 바라보시며 \n 자유롭게 생각을 하시면 됩니다. \n 중간중간 과제가 나타날 예정입니다.') ;
DrawFormattedText(theWindow, resting_msg, 'center', 'center', text_color);
Screen('Flip', theWindow);

sTime = GetSecs;
while GetSecs - sTime < 10
    % when the story is done, wait for 5 seconds. (in Blank)
end

fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

sTime = GetSecs;
data.resting_start_time{s_num} = GetSecs;
while GetSecs - sTime < rest_dur
    % when the story is done, wait for 5 seconds. (in Blank)
end
data.resting_end_time{s_num} = GetSecs;

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