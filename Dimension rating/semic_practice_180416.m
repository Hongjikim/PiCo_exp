% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

Screen('Preference', 'SkipSyncTests', 1);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]); %screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', theWindow, font);
% Screen('TextSize', windowPtr, fontsize);
% HideCursor;

basedir = '/Users/hongji/Dropbox/MATLAB_hongji/github_hongji/Pico_v0';
cd(basedir); addpath(genpath(basedir));
subject_ID = input('Subject ID?:', 's');
subject_number = input('Subject number?:');

%the_text = input('***** Write the exact file name(Ex. pico_story.txt):', 's'); %Copy_of_pico_story_kor_ANSI.txt
the_text = 'Copy_of_pico_story_kor_ANSI.txt'
[k, double_text] = make_text_PDR(the_text);
%
sTime = GetSecs;
ready2=0;
rec=0;

SetMouse(70, 200); % set mouse at the starting point
x=70; y=200;
for ii = 1:k
    DrawFormattedText(theWindow, double_text(ii,:), 85, 75, 0, 65, 0, 0, 14.5); % 10 = 14.5
    while ~ready2
        
        draw_axis_PDR([200 550]);
        
        rec=rec+1;
        [x,y,button] = GetMouse(theWindow);
        
        xc(rec,:)=x;
        yc(rec,:)=y;
        
        % if the point goes further than the box, move the point to
        % the closest point
        
        disp([x,y]); %display the coordinates
        Screen('DrawDots', theWindow, [x y]', 20, [255 164 0 130], [0 0], 1);  % big orange dot
        Screen('DrawDots', theWindow, [xc yc]', 5, [255 0 0], [0 0], 1);  %dif color
        %Screen(theWindow,'DrawLines', [xc yc]', 5, 255);
        Screen('Flip',theWindow);
        
        if y < 100
            y = 100; SetMouse(x,y);
        elseif x > 1220 && y < 350
            x = 70; y = 553; WaitSecs(0.5); SetMouse(x,y);
        elseif x < 70
            x = 70; SetMouse(x,y);
        elseif y > 660;
            y = 660; SetMouse(x,y);
        elseif x > 1220 && y > 500
            break
        end
        
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

savedir = fullfile(basedir, 'Data_Pico');
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
data.trajectory = [xc yc];

save(data.datafile, 'data');

sca;
Screen('CloseAll');