function [duration, doubleText, my_length, space_loc, comma_loc, ending_loc, time_interval, data] = text_duration(Filename, s_num, data)

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale
global letter_time period_time comma_time base_time window_ratio;


% Filename_2 = Filename(s_num);

myFile = fopen(Filename{s_num},'r'); %fopen('pico_story_kor_ANSI.txt', 'r');
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


for i = 1:my_length
    % letter_num = space_loc(i+1) - space_loc(i);
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

fprintf('\n*************************\ntext title: %s', Filename{s_num});
fprintf('\ntotal time: %.2f seconds \n', sum(duration(:,2)));
fprintf('total words: %.f words \n*************************\n', my_length);
