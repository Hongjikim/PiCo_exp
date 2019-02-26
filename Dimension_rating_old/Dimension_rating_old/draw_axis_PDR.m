function final_axis = draw_axis_PDR(b)
%% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height];

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

%% Draw axis
if length(b) >= 1
    for i = 1:length(b)
        bb = b(i);
        % for b= [200:210:620] % draw lines and arrows ((auto) - 2 lines and 2 arrows in one set)
        % starting_point (coordinate a,b -- the number of b equals the number of lines)
        a = round(W/14); %70;
        w = W/1.6; %1150; % width of line (horizontal length == length of x axis)
        l = H/10; %100; % length of line (vertical length == height of y axis)
        a_w= W/100; %10; % arrow width
        % How many lines?  %length
        
        % making lines and arrows
        line1_2 = [a a+w a a;bb bb bb-l bb+l];
        arrow1_2 = [a a-a_w a a+a_w; bb+l bb+l-a_w bb+l bb+l-a_w];
        arrow3_4 = [a a-a_w a a+a_w; bb-l bb-l+a_w bb-l bb-l+a_w];
        
        r_line_1 = 12*(i-1) + 1;
        r_line_2 = 12*i;
        all_lines(1:2,r_line_1:r_line_2)= horzcat(line1_2, arrow1_2, arrow3_4);
    end
else
    i = 1;
end

width = 5;   %width of line
colors = 0; % color of line

final_axis = Screen('DrawLines', theWindow, all_lines, width, colors); %, [xCenter,yCenter]

end