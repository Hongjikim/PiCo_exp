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

[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect/2.5);%[0 0 2560/2 1440/2]
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font = 'NanumBarunGothic'; % check
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize(2));

for i =1:2
    story_titles{i} = input('title?: ', 's')
end

global W H orange bgcolor window_rect theWindow red fontsize white cqT


for story_q_num = 1:2
    starttime = GetSecs;
    title_prompt = [double('<') double(story_titles{story_q_num}) double('>')];
    intro_prompt1 = double('위의 이야기가 얼마나 새로웠나요?');
    intro_prompt2 = double('트랙볼을 움직여서 새로웠던 정도를 클릭해주세요.');
    title={'전혀 새롭지 않음','보통', '매우 새로움'};
    
    SetMouse(W/2, H/2);
    % cqT = 5;
    trajectory = [];
    trajectory_time = [];
    xy = [W/3 W*2/3 W/3 W/3 W*2/3 W*2/3;
        H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7]/2.5;
    
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
        Screen('DrawLines',theWindow, xy, 3, 255);
        DrawFormattedText(theWindow, title_prompt,'center', H/8-90, white)
        DrawFormattedText(theWindow, intro_prompt1,'center', H/8-50, white);
        DrawFormattedText(theWindow, intro_prompt2,'center', H/8-10, white); % check
        % Draw scale letter
        Screen('TextSize', theWindow, fontsize(1));
        DrawFormattedText(theWindow, double(title{1}),'center', 'center', white, ...
            [],[],[],[],[], [xy(1,1)-70, xy(2,1), xy(1,1)+20, xy(2,1)+60]);
        DrawFormattedText(theWindow, double(title{2}),'center', 'center', white, ...
            [],[],[],[],[], [W/2-15, xy(2,1), W/2+20, xy(2,1)+60]);
        DrawFormattedText(theWindow, double(title{3}),'center', 'center', white, ...
            [],[],[],[],[], [xy(1,2)+45, xy(2,1), xy(1,2)+20, xy(2,1)+60]);
        
         Screen('DrawDots', theWindow, [mx my], 10, orange, [0, 0], 1);
        %Screen('DrawLine', theWindow, orange, x, y+10, x, y-10, 6);
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
            DrawFormattedText(theWindow, title_prompt,'center', H/8-90, white)
            DrawFormattedText(theWindow, intro_prompt1,'center', H/8-50, white);
            DrawFormattedText(theWindow, intro_prompt2,'center', H/8-10, white); % check
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
            waitsec_fromstarttime(rrtt, 1);
            Screen(theWindow, 'FillRect', bgcolor, window_rect)
            Screen('Flip', theWindow);
            waitsec_fromstarttime(rrtt, 2);
            break
        end
    end
end