function [out, cal_duration, my_length, rating_period_loc, rating_period_time] = pico_text_duration(fname)

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
letter_time =  0.6;   %0.15*4
period_time = 3; %3;
comma_time = 1.5; %1.5;
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

time_interval = rand(1,my_length)*.7; % *0.1

cal_duration = 0;  % 63, 93, 139

aa = find([0 space_loc] - [space_loc space_loc(end)] == -1) ; 
if  numel(aa) > 2
    fprintf('연속된 빈칸이 %d째 단어에 있으니 확인 바람.', aa)
end


for j = 1:length(comma_loc)
    if sum(comma_loc(j) + 1 == space_loc) == 0
        disp('*** error in contents! ***')
        fprintf('쉼표 위치: %s \n', myText(comma_loc(j)-2:comma_loc(j)))
        fprintf('%s \n', fname)
        sca
        break
    end
    for k = 1:length(ending_loc)
        if sum(ending_loc(k) + 1 == space_loc) == 0
            disp ('*** error in contents! ***')
            fprintf('마침표 위치: %s', myText(ending_loc(k)-2:ending_loc(k)))
            fprintf('%s \n', fname)
            sca
            return
        end
    end
end

for i = 1:my_length
    
    % letter_num = space_loc(i+1) - space_loc(i);
    if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
        out{i}.total_duration= letter_time + base_time + comma_time + abs(time_interval(i));
        out{i}.word_type = 'comma';
        out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
    elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
        out{i}.total_duration= letter_time + base_time + period_time + abs(time_interval(i));
        out{i}.word_type = 'period';
        out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
    else
        out{i}.total_duration= letter_time + base_time + abs(time_interval(i));
        out{i}.word_type = 'words';
        out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
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


% Emotion Rating Setting  
for i = 1:numel(ending_loc)
    ending_word_loc(i) = find(space_loc == ending_loc(i)+1) - 1;
    ending_time(i) = out{ending_word_loc(i)}.accumulated_duration ;
end

rating_period_n(1) = find(abs(ending_time - (1/3)*cal_duration) == (min(abs(ending_time - (1/3)*cal_duration))));
rating_period_n(2) = find(abs(ending_time - (2/3)*cal_duration) == (min(abs(ending_time - (2/3)*cal_duration))));

rating_period_loc(1) = ending_word_loc(rating_period_n(1));
rating_period_loc(2) = ending_word_loc(rating_period_n(2));

rating_period_time = ending_time(rating_period_n);
end
