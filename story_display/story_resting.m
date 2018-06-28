function [data] = story_resting(rest_dur, data, s_num)

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect text_color% lb tb recsize barsize rec; % rating scale

resting_msg = double('이야기의 끝입니다.\n 지금부터는 중앙의 십자 표시를 바라보시며 \n 자유롭게 생각을 하시면 됩니다. \n 중간중간 과제가 나타날 예정입니다.') ;
DrawFormattedText(theWindow, resting_msg, 'center', 'center', text_color);
Screen('Flip', theWindow);

sTime = GetSecs;
while GetSecs - sTime < 10
    % when the story is done, wait for 5 seconds. (in Blank)
end

fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

sTime = GetSecs;
data.resting_start_time{s_num} = GetSecs;
while GetSecs - sTime < rest_dur
    % when the story is done, wait for 5 seconds. (in Blank)
end
data.resting_end_time{s_num} = GetSecs;

end_msg = double('끝입니다.') ;
DrawFormattedText(theWindow, end_msg, 'center', 'center', text_color);
Screen('Flip', theWindow);
end

