function [duration, doubleText, my_length, space_loc, comma_loc, ending_loc, time_interval, data] = text_duration(Filename, s_num, data)

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale
global letter_time period_time comma_time base_time;

myFile = fopen(Filename,'r'); %fopen('pico_story_kor_ANSI.txt', 'r');
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


for j = 1:length(comma_loc)
    if sum(comma_loc(j) + 1 == space_loc) == 0
        disp('*** error in contents! ***')
        fprintf('쉼표 위치: %s \n', doubleText(comma_loc(j)-15:comma_loc(j)))
        sca
        break
    end
end

for k = 1:length(ending_loc)
    if sum(ending_loc(k) + 1 == space_loc) == 0
        disp ('*** error in contents! ***')
        fprintf('마침표 위치: %s', doubleText(ending_loc(k)-15:ending_loc(k)))
        sca
        break
    end
end


duration = zeros(my_length,2);

for i = 1:my_length
    letter_num = space_loc(i+1) - space_loc(i);
    if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
        duration(i,1) = 2; % comma
        duration(i,2) = letter_time + base_time + comma_time + abs(time_interval(i));
        data.dat{s_num}{i}.word_type = 'comma';
    elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
        duration(i,1) = 3; % period
        duration(i,2) = letter_time + base_time + period_time + abs(time_interval(i));
        data.dat{s_num}{i}.word_type = 'period';
    else
        duration(i,1) = 1; % nothing
        duration(i,2) = letter_time + base_time + abs(time_interval(i));
        data.dat{s_num}{i}.word_type = 'words';
    end
    
end

fprintf('\n*************************\n\ntotal time: %.2f seconds \n', sum(duration(:,2)));
fprintf('total words: %.f words \n\n*************************\n', my_length);
