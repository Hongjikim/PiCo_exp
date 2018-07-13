function [ts] = pico_fmri_generate_ts

datdir = '/Users/hongji/Dropbox/PiCo_git/data'; %'/Users/clinpsywoo/Dropbox/github/PiCo/data';
sid = input('Subject ID? (e.g., pico001): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');

stories = filenames(fullfile(subject_dir, '*.txt')); % story01.txt story02.txt

%% story order (randomize)

% reorder: stories 
rng('shuffle');

rand_order = [randperm(4); randperm(4)];
rand_order(2,:) = rand_order(2,:) + 4;
self_common = [ones(1,4);ones(1,4)*2];
idx = randperm(4,2);
self_common(:,idx) = self_common([2 1],idx);

for i = 1:size(rand_order,2)
    rand_order(:,i) = rand_order(self_common(:,i),i);
end

rand_order = rand_order(:);
stories = stories(rand_order);


%% calculate and print out text duration

for story_i = 1:numel(stories)
    [out{story_i}, cal_duration, my_length, rating_period_loc] = pico_text_duration_0713(stories{story_i});
    [~, story_name] = fileparts(stories{story_i});
    out{story_i}{1}.story_name = story_name;
    out{story_i}{1}.story_time = cal_duration;
    out{story_i}{1}.rating_period_loc = rating_period_loc;
    fprintf('\n*************************\n text file: %s', stories{story_i});
    fprintf('\n total time: %.2f seconds', cal_duration);
    fprintf('\n total words: %.f words \n*************************\n', my_length);
end

for story_i = 1:numel(stories)
    fprintf('story order %d: %s\n', story_i, out{story_i}{1}.story_name)
end

%% add out into ts

run_i = 1;
ts{run_i}{1} = out{1};
ts{run_i}{2} = out{2};

run_i = 2;
ts{run_i}{1} = out{3};
ts{run_i}{2} = out{4};

run_i = 3;
ts{run_i}{1} = out{5};
ts{run_i}{2} = out{6};

run_i = 4;
ts{run_i}{1} = out{7};
ts{run_i}{2} = out{8};

%% save ts
nowtime = clock;
savename = fullfile(subject_dir, ['trial_sequence_' date '_' num2str(nowtime(4)) '_' num2str(nowtime(5)) '.mat']);
save(savename, 'ts');

end