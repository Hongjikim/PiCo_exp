function [duration, data] = text_display(my_length, space_loc, doubleText, duration, data)

data.loop_start_time{s_num} = GetSecs;

for i = 1:my_length
    sTime = GetSecs;
    data.dat{s_num}{i}.text_start_time = sTime;
    msg = doubleText(space_loc(i)+1:space_loc(i+1));
    data.dat{s_num}{i}.msg = char(msg);
    data.dat{s_num}{i}.duration = duration(i,2);
   % letter_num = space_loc(i+1) - space_loc(i);
    DrawFormattedText(theWindow, msg, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    while GetSecs - sTime < letter_time + base_time + abs(time_interval(i)) %0.31 %duration(i,2)
    end
    data.dat{s_num}{i}.text_end_time = GetSecs;
    if duration(i,1) > 1
        DrawFormattedText(theWindow, ' ', 'center', 'center', text_color);
        Screen('Flip', theWindow);
        while GetSecs - sTime < duration(i,2)
            %waitsec_fromstarttime(data.loop_start_time{s_num}, 4);
        end
        data.dat{s_num}{i}.blank_end_time = GetSecs;
    end
    data.dat{s_num}{i}.text_end_time = GetSecs;
    if rem(i,5) == 0
        save(data.datafile, 'data', '-append');
    end
end

data.loop_end_time{s_num} = GetSecs;
save(data.datafile, 'data', '-append');

end

