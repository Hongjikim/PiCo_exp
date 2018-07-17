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

basedir = '/Users/hongji/Dropbox/PiCo_git/Dimension_rating'; 
cd(basedir); addpath(genpath(basedir));
subject_ID = input('Subject ID?:', 's');
subject_number = input('Subject number?:');

the_text = 'story_1_KJH.txt'; 
[k, double_reshaped_text] = make_text_PDR(the_text);

sTime = GetSecs;
ready2=0;
rec=1;
rec2=1;

% Set the center of axis
axis2 = H/1.5;
axis1 = H/3;

x_init = W/14; 
y_init = axis1;

SetMouse(x_init, axis1); % set mouse at the starting point

xc = x;
yc = y;
xc_1 = x;
yc_1 = y;
x_save = x;
y_save = y;

t = GetSecs;



for i = 1:k
    text = [double_reshaped_text(2*i-1,:) double_reshaped_text(2*i,:)]; 
    %instruction = double('아래 글을 읽고, 정서적 긍정/부정을 그래프(곡선)로 자유롭게 표현해주세요. (높을 수록 긍정적)'); 
    %DrawFormattedText(theWindow, instruction, W/14, H/18, 255, 55, 0, 0, 14);
    
    while ~ready2
        
        draw_axis_PDR([axis1 axis2]);
        
        DrawFormattedText(theWindow, text, W/14 + 10, axis1 - H/20 - 80, 255, 70, 0, 0, 13.8); % 10 = 14.5
        
        [x,y,button] = GetMouse(theWindow);
        
        x
        
        t(2) = t(1);
        t(1) = GetSecs;
        intv = round(-diff(t)*2000); %2000
        
        if xc(rec) ~= x
            vec_x = (xc(rec):((x-xc(rec))/intv):x)';
        else
            vec_x = repmat(x, intv+1,1);
        end
        
        if yc(rec) ~= y
            vec_y = yc(rec):((y-yc(rec))/intv):y;
        else
            vec_y = repmat(y, intv+1,1);
        end
        
        xc((rec+1):(rec+intv),:)=vec_x(2:end);
        xc_1((rec+1):(rec+intv),:)=vec_x(2:end);
        yc((rec+1):(rec+intv),:)=vec_y(2:end);
        yc_1((rec+1):(rec+intv),:)=vec_y(2:end);
        rec = rec + intv;
        
        %     if rec2 ~= 0
        if x_save(rec2) ~= x || y_save(rec2) ~= y
            rec2 = rec2 + 1;
            x_save(rec2,:)=x;
            y_save(rec2,:)=y;
        else
            
        end
        %     end
        %
        
        
        %         xc(rec,:)=x;
        %         yc(rec,:)=y;
        
        % if the point goes further than the box, move the point to
        % the closest point
        
        disp([x,y]); %display the coordinates
        Screen('DrawDots', theWindow, [x y]', 20, [255 164 0 130], [0 0], 1);  % big orange dot
        Screen('DrawDots', theWindow, [xc_1 yc_1]', 5, [255 0 0], [0 0], 1);  %red line
        %Screen(theWindow,'DrawLines', [xc yc]', 5, 255);
        Screen('Flip',theWindow);
        
%         if y < 100
%             y = 100; SetMouse(x,y);
%         elseif x > 1220 && y < 350
%             x = 70; y = 553; WaitSecs(0.5); SetMouse(x,y);
%             clear xc_1 yc_1
%         elseif x < 70
%             x = 70; SetMouse(x,y);
%         elseif y > 660;
%             y = 660; SetMouse(x,y);
%         elseif x > 1220 && y > 500
%             break
%         end
        
        if button(1)
            %draw_scale('overall_avoidance_semicircular');
            Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
            Screen('Flip',theWindow);
            WaitSecs(0.5);
            ready3=0;
            while ~ready3 %GetSecs - sTime> 5
                msg = double(' '); % 끝나고 나오는 말
                DrawFormattedText(theWindow, msg, 'center', 250, white, [], [], [], 1.2);
                Screen('Flip',theWindow);
                if  GetSecs - sTime > 5
                    break
                end
            end
            
            break;
            
        elseif GetSecs - sTime > 20
            ready2=1;
            break;
        else
            %do nothing
        end
        % sca;
        
    end
    %
end

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

data.trajectory_full = [xc yc];
data.trajectory_save = [x_save y_save];

% subplot(1,2,1)
% plot(data.trajectory_full(:,1), -data.trajectory_full(:,2))
% subplot(1,2,2)
% plot(data.trajectory_save(:,1), -data.trajectory_save(:,2))
% 
subplot(1,2,1)
scatter(data.trajectory_full(:,1), -data.trajectory_full(:,2))
subplot(1,2,2)
scatter(data.trajectory_save(:,1), -data.trajectory_save(:,2))
% scatterplot(data.trajectory_save)
% scatterplot(data.trajectory_save)
% 
% figure; plot(a(:,1), a(:,2)); hold on
% plot(b(:,1), b(:,2))

save(data.datafile, 'data');

sca;
Screen('CloseAll');