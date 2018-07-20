function pico_fmri_resting(varargin)


%% DEFAULT

testmode = false;
USE_EYELINK = false;
USE_BIOPAC = false;

basedir = '/Users/hongji/Dropbox/PiCo_git'; %edit
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

ft_num = input('FREE THKINING Run number? (1 or 2): ');

%% CREATE AND SAVE DATA

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = sid;
data.datafile = fullfile(subject_dir, [subjdate, '_PICO_', sid, 'FT_run', sprintf('%.2d', ft_num), '.mat']);
data.version = 'PICO_v0_05-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;
% data.trial_sequence = ts{run_n};

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
fontsize = 42; %60?
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
    
    
    %% FREE THINKING START
    
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
    start_msg = double('화면에 + 표시가 나타나면, 자유 생각을 시작하세요. \n + 표시가 사라질 때 마다 지시문에 답변을 해주세요.') ;
    DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.runscan_starttime, 14);
    
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.runscan_starttime, 17);
    
    
    data.freethinking_start_time{ft_num} = GetSecs;
    sTime = data.freethinking_start_time{ft_num};
    
    
    save(data.datafile, 'data', '-append');
    
    
    data = free_thinking(data, ft_num); %free thinking without story!
    save(data.datafile, 'data', '-append');
    
    nTime = GetSecs;
    while GetSecs - nTime <5
        run_end_msg = double('이번 세션이 끝났습니다. 나타나는 질문들에 답변해주세요.') ;
        DrawFormattedText(theWindow, run_end_msg, 'center', 'center', text_color);
        Screen('Flip', theWindow);
    end
    
    data.endtime_getsecs = GetSecs;
    save(data.datafile, 'data', '-append');
    
    data = pico_post_run_survey_resting(data, ft_num); %free thinking for story!
    save(data.datafile, 'data', '-append');
    
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


function data = free_thinking(data, ft_num)

global theWindow W H; % window property
global fontsize window_rect text_color window_ratio textH % lb tb recsize barsize rec; % rating scale

fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

resting_sTime = GetSecs;
data.resting{ft_num}.fixation_start_time = resting_sTime;

rng('shuffle')
sampling_time = [60 120 180 240 300] + randi(10,1,5) - 5;
data.resting{ft_num}.sampling_time = sampling_time;


while GetSecs - resting_sTime < 360
    for i = 1:5
        while GetSecs - resting_sTime > (sampling_time(i) - 2.5) && GetSecs - resting_sTime < (sampling_time(i) + 2.5)
            data.resting{ft_num}.start_Sampling{i} = GetSecs;
            FT_msg = double('지금 무슨 생각을 하고 있는지 단어나 구로 말해주세요.') ;
            DrawFormattedText(theWindow, FT_msg, 'center', 'center', text_color);
            Screen('Flip', theWindow);
        end
        data.resting{ft_num}.end_Sampling{i} = GetSecs;
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

data.resting{ft_num}.fixation_end_time = GetSecs;


while GetSecs - data.resting{ft_num}.fixation_end_time <5
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



function data = pico_post_run_survey_resting(data, ft_num, varargin)

global theWindow W H; % window property
global white red orange blue bgcolor tb ; % color
global fontsize window_rect text_color window_ratio
tb = H/5;
question_type = {'Valence','Self','Time','Vividness','Safe&Threat'};

for i = 1:5
    data.post_run_rating{i} = question_type{i};
end

save(data.datafile, 'data', '-append');
    
% QUESTION
    title={'방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 일으킨 감정은 무엇인가요?',...
        '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 나와 관련이 있는 정도는 어느 정도인가요?',...
        '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 가장 관련이 있는 자신의 시간은 언제인가요?', ...
        '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 어떤 상황이나 장면을 생생하게 떠올리게 했나요?',...
        '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 안전 또는 위협을 의미하거나 느끼게 했나요?',...
        '방금 자유 생각 과제를 하는 동안 자연스럽게 떠올린 생각에 대한 질문입니다.\n\n그 생각이 방금 연상한 단어와 관련된 생각이었나요?';
        '부정', '전혀 나와\n관련이 없음', '과거', '전혀 생생하지 않음', '위협', '전혀 관련 없음';
        '중립', '', '현재', '', '중립', '';
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
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                Screen('DrawLines',theWindow, linexy1, 3, 255);
                DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
                DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy1(1,1)-15, linexy1(2,1)+20, linexy1(1,1)+20, linexy1(2,1)+80]);
                DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [W/2-15, linexy1(2,1)+20, W/2+20, linexy1(2,1)+80]);
                DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy1(1,2)-15, linexy1(2,1)+20, linexy1(1,2)+20, linexy1(2,1)+80]);
                
                Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
                Screen('Flip', theWindow);
                
                if button(1)
                    rest.rating{2,z(i)} = (x-W/2)/(W/4);
                    rest.rating{3,z(i)} = GetSecs-question_start;
                    rrtt = GetSecs;
                    
                    Screen(theWindow, 'FillRect', bgcolor, window_rect);
                    Screen('DrawLines',theWindow, linexy1, 3, 255);
                    DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
                    
                    DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                        [linexy1(1,1)-15, linexy1(2,1)+20, linexy1(1,1)+20, linexy1(2,1)+80]);
                    DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                        [W/2-15, linexy1(2,1)+20, W/2+20, linexy1(2,1)+80]);
                    DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                        [linexy1(1,2)-15, linexy1(2,1)+20, linexy1(1,2)+20, linexy1(2,1)+80]);
                    
                    Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
                    Screen('Flip', theWindow);
%                     if USE_EYELINK
%                         Eyelink('Message','Rest Question response');
%                     end
                    waitsec_fromstarttime(rrtt, 0.5);
                    rest.rating{4,z(i)} = GetSecs;
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
                
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                Screen('DrawLines',theWindow, linexy2, 3, 255);
                DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
                
                DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy2(1,1)-15, linexy2(2,1)+20, linexy2(1,1)+20, linexy2(2,1)+80]);
                DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [W/2-15, linexy2(2,1)+20, W/2+20, linexy2(2,1)+80]);
                DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy2(1,2)-15, linexy2(2,1)+20, linexy2(1,2)+20, linexy2(2,1)+80]);
                
                Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
                Screen('Flip', theWindow);
                
                if button(1)
                    rest.rating{2,z(i)} = (x-W*3/8)/(W/4);
                    rest.rating{3,z(i)} = GetSecs-question_start;
                    rrtt = GetSecs;
                    
                    Screen(theWindow, 'FillRect', bgcolor, window_rect);
                    Screen('DrawLines',theWindow, linexy2, 3, 255);
                    DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
                    
                    DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                        [linexy2(1,1)-15, linexy2(2,1)+20, linexy2(1,1)+20, linexy2(2,1)+80]);
                    DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                        [W/2-15, linexy2(2,1)+20, W/2+20, linexy2(2,1)+80]);
                    DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                        [linexy2(1,2)-15, linexy2(2,1)+20, linexy2(1,2)+20, linexy2(2,1)+80]);
                    
                    Screen('DrawDots', theWindow, [x;y], 9, red, [0 0], 1);
                    Screen('Flip', theWindow);
%                     if USE_EYELINK
%                         Eyelink('Message','Rest Question response');
%                     end
                    waitsec_fromstarttime(rrtt, 0.5);
                    rest.rating{4,z(i)} = GetSecs;
                    break;
                end
            end
        end
    end
    WaitSecs(.1);

    data.rest = rest ;

save(data.datafile, 'data', '-append');
    
end

