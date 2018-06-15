%% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb bodymap recsize barsize rec; % rating scale

%% SETUP: Screen

bgcolor = 100;

% if testmode
%     window_rect = [0 0 1260 760]; % in the test mode, use a little smaller screen
% else
window_rect1 = get(0, 'MonitorPositions'); % full screen
window_rect = [ 0 0 (1/2)*window_rect1(3) (1/2)*window_rect1(4)];
if size(window_rect1,1)>1   % for Byeol's desk, when there are two moniter
    window_rect = window_rect1(1,:);
end
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
    lb,tb+2*recsize(2); lb+recsize(1),tb+2*recsize(2)]; %6°³ »ç°¢ÇüÀÇ ¿ÞÂÊ À§ ²ÀÁþÁ¡ÀÇ ÁÂÇ¥

bodymap = imread('imgs/bodymap_bgcolor.jpg');
bodymap = bodymap(:,:,1);
[body_y, body_x] = find(bodymap(:,:,1) == 255);

bodymap([1:10 791:800], :) = [];
bodymap(:, [1:10 1271:1280]) = []; % make the picture smaller

%% START: Screen
Screen('Preference', 'SkipSyncTests', 1);
theWindow = Screen('OpenWindow', 0, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize);
% HideCursor;

% FIRST question : Self-relevance, Valence, Time, Vividness, Safety/Threat
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
        %                 survey.dat{target_i, seeds_i}{barsize(5,j)}.trajectory = [];
        %                 survey.dat{target_i, seeds_i}{barsize(5,j)}.time = [];
        %
        starttime = GetSecs; % Each question start time
    end
    
    
    while(1)
        % Track Mouse coordinate
        [mx, my, button] = GetMouse(theWindow);
        
        x = mx;  % x of a color dot
        y = rec(j,2)+recsize(2)/2;
        if x < rec(j,1)+(recsize(1)-barsize(1,j))/2, x = rec(j,1)+(recsize(1)-barsize(1,j))/2;
        elseif x > rec(j,1)+(recsize(1)+barsize(1,j))/2, x = rec(j,1)+(recsize(1)+barsize(1,j))/2;
        end
        
        % display scales and cursor
        %                     display_survey(z, seeds_i, target_i, words,'whole');
        % Get the size of the on screen window in pixels
        % For help see: Screen WindowSize?
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        
        % Get the centre coordinate of the window in pixels
        % For help see: help RectCenter
        [xCenter, yCenter] = RectCenter(windowRect);
        
        % Draw text in the upper portion of the screen with the default font in red
        Screen('TextSize', window, 70);
        DrawFormattedText(window, 'Hello World', 'center',...
            screenYpixels * 0.25, [1 0 0]);
        
        % Draw text in the middle of the screen in Courier in white
        Screen('TextSize', window, 80);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, 'Hello World', 'center', 'center', white);
        
        % Draw text in the bottom of the screen in Times in blue
        Screen('TextSize', window, 90);
        Screen('TextFont', window, 'Times');
        DrawFormattedText(window, 'Hello World', 'center',...
            screenYpixels * 0.75, [0 0 1]);
        
        
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
            
            display_survey(z, seeds_i, target_i, words,'whole');
            Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
            Screen('Flip', theWindow);
            
            WaitSecs(.3);
            break;
        end
    end
end

% save 5 questions data every trial (one word pair)
%             save(survey.surveyfile, 'survey', '-append');
% end

WaitSecs(.3);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo.
KbStrokeWait;

% Clear the screen.
sca;