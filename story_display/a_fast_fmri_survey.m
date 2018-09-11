function survey = a_fast_fmri_survey(words, varargin)
%
%   survey.dat{target_i,seeds_i}{barsize(5,j)}.tracjectory
%   survey.dat{target_i,seeds_i}{barsize(5,j)}.time
%   survey.dat{target_i,seeds_i}{barsize(5,j)}.rating
%                               for bodymap, rating_red & rating_blue
%   survey.dat{target_i,seeds_i}{barsize(5,j)}.RT
%
%       for example,
%   survey.dat{target_i,seeds_i}{1}.tracjectory = 'Valence'
%   survey.dat{target_i,seeds_i}{2}.tracjectory = 'Self-relevance'
%   survey.dat{target_i,seeds_i}{3}.tracjectory = 'Time'
%   survey.dat{target_i,seeds_i}{4}.tracjectory = 'Vividness'
%   survey.dat{target_i,seeds_i}{5}.tracjectory = 'SafetyThreat'
%   survey.dat{target_i,seeds_i}{6}.tracjectory = 'Bodymap'
%
%
%% default setting

basedir =  '/Users/hongji/Dropbox/PiCo_git';
datdir = fullfile(basedir, 'data') ;
sid = input('Subject ID? (e.g., pico001): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');
[~, sid] = fileparts(subject_dir);

testmode = false;
practice_mode = false;
savedir = subject_dir;
%psychtoolboxdir = '/Users/byeoletoile/Documents/MATLAB/Psychtoolbox';

% addpath(genpath(psychtoolboxdir));
addpath(genpath(pwd));
rng('shuffle');

%% CREATE AND SAVE DATA

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = sid;
survey.surveyfile = fullfile(savedir, ['surveydata_sub' sid '.mat']) ;
data.version = 'PICO_v1_09-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

if exist(survey.surveyfile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', data.subject, subjdate);
    cont_or_not = input(['\nYou type the run number that is inconsistent with the data previously saved.', ...
        '\nWill you go on with your run number that typed just before?', ...
        '\n1: Yes, continue with typed run number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Breaked.')
    elseif cont_or_not == 1
        save(survey.surveyfile, 'data', 'survey');
    end
else
    save(survey.surveyfile, 'data', 'survey');
end

%% PARSING OUT OPTIONAL INPUT
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'practice'}
                practice_mode = true;
            case {'test', 'testmode'}
                testmode = true;
            case {'savedir'}
                savedir = varargin{i+1};
        end
    end
end

%% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb bodymap recsize barsize rec; % rating scale

%% SETUP: Screen

bgcolor = 100;

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/2 ;
% if testmode
%     window_rect = [0 0 1260 760]; % in the test mode, use a little smaller screen
% else
%     window_rect1 = get(0, 'MonitorPositions'); % full screen
%     window_rect = [ 0 0 window_rect1(3) window_rect1(4)];
%     if size(window_rect1,1)>1   % for Byeol's desk, when there are two moniter
%         window_rect = window_rect1(1,:);
%     end
% end

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

font = 'NanumBarunGothic';
fontsize = 25;

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];

lb=W*8/128;     %110        when W=1280
tb=H*18/80;     %180

recsize=[W*450/1280 H*175/800];
barsizeO=[W*340/1280, W*180/1280, W*340/1280, W*180/1280, W*340/1280, 0;
    10, 10, 10, 10, 10, 0; 10, 0, 10, 0, 10, 0;
    10, 10, 10, 10, 10, 0; 1, 2, 3, 4, 5, 0];
rec=[lb,tb; lb+recsize(1),tb; lb,tb+recsize(2); lb+recsize(1),tb+recsize(2);
    lb,tb+2*recsize(2); lb+recsize(1),tb+2*recsize(2)]; %6�� �簢���� ���� �� �������� ��ǥ

bodymap = imread('imgs/bodymap_bgcolor.jpg');
bodymap = bodymap(:,:,1);
[body_y, body_x] = find(bodymap(:,:,1) == 255);

bodymap([1:10 791:800], :) = [];
bodymap(:, [1:10 1271:1280]) = []; % make the picture smaller


%% SETUP: DATA and Subject INFO

