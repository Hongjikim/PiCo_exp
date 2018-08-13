function final_axis = draw_axis_PDR(b, varargin)

%% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec window_ratio; % rating scale

axis_w = repmat(W/1.55, length(b), 1);
draw_unidirection = false;

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands: dimensions
            case {'practice'}
                % do nothing
            case {'self_relevance'}
                draw_unidirection = true;
                axis_name{1} = '매우 관련 있음';
                axis_name{2} = '전혀 관련 없음';
            case {'vividness'}
                draw_unidirection = true;
                axis_name{1} = '매우 생생함';
                axis_name{2} = '전혀 생생하지 않음';
            case {'valence'}
                axis_name{1} = '긍정';
                axis_name{2} = '부정';
            case {'width'}
                axis_w = varargin{i+1};
        end
    end
end

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/window_ratio ;
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

%% Draw axis

for i = 1:length(b)
    bb = b(i) %+ H/9.5; %editted
    % for b= [200:210:620] % draw lines and arrows ((auto) - 2 lines and 2 arrows in one set)
    % starting_point (coordinate a,b -- the number of b equals the number of lines)
    a = round(W/14); %70;
    w = axis_w(i); %1150; % width of line (horizontal length == length of x axis)
    l = H/9.5; %H*2/9.5 ; % length of line (vertical length == height of y axis)
    a_w= W/100; %10; % arrow width
    % How many lines?  %length
    
    % making lines and arrows
    if draw_unidirection
        line1_2 = [a a+w a a;bb bb bb-l bb];
    else
        line1_2 = [a a+w a a;bb bb bb-l bb+l];
    end
    
    arrow1_2 = [a a-a_w a a+a_w; bb+l bb+l-a_w bb+l bb+l-a_w];
    arrow3_4 = [a a-a_w a a+a_w; bb-l bb-l+a_w bb-l bb-l+a_w];
    
    if draw_unidirection
        r_line_1 = 8*(i-1) + 1;
        r_line_2 = 8*i;
    else
        r_line_1 = 12*(i-1) + 1;
        r_line_2 = 12*i;
    end
    
    if draw_unidirection
        all_lines(1:2,r_line_1:r_line_2)= horzcat(line1_2, arrow3_4);
        final_rects = [a bb-l a+w bb]';
        Screen('FillRect', theWindow, [120 120 120], final_rects)
%         DrawFormattedText(theWindow, double(axis_name{1}), a-50, bb-l-10, 0);
%         DrawFormattedText(theWindow, double(axis_name{2}), a-50, bb+30, 0);
    else
        all_lines(1:2,r_line_1:r_line_2)= horzcat(line1_2, arrow1_2, arrow3_4);
        rect_2 = [a bb-l a+w bb+l];
        Screen('FillRect', theWindow, [120 120 120], rect_2)
%         DrawFormattedText(theWindow, double(axis_name{1}), a-50, bb-l-10, 0);
%         DrawFormattedText(theWindow, double(axis_name{2}), a-50, bb+l+30, 0);
    end
end

% if draw_unidirection
%     final_rects = [a bb-l a+w bb]';
%     Screen('FillRect', theWindow, [120 120 120 100], final_rects)
% else
%     rect_1 = [a bb-l a+w bb];
%     rect_2 = [a bb-1 a+w bb+l];
%     Screen('FillRect', theWindow, [120 120 120 100], rect_1)
%     Screen('FillRect', theWindow, [120 120 120 100], rect_2)
%     %final_rects = [rect_1' rect_2'];
% end


width = 5;   %width of line
colors = 0; % color of line

final_axis = Screen('DrawLines', theWindow, all_lines, width, colors);%, [xCenter,yCenter]
end