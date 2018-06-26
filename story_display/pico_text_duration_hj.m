function [out, cal_duration, my_length] = pico_text_duration_hj(fname)

% out = pico_text_duration(fname)
%
% :Output:
%
%    out{i}.total_duration
%    out{i}.word_type
%    out{i}.word_duration
%    out{i}.msg
%    out{i}.msg_double
%
%    i: the number of words in a story


% default setting
letter_time =  0.15*4;   %0.15*4
period_time = 3;
comma_time = 1.5;
base_time = 0;

myFile = fopen(fname, 'r'); %fopen('pico_story_kor_ANSI.txt', 'r');
myText = fgetl(myFile);
fclose(myFile);
doubleText = double(myText);

if doubleText(end) ~= 32
    doubleText= [doubleText 32];
end

space_loc = find(doubleText==32); % location of space ' '
comma_loc = find(doubleText==44);
ending_loc = find(doubleText==46);

space_loc = [0 space_loc];
my_length = length(space_loc)-1;

time_interval = randn(1,my_length)*.4; % *0.1
%mean(time_interval);

cal_duration = 0;

for i = 1:my_length
    
    % letter_num = space_loc(i+1) - space_loc(i);
    if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
        out{i}.total_duration= letter_time + base_time + comma_time + abs(time_interval(i));
        out{i}.word_type = 'comma';
    elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
        out{i}.total_duration= letter_time + base_time + period_time + abs(time_interval(i));
        out{i}.word_type = 'period';
    else
        out{i}.total_duration= letter_time + base_time + abs(time_interval(i));
        out{i}.word_type = 'words';
    end
    
    cal_duration = cal_duration + out{i}.total_duration;
    out{i}.word_duration = letter_time + base_time + abs(time_interval(i));
    msg = doubleText(space_loc(i)+1:space_loc(i+1));
    msg(msg==32) = []; % deblank
    out{i}.msg = char(msg);
    out{i}.msg_double = msg;
end

% fprintf('\n*************************\ntext title: %s', Filename{s_num});
% fprintf('\ntotal time: %.2f seconds \n', sum(duration(:,2)));
% fprintf('total words: %.f words \n*************************\n', my_length);

end
