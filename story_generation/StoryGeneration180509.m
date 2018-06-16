%% PSG (Pico Story Generation)

% story.subID = input('subject ID?:', 's');
% s = input('story number? (1-8)');
% story(s).topic = input('\n topic?:', 's');
% CAPS2, SEMIC, FAST data structure 참고하기 저장되게 만들
%%

% data save
basedir = '/Users/hongji/Dropbox/MATLAB_hongji/github_hongji/Pico_v0/story_display/';
cd(basedir); addpath(genpath(basedir));

subject_ID = input('Subject ID? (P001_KJH):', 's');
% %subject_ID = trim(subject_ID);
% %subject_number = input('Subject number?:', 's');
run_number = input('run number?:');
%subject_ID = 'test_OJW';
%run_number = 4;
savedir = fullfile(basedir, 'Data_Pico');
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = subject_ID;
data.datafile = fullfile(savedir, [subjdate, '_PICO_', subject_ID, '_run', sprintf('%.2d', run_number), '.mat']);
data.version = 'PICO_v0_05-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

if exist(data.datafile, 'file')
    cont_or_not = input(['\nYou type the run number that is inconsistent with the data previously saved.', ...
        '\nWill you go on with your run number that typed just before?', ...
        '\n1: Yes, continue with typed run number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Breaked.')
    elseif cont_or_not == 1
        save(data.datafile, 'data');
    end
else
    save(data.datafile, 'data');
end

Filename = input('***** Write the exact file name(Ex. pico_story.txt):', 's');
data.text_file_name = Filename;


if exist('curr_story', 'var') == 0
    curr_story = ' ';
end

new_sentence = input('\n **** 다음 문장을 입력하시오:', 's');
curr_story = [curr_story, new_sentence]
doublestory = double(curr_story);

if doublestory(end) ~= 32
    doublestory= [doublestory 32];
    curr_story = char(doublestory);
end

space_loc = find(doublestory==32); % location of space ' '
comma_loc = find(doublestory==44);
ending_loc = find(doublestory==46);

space_loc = [0 space_loc];
my_length = length(space_loc)-1;

time_interval = randn(1,my_length)*.4;
%mean(time_interval);
%time_cal = length(comma_loc)*0.34 + length(ending_loc)*0.9 + length(space_loc)*0.31 + sum(abs(time_interval));

letter_time =  0.15*4;   %0.15*4
period_time = 3;
comma_time = 1.5;
base_time = 0;

time_cal_comma = 0;
time_cal_ending = 0;
time_cal_space = 0;


duration = zeros(my_length,2);

for i = 1:my_length
    letter_num = space_loc(i+1) - space_loc(i);
    if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
        duration(i,1) = 2; % comma
        duration(i,2) = letter_time + base_time + comma_time + abs(time_interval(i));
        
    elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
        duration(i,1) = 3; % period
        duration(i,2) = letter_time + base_time + period_time + abs(time_interval(i));
        
    else
        duration(i,1) = 1; % nothing
        duration(i,2) = letter_time + base_time + abs(time_interval(i));
        
    end
    
end

fprintf('\n*************************\n\ntotal time: %.2f seconds \n', sum(duration(:,2)));
fprintf('total words: %.f words \n\n*************************\n', my_length);

