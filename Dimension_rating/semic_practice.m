% To do
 % *** make function of drawformat!!!
%  1) trajectory save directory
% 2) starting point
% 3) set the limit (box)
% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

% from fast
Screen('Preference', 'SkipSyncTests', 1);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]); %screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
%theWindow = Screen('OpenWindow', 0, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', theWindow, font);
% Screen('TextSize', windowPtr, fontsize);
% HideCursor;

%
sTime = GetSecs;
ready2=0;
rec=0;

while ~ready2
    draw_axis_PDR([200:210:620]);
    rec=rec+1;
    [x,y,button] = GetMouse(theWindow);
    xc(rec,:)=x; 
    yc(rec,:)=y;
    
    Screen('DrawDots', theWindow, [x y]', 20, [255 164 0 130], [0 0], 1);  %dif color
    % if the point goes further than the semi-circle, move the point to
    % the closest point
    %radius = (rb-lb)/2; % radius
    %theta = atan2(cir_center(2)-y,x-cir_center(1));
%     if y > bb
%         y = bb;
%         SetMouse(x,y);
%     end
%     % send to arc of semi-circle
%     if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
%         x = radius*cos(theta)+cir_center(1);
%         y = cir_center(2)-radius*sin(theta);
%         SetMouse(x,y);
%     end
    
    %draw_scale('overall_motor_semicircular');
%     theta = rad2deg(theta);
%     theta= 180 - theta;
%     theta = num2str(theta);
%     DrawFormattedText(theWindow, theta, 'center', 'center', white, [], [], [], 1.2); %Display the degree of the cursur based on cir_center
    disp(x); %display the coordinates
    Screen('DrawDots', theWindow, [xc yc]', 5, [255 0 0], [0 0], 1);  %dif color
    %Screen(theWindow,'DrawLines', [xc yc]', 5, 255);
    Screen('Flip',theWindow);
    if button(1)
        %draw_scale('overall_avoidance_semicircular');
        Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
        Screen('Flip',theWindow);
        WaitSecs(0.5);
        ready3=0;
        while ~ready3 %GetSecs - sTime> 5
            msg = double(' ');
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
end

sca;
Screen('CloseAll');