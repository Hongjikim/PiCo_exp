function data = dimension_rating(dimension_type)

%%
% 1) 시작위치가 거기가 아닐텐데..
% 2) 텍스트 오류
% 3) up/down bound
% 3) instructoin 넣기
% 5) instruction 에 맞춰서 axis변경
%%
subject_ID = input('Subject ID?:', 's');
subject_number = input('Subject number?:');
start_option = 2;

% from generate_ts.. use this to load all the story text for dimensions
% subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');
% stories = filenames(fullfile(subject_dir, '*.txt')); % story01.txt story02.txt

% save data
savedir = fullfile(pwd, 'Data_PDR');
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

nowtime = clock;
subjtime = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));
   
data.subject = subject_number;
data.datafile = fullfile(savedir, [subjtime, '_', subject_ID, '_', dimension_type, '_subj', sprintf('%.3d', subject_number), '.mat']);
data.version = 'PICO_v0_04-16-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

if exist(data.datafile, 'file')
    load(data.datafile);
    disp('The data file already exists.');
    start_option = input('1:Start from the page you left off, 2:Start from the beginning, 3:Abort  ');
end

if start_option==1
    start_page = numel(data.trajectory_save_page)+1;
elseif start_option==2
    start_page = 1;
elseif start_option==3
    error(':::::ABORT:::::');
end

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize window_ratio; % rating scale

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];
bgcolor = 100;

window_ratio = 1;

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/window_ratio;

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;
% axis_w = W/1.55;
axis_h = H/9.5;

Screen('Preference', 'SkipSyncTests', 1);
[theWindow, rect]=Screen('OpenWindow',0, bgcolor, window_rect/window_ratio);
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
% font = 'NanumBarunGothic';
% Screen('TextFont', theWindow, font);
% Screen('TextSize', windowPtr, fontsize);
HideCursor;


if strcmp(dimension_type, 'practice')
    the_text = 'sample_3.txt';
else
     stories = filenames(fullfile('/Users/cocoanlab/Desktop/hongji/PiCo/Dimension_rating/pico010_lsw', '*.txt'));
    [~, the_text] = fileparts(stories{subject_number})
     the_text = [the_text '.txt']
     %stories(subject_number); % the_text = 'cwk_1.txt'; % edit
    % the_text = 'cwk_1.txt'; % edit
end
double_text_cell = make_text_PDR(the_text);

sTime = GetSecs;

% Set the center of axis
y_zero{1} = round(H/3.5); %editted
y_zero{2} = round(H/1.6);
y_interval = y_zero{2}-y_zero{1};
x_zero = round(W/14);

xc_all = [];
yc_all = [];

for i = 1:numel(double_text_cell)
    for j = 1:size(double_text_cell{i},1)
        TextW{i}(j,1) = Screen(theWindow,'DrawText',double_text_cell{i}(j,:),0,0);
    end
end

Screen(theWindow,'FillRect',bgcolor, window_rect);