start_line = 1;

if ~practice_mode % if not practice mode, save the data
    
    %[fname, start_line, sid] = subjectinfo_check(savedir, 'survey'); % subfunction
    if numel(start_line) == 2  % restart condition
        load(fname, 'survey')
        % initial save of trial sequence and data
        survey.surveyfile = fullfile(savedir, ['d_surveydata_sub' sid '.mat']);
        save(survey.surveyfile, 'survey', '-append');
        
    else  % First start condition, make new file
        % add some task information
%         survey.version = 'FAST_fmri_task_v1_12-05-2017';
%         survey.github = 'https://github.com/ByeolEtoileKim/fast_fmri_v1';
        survey.subject = sid;
        survey.wordfile = fullfile(savedir, ['WORDSAMPLING_' sid '_run1.mat']);
%        survey.responsefile = fullfile(savedir, ['b_responsedata_sub' sid '_sessnumber.mat']);
 %       survey.taskfile = fullfile(savedir, ['c_taskdata_sub' sid '_sessnumber.mat']);
        survey.surveyfile = fullfile(savedir, ['surveydata_sub' sid '.mat']);
%         survey.restingfile = fullfile(savedir, ['e_restingdata_sub' sid '.mat']);
        survey.dat_descript = {'survey.dat{target_i,seeds_i}';'6 Questions'; '1:Valence'; '2:Self-relevance'; '3:Time'; '4:Vividness'; '5:SafetyThreat'; '6:Bodymap'};
        survey.body_xy = [body_x body_y];     % coordinate inside of body
        survey.words = words;
        survey.exp_starttime = datestr(clock, 0); % date-time: timestamp of first start
        survey.dat = cell(size(words,1)-1, size(words,2));  % 40x4 cell
        save(survey.surveyfile, 'survey');
    end
end


%% Survey start: =========================================================

%% START: Screen
Screen('Preference', 'SkipSyncTests', 1); 
theWindow = Screen('OpenWindow', 0, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize);
HideCursor;

%% PROMPT SETUP:
practice_prompt{1} = double('���ݺ��� ��ĳ�ʿ��� ���� �ܾ��� ���ð� ȭ�� ���ʿ� ������� ������ ���Դϴ�.');
practice_prompt{2} = double('�ܾ�� �Բ� ��� ������ ��Ÿ���ٵ�');
practice_prompt{3} = double('�� �ܾ ���ø� �ƶ��� �����Ͽ� �� ������ �����ϰ� �������ּ���.');
practice_prompt{4} = double('���⼭ �ƶ��̶� ������ �� �ܾ ���÷��� ��ÿ� ������ �������� ���� Ȥ�� ������ �ǹ��մϴ�.');
practice_prompt{5} = double('Ȥ�� �� �ܾ ���÷��� ���� �ƶ��� ��ﳪ�� ������ ���� �������� �������� ���� Ȥ�� ������ ���� �����ּ���.');
%�� �ǹ��մϴ�
%���⼭ �ƶ��̶� �Ϲ����� �ܾ� ������ ���踦 �ǹ��ϴ� ���� �ƴ϶�,');
%practice_prompt{5} = double('������ �� �ܾ ���÷��� ��ÿ� ������ �������� ���� Ȥ�� ������ �ǹ��մϴ�.');
practice_prompt{6} = double('�ѹ� Ŭ���� ���� �ǵ��� �� ������ �����ϰ� Ŭ�����ּ���.');
practice_prompt{7} = double('\n��� ������ �غ��ڽ��ϴ�. �����Ϸ��� �����̽��� �����ּ���.');

