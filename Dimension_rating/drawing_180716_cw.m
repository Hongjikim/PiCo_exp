%%
% 1) 글 넣기 (잘라서
% 2) 글 넘기기
% 3) instructoin 넣기
% 4) 위치 screen size에 맞추기 (fast참고)
% 5) instruction 에 맞춰서 axis변경
%%
% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize; % rating scale

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];
bgcolor = 100;

window_ratio = 1.1;

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/window_ratio;

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;


Screen('Preference', 'SkipSyncTests', 1);
[theWindow, rect]=Screen('OpenWindow',0, bgcolor, window_rect/window_ratio);
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', theWindow, font);
% Screen('TextSize', windowPtr, fontsize);
% HideCursor;

basedir = '/Users/hongji/Dropbox/PiCo_git/Dimension_rating';  % edit
cd(basedir); addpath(genpath(basedir));
subject_ID = input('Subject ID?:', 's');
subject_number = input('Subject number?:');

the_text = 'story_1_KJH.txt'; % edit
[k, double_reshaped_text] = make_text_PDR(the_text);

sTime = GetSecs;

rec=1;
rec2=1;

% Set the center of axis
axis2 = H/1.5;
axis1 = H/3;

y_init = [round(axis1), round(axis2)];
xc_all = [];
yc_all = [];

for i = 1:ceil(k/2)
    TextW{i} = NaN(2,1);
    TextW{i}(1) = Screen(theWindow,'DrawText',double_reshaped_text(2*i-1,:),0,0); 
    try
        TextW{i}(2) = Screen(theWindow,'DrawText',double_reshaped_text(2*i,:),0,0); 
    catch
    end
end
Screen(theWindow,'FillRect',bgcolor, window_rect);

for i = 1:ceil(k/2)
    text = [];
    text = [text double_reshaped_text(2*i-1,:)];
    try
        text = [text double_reshaped_text(2*i,:)];
    catch
    end
    
    % loop for lines

    for line_i = 1:2
        
        ready2 = false;
        
        x_init_ln = round(W/14);
        y_init_ln = y_init(line_i);
        
        SetMouse(x_init_ln, y_init_ln); % set mouse at the starting point
        
        xc{line_i} = x_init_ln;
        yc{line_i} = y_init_ln;
        
        %instruction = double('아래 글을 읽고, 정서적 긍정/부정을 그래프(곡선)로 자유롭게 표현해주세요. (높을 수록 긍정적)');
        %DrawFormattedText(theWindow, instruction, W/14, H/18, 255, 55, 0, 0, 14);
        
        remove_dot = false;
        
        while ~ready2
            
            draw_axis_PDR([axis1 axis2]);
            
            DrawFormattedText(theWindow, text, W/14 + 10, axis1 - H/20 - 80, 255, 70, 0, 0, 13.8); % 10 = 14.5
            
            [x,y,button] = GetMouse(theWindow);
            
            x = round(x);
            y = round(y);
            
            % prevent moving further left than start point
            if x < x_init_ln
                x = x_init_ln; SetMouse(x_init_ln,y);
            elseif x > x_init_ln + W/1.6 + 50
                x = x_init_ln + W/1.6 + 50; SetMouse(x_init_ln + W/1.6 + 50,y);
            end
            
            % remove guide dot
            if sqrt((x-x_init_ln)^2+(y-y_init_ln)^2)<20
                remove_dot = true;
            end
            
            
            if ~remove_dot
                Screen('DrawDots', theWindow, [x_init_ln y_init_ln]', 20, [255 255 0 130], [0 0], 1);  % big orange dot
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
            
            disp([x,y]); %display the coordinates
            %Screen('DrawDots', theWindow, [x y]', 20, [255 164 0 130], [0 0], 1);  % big orange dot
            if line_i > 1
                Screen('DrawDots', theWindow, [xc{1} yc{1}]', 5, [255 0 0], [0 0], 1);  %red line
            end
            Screen('DrawDots', theWindow, [xc{line_i} yc{line_i}]', 5, [255 0 0], [0 0], 1);  %red line
            
            Screen('Flip',theWindow);
            
            if x>(x_init_ln + W/1.6) && numel(xc{line_i}) > round(TextW{i}(line_i))*.9
                Screen('DrawDots', theWindow, [x y]', 20, [255 0 0 0], [0 0], 1);  % Feedback
                if line_i > 1
                    Screen('DrawDots', theWindow, [xc{1} yc{1}]', 5, [255 0 0], [0 0], 1);  %red line
                end
                Screen('DrawDots', theWindow, [xc{line_i} yc{line_i}]', 5, [255 0 0], [0 0], 1);  %red line
                Screen('Flip',theWindow);
%                 WaitSecs(0.5);
                ready2 = true;
            end
        
        end
    end
    %
    xc_all = [xc_all xc];
    yc_all = [yc_all yc];
end

KbStrokeWait;
sca;

savedir = fullfile(basedir, 'Data_PDR');
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

nowtime = clock;
subjtime = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = subject_number;
data.datafile = fullfile(savedir, [subjtime, '_', subject_ID, '_subj', sprintf('%.3d', subject_number), '.mat']);
data.version = 'PICO_v0_04-16-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

data.trajectory_full = [xc_all yc_all];

%%
%data.trajectory_save = [x_save y_save];

% subplot(1,2,1)
% plot(data.trajectory_full(:,1), -data.trajectory_full(:,2))
% subplot(1,2,2)
% plot(data.trajectory_save(:,1), -data.trajectory_save(:,2))
% 
% subplot(1,2,1)
% scatter(data.trajectory_full(:,1), -data.trajectory_full(:,2))
% subplot(1,2,2)
% scatter(data.trajectory_save(:,1), -data.trajectory_save(:,2))
% scatterplot(data.trajectory_save)
% scatterplot(data.trajectory_save)
% 
% figure; plot(a(:,1), a(:,2)); hold on
% plot(b(:,1), b(:,2))

save(data.datafile, 'data');

sca;
Screen('CloseAll');