for i = start_page:numel(double_text_cell)
    
    text = double_text_cell{i};
    
    rng('shuffle')
    rand_practice = round(randi(40,1,10)*25);
    
    % loop for lines
    for line_i = 1:size(double_text_cell{i},1)
        
        ready2 = false;
        
        if i == 1 && line_i == 1
            x_init_ln = x_zero;
            y_init_ln = y_zero{1};
        else
            y_init_ln = data.y_previous;
        end
        
        % SetMouse(x_init_ln, y_init_ln); % set mouse at the starting point
        
        xc{line_i} = x_init_ln;
        yc{line_i} = y_init_ln;
        
        if strcmp(dimension_type, 'valence')
            instruction = double('아래 글을 읽고, 정서적 긍정/부정을 그래프(곡선)로 자유롭게 표현해주세요. (높을 수록 긍정적)');
        elseif strcmp(dimension_type, 'self_relevance')
            instruction = double('아래 글을 읽고, 자기관련도를 그래프(곡선)로 자유롭게 표현해주세요. (높을 수록 나와 관련 있음)'); 
        elseif strcmp(dimension_type, 'vividness')
            instruction = double('아래 글을 읽고, 생생한 정도를 그래프(곡선)로 자유롭게 표현해주세요. (높을 수록 생생함)'); 
        elseif strcmp(dimension_type, 'practice')
            instruction = double('아래 글을 읽고, 빨간 밑줄이 쳐진 글자는 최대로, 파란 밑줄이 쳐진 글자는 최소로 그래프(곡선)을 그려주세요.(연습)');
        end
        
        
        remove_dot = false;
        
        while ~ready2
            
            if size(double_text_cell{i},1) == 1
                draw_axis_PDR(y_zero{1}, dimension_type, 'width', TextW{i});
                DrawFormattedText(theWindow, text(1,:), x_zero + 10, y_zero{1} - axis_h - 20, 255);
            else
                draw_axis_PDR([y_zero{1} y_zero{2}], dimension_type, 'width', TextW{i});
                DrawFormattedText(theWindow, text(1,:), x_zero + 10, y_zero{1} - axis_h - 20, 255);
                DrawFormattedText(theWindow, text(2,:), x_zero + 10, y_zero{2} - axis_h - 20, 255);
            end
            
            DrawFormattedText(theWindow, instruction, W/14, H/10, 0);
            
          
            if strcmp(dimension_type, 'practice')
                if size(double_text_cell{i},1) == 1
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(1), y_zero{1} - axis_h - 20, [255 0 0]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(2), y_zero{1} - axis_h - 20, [0 0 255]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(3), y_zero{1} - axis_h - 20, [255 0 0]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(4), y_zero{1} - axis_h - 20, [0 0 255]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(5), y_zero{1} - axis_h - 20, [0 0 255]);
                else
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(1), y_zero{1} - axis_h - 20, [255 0 0]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(2), y_zero{1} - axis_h - 20, [0 0 255]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(3), y_zero{1} - axis_h - 20, [255 0 0]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(4), y_zero{1} - axis_h - 20, [0 0 255]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(5), y_zero{2} - axis_h - 20, [0 0 255]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(6), y_zero{2} - axis_h - 20, [255 0 0]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(7), y_zero{2} - axis_h - 20, [0 0 255]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(8), y_zero{2} - axis_h - 20, [255 0 0]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(9), y_zero{1} - axis_h - 20, [255 0 0]);
                    DrawFormattedText(theWindow, '_____', x_zero + rand_practice(10), y_zero{2} - axis_h - 20, [0 0 255]);
                end
            end
            
            [x,y,button] = GetMouse(theWindow);
            
            x = round(x);
            y = round(y);
            
            % prevent moving further left than start point
            if x < x_zero
                x = x_zero; SetMouse(x_zero,y);
            elseif x > x_zero + TextW{i}(line_i) + 30
                x = x_zero + TextW{i}(line_i) + 30; SetMouse(x_zero + TextW{i}(line_i) + 30,y);
            end
            
            if strcmp(dimension_type, 'valence') || strcmp(dimension_type, 'practice')
                if y > y_zero{line_i} + axis_h
                    y = y_zero{line_i} + axis_h; SetMouse(x,y);
                elseif y < y_zero{line_i} - axis_h
                    y = y_zero{line_i} - axis_h; SetMouse(x,y);
                end
            else
                if y < y_zero{line_i} - axis_h
                    y = y_zero{line_i} - axis_h; SetMouse(x,y);
                elseif y > y_zero{line_i}
                    y = y_zero{line_i}; SetMouse(x,y);
                end
            end
            
            % remove guide dot
            if sqrt((x-x_init_ln)^2+(y-y_init_ln)^2)<20
                remove_dot = true;
            end
            
            % show guide dot
            if ~remove_dot
                Screen('DrawDots', theWindow, [x_init_ln y_init_ln]', 20, [255 255 0 130], [0 0], 1); 
            end
            
            Screen('DrawDots', theWindow, [x y]', 20, [255 164 0 130], [0 0], 1);  % big orange dot
            
            if any(button) && remove_dot
                if xc{line_i}(end) < x
                    x_intp = [xc{line_i}(end), x];
                    y_intp = [yc{line_i}(end), y];
                    new_y = interp1(x_intp,y_intp,xc{line_i}(end):x);
                    xc{line_i} = [xc{line_i}; (xc{line_i}(end)+1:x)'];
                    yc{line_i} = [yc{line_i}; new_y(2:end)'];
                    
                elseif xc{line_i}(end) > x
                    idx = xc{line_i}(:,1)>x;
                    xc{line_i}(idx) = [];
                    yc{line_i}(idx) = [];
                    
                elseif xc{line_i}(end) == x
                    
                    % do nothing
                end
            end
            
            % disp([x,y]); %display the coordinates
            % Screen('DrawDots', theWindow, [x y]', 20, [255 164 0 130], [0 0], 1);  % big orange dot
            if line_i > 1
                Screen('DrawDots', theWindow, [xc{1} yc{1}]', 5, [255 0 0], [0 0], 1);  %red line
            end
            Screen('DrawDots', theWindow, [xc{line_i} yc{line_i}]', 5, [255 0 0], [0 0], 1);  %red line
            
            Screen('Flip',theWindow);
            
            if (x>(x_init_ln + TextW{i}(line_i))) && (numel(xc{line_i}) > round(TextW{i}(line_i)))
                Screen('DrawDots', theWindow, [x y]', 20, [255 0 0 0], [0 0], 1);  % Feedback
                if line_i > 1
                    Screen('DrawDots', theWindow, [xc{1} yc{1}]', 5, [255 0 0], [0 0], 1);  %red line
                end
                Screen('DrawDots', theWindow, [xc{line_i} yc{line_i}]', 5, [255 0 0], [0 0], 1);  %red line
                Screen('Flip',theWindow);
                %WaitSecs(0.5);
%                 while true
%                     [x,y,button] = GetMouse;
%                     if sum(button == [0 1 0]) == 3
%                         break
%                     end
%                 end
                ready2 = true;
                if line_i == 1
                    y_previous = y + y_interval;
                else
                    y_previous = y - y_interval;
                end
            end
            
        end
        data.y_previous = y_previous;
    end
    
    data.trajectory_save_page{i} = [xc;yc];
    
    save(data.datafile, 'data');
    
    xc_all = [xc_all xc];
    yc_all = [yc_all yc];
    
end

data.trajectory_save = [xc_all; yc_all];

save(data.datafile, 'data');
disp('Data SAVED')

%
%data.trajectory_save = [x_save y_save];

% subplot(1,2,1)
% plot(data.trajectory_full(:,1), -data.trajectory_full(:,2))
% subplot(1,2,2)
%
% subplot(1,2,1)
% scatter(data.trajectory_full(:,1), -data.trajectory_full(:,2))
% subplot(1,2,2)
% scatter(data.trajectory_save{:,1}, -data.trajectory_save{:,2})
% scatterplot(data.trajectory_save)
% scatterplot(data.trajectory_save)
%
% figure; plot(a(:,1), a(:,2)); hold on
% plot(b(:,1), b(:,2))

% for i = 1:14
%     subplot(4,4,i)
%     plot(data.trajectory_save{1,i}, -data.trajectory_save{2,i})
%     title([num2str(i), '번째 문장'])
%     xlim([100 1300])
%     if round(i/2) == i/2
%         ylim([500 700])
%     else
%         ylim([-1000 0])
%     end
%     
% end

%

KbStrokeWait;
sca;
Screen('CloseAll');

end