ready_prompt{1} = double('���ݺ��� ��ĳ�ʿ��� ���� �� �ܾ ȭ�� ���ʿ� ������� ������ ���Դϴ�.');
ready_prompt{2} = double('�ܾ�� �Բ� ��� ������ ��Ÿ���ٵ�');
ready_prompt{3} = double('�� �ܾ ���ø� �ƶ��� �����Ͽ� �� ������ �����ϰ� �������ּ���.');
ready_prompt{4} = double('���⼭ �ƶ��̶� ������ �� �ܾ ���÷��� ��ÿ� ������ �������� ���� Ȥ�� ������ �ǹ��մϴ�.');
ready_prompt{5} = double('Ȥ�� �� �ܾ ���÷��� ���� �ƶ��� ��ﳪ�� ������ ���� �������� �������� ���� Ȥ�� ������ ���� �����ּ���..');
ready_prompt{6} = double('�ѹ� Ŭ���� ���� �ǵ��� �� ������ �����ϰ� Ŭ�����ּ���');
ready_prompt{7} = double(' ');
ready_prompt{8} = double('������ �� 6���� ��Ʈ�� �̷���� ������ ��Ʈ�� ���� ������ �޽��� ���ϼŵ� �����ϴ�.');
ready_prompt{9} = double('�� 2�ð� ���� ����Ǵ� �����̹Ƿ� ���������� �����ؼ� �������ֽñ⸦ �ٶ��ϴ�.');
ready_prompt{10} = double('\n�����Ϸ��� �����̽��� �����ּ���.');


practice_end_prompt = double('���ϼ̽��ϴ�. ������ �����Ű���?\n\n������ �غ� �Ǽ����� �����̽��� �����ּ���.');
run_end_prompt = double('���ϼ̽��ϴ�. ��� �޽��� �����ŵ� �˴ϴ�.\n���� ��Ʈ�� ������ �غ� �Ǹ� �����̽��� �����ּ���.');

exp_end_prompt = double('������ ��� ��ġ�̽��ϴ�. �����մϴ�!');

%% PRACTICE
if numel(start_line) == 1  % if restart, skip the practice
    % viewing the practice prompt until click.
    pw = {'ī��'; 'Ŀ��'};
    seeds_i = 1;
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break;
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        Screen('TextSize', theWindow, fontsize);
        for i = 1:numel(practice_prompt)
            DrawFormattedText(theWindow, practice_prompt{i},'center', H/2-60*(2-i), white);
        end
        Screen('Flip', theWindow);
    end
    
    z = randperm(6);
    barsize = barsizeO(:,z);
    
    for j=1:numel(z)
        if ~barsize(5,j) == 0
            if mod(barsize(5,j),2) ==0
                SetMouse(rec(j,1)+(recsize(1)-barsize(1,j))/2, rec(j,2)+recsize(2)/2);
            else SetMouse(rec(j,1)+recsize(1)/2, rec(j,2)+recsize(2)/2);
            end
            while(1)
                % Track Mouse coordinate
                [mx, my, button] = GetMouse(theWindow);
                
                x = mx;
                y = rec(j,2)+recsize(2)/2;
                if x < rec(j,1)+(recsize(1)-barsize(1,j))/2, x = rec(j,1)+(recsize(1)-barsize(1,j))/2;
                elseif x > rec(j,1)+(recsize(1)+barsize(1,j))/2, x = rec(j,1)+(recsize(1)+barsize(1,j))/2;
                end
                a_display_survey(z, seeds_i, 1, pw,'practice1');
                Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
                Screen('Flip', theWindow);
                
                if button(1)
                    a_display_survey(z, seeds_i, 1, pw,'practice1');
                    Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
                    Screen('Flip', theWindow);
                    WaitSecs(.3);
                    break;
                end
            end
        end
    end
    WaitSecs(.1)
    
    % bodymap
    SetMouse(W*8.6/10, H/2); % set mouse at the center of the body
    rec_i = 0;
    survey.practice.rating_red = [];
    survey.practice.rating_blue = [];
    
    zc = randperm(2);
    if zc(1)==1
        color = red;  color_code = 1;
    else color = blue; color_code = 2;   end
    
    while(1)
        a_display_survey(z, seeds_i, 1, pw,'practice2');
        
        % Track Mouse coordinate
        [x, y, button] = GetMouse(theWindow);
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('r'))==1
            color = red;
            color_code = 1;
            keyCode(KbName('r')) = 0;
        elseif keyCode(KbName('b'))==1
            color = blue;
            color_code = 2;
            keyCode(KbName('b')) = 0;
        end
        
        % current location
        Screen('DrawDots', theWindow, [x;y], 6, color, [0 0], 1);
        
        % color the previous clicked regions
        if ~isempty(survey.practice.rating_red)
            Screen('DrawDots', theWindow, survey.practice.rating_red', 6, red, [0 0], 1);
        end
        if ~isempty(survey.practice.rating_blue)
            Screen('DrawDots', theWindow, survey.practice.rating_blue', 6, blue, [0 0], 1);
        end
        Screen('Flip', theWindow);
        
        % Sort the regions of red and blue
        if button(1) && color_code == 1
            survey.practice.rating_red = [survey.practice.rating_red; [x y]];
        elseif button(1) && color_code == 2
            survey.practice.rating_blue = [survey.practice.rating_blue; [x y]];
        end
        
        if keyCode(KbName('a'))==1
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            Screen('Flip', theWindow);
            WaitSecs(.5);
            break;
        end
    end
    
    % Practice End prompt
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break;
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        Screen('TextSize', theWindow, fontsize);
        DrawFormattedText(theWindow, practice_end_prompt, 'center', 'center', white, [], [], [], 1.5);
        Screen('Flip', theWindow);
    end
    
end
%% Main function: show 2 words

while (1)
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('space'))==1
        break;
    elseif keyCode(KbName('q'))==1
        abort_experiment('manual');
    end
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('TextSize', theWindow, fontsize);
    for i = 1:numel(ready_prompt)
        DrawFormattedText(theWindow, ready_prompt{i},'center', H/3-60*(2-i), white);
    end
    Screen('Flip', theWindow);
end

for seeds_i = start_line(1):size(words',2) % loop through the seed words
    % Set restart point in case of overwrite.
    % Restart target word from 'start_line(2)'
    % just for stopped seed words.
    if numel(start_line) == 2 && seeds_i == start_line(1)
        start_target = start_line(2);
    else
        start_target = 1;
    end
    
    % Get ready message: waiting for a space bar
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break;
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        for i = 1:numel(ready_prompt)
            DrawFormattedText(theWindow, ready_prompt{i},'center', H*5/12-100*(2-i), white);
        end
        Screen('Flip', theWindow);
    end
    
    
    for target_i = start_target:size(words',1) % loop through the response words (40) %edit
        
        %% FIRST question : Self-relevance, Valence, Time, Vividness, Safety/Threat
        z= randperm(6);
        barsize = barsizeO(:,z);
        
        for j=1:numel(barsize(5,:))
            if ~barsize(5,j) == 0 % if barsize(5,j) = 0, skip the scale
                % if Self, Vivid question, set curson on the left.
                % the other, set curson on the center.
                if mod(barsize(5,j),2) == 0
                    SetMouse(rec(j,1)+(recsize(1)-barsize(1,j))/2, rec(j,2)+recsize(2)/2);
                else SetMouse(rec(j,1)+recsize(1)/2, rec(j,2)+recsize(2)/2);
                end
                
                rec_i = 0;
                survey.dat{target_i, seeds_i}{barsize(5,j)}.trajectory = [];
                survey.dat{target_i, seeds_i}{barsize(5,j)}.time = [];
                
                starttime = GetSecs; % Each question start time
                
                while(1)
                    % Track Mouse coordinate
                    [mx, my, button] = GetMouse(theWindow);
                    
                    x = mx;  % x of a color dot
                    y = rec(j,2)+recsize(2)/2;
                    if x < rec(j,1)+(recsize(1)-barsize(1,j))/2, x = rec(j,1)+(recsize(1)-barsize(1,j))/2;
                    elseif x > rec(j,1)+(recsize(1)+barsize(1,j))/2, x = rec(j,1)+(recsize(1)+barsize(1,j))/2;
                    end
                    
                    % display scales and cursor
                    a_display_survey(z, seeds_i, target_i, words','whole');
                    Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
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
                        
                        a_display_survey(z, seeds_i, target_i, words','whole');
                        Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
                        Screen('Flip', theWindow);
                        
                        WaitSecs(.3);
                        break;
                    end
                end
            end
            
            % save 5 questions data every trial (one word pair)
            save(survey.surveyfile, 'survey', '-append');
        end
        
        WaitSecs(.3);
        %% SECOND question: body map
        
        SetMouse(W*8.5/10, H/2); % set mouse at the center of the body
        
        rec_i = 0;
        survey.dat{target_i, seeds_i}{6}.trajectory = [];
        survey.dat{target_i, seeds_i}{6}.time = [];
        survey.dat{target_i, seeds_i}{6}.rating_red = [];
        survey.dat{target_i, seeds_i}{6}.rating_blue = [];
        
        starttime = GetSecs; % bodymap start time
        
        % default color is randomized
        zc = randperm(2);
        if zc(1)==1
            color = red;  color_code = 1;
        else color = blue; color_code = 2;   end
        
        while(1)
            % draw scale
            a_display_survey(z, seeds_i, target_i, words','whole');
            
            % Track Mouse coordinate
            [x, y, button] = GetMouse(theWindow);
            [~,~,keyCode] = KbCheck;
            
            if keyCode(KbName('r'))==1
                color = red;
                color_code = 1;
                keyCode(KbName('r')) = 0;
            elseif keyCode(KbName('b'))==1
                color = blue;
                color_code = 2;
                keyCode(KbName('b')) = 0;
            end
            
            % Get trajectory
            rec_i = rec_i+1; % the number of recordings
            survey.dat{target_i, seeds_i}{6}.trajectory(rec_i,:) = [x y color_code button(1)];
            survey.dat{target_i, seeds_i}{6}.time(rec_i,1) = GetSecs - starttime;
            
            % current location
            Screen('DrawDots', theWindow, [x;y], 6, color, [0 0], 1);
            
            % color the previous clicked regions
            if ~isempty(survey.dat{target_i, seeds_i}{6}.rating_red)
                Screen('DrawDots', theWindow, survey.dat{target_i, seeds_i}{6}.rating_red', 6, red, [0 0], 1);
            end
            if ~isempty(survey.dat{target_i, seeds_i}{6}.rating_blue)
                Screen('DrawDots', theWindow, survey.dat{target_i, seeds_i}{6}.rating_blue', 6, blue, [0 0], 1);
            end
            Screen('Flip', theWindow);
            
            % Sort the regions of red and blue
            if button(1) && color_code == 1
                survey.dat{target_i, seeds_i}{6}.rating_red = [survey.dat{target_i, seeds_i}{6}.rating_red; [x y]];
            elseif button(1) && color_code == 2
                survey.dat{target_i, seeds_i}{6}.rating_blue = [survey.dat{target_i, seeds_i}{6}.rating_blue; [x y]];
            end
            
            if keyCode(KbName('a'))==1
                survey.dat{target_i, seeds_i}{6}.RT = survey.dat{target_i, seeds_i}{6}.time(end) - survey.dat{target_i, seeds_i}{6}.time(1);
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                Screen('Flip', theWindow);
                WaitSecs(.5);
                break;
            end
        end
        
        % save data every trial (one word pair)
        save(survey.surveyfile, 'survey', '-append');
        
    end
    
    %% Run (1 seed word) End
    save(survey.surveyfile, 'survey', '-append')
    
    if seeds_i < numel(words(1,:))
        while (1)
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break;
            end
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            DrawFormattedText(theWindow, run_end_prompt, 'center', textH, white, [], [], [], 1.5);
            Screen('Flip', theWindow);
        end
    elseif seeds_i == numel(words(1,:))
        survey.exp_endtime = datestr(clock, 0);
        save(survey.surveyfile, 'survey', '-append') 
    end
    WaitSecs(1.0);
    
end  % end of all seed words

%% Experiment end message

Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, exp_end_prompt, 'center', textH, white);
Screen('Flip', theWindow);
WaitSecs(2);

ShowCursor; %unhide mouse
Screen('CloseAll'); %relinquish screen control
end


%% == SUBFUNCTIONS ==============================================


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

function rx = rating(x, j)

global barsize recsize rec;
% rx start from 0
if mod(barsize(5,j),2) == 0     % Self, Vividness: 0<=rx<=1
    rx = (x-(rec(j,1)+(recsize(1)-barsize(1,j))/2))/barsize(1,j);
else                            % Valence, Time, Safety/Threat: -1<=rx<=1
    rx = (x-(rec(j,1)+recsize(1)/2))/(barsize(1,j)/2);
end

end