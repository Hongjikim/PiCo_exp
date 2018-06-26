function ts = pico_fmri_generate_ts(subject_dir)

subject_dir = '/Users/hongji/Dropbox/PiCo_git/story_display/Text Files/P000_sample';
stories = filenames(fullfile(subject_dir, '*.txt')); % story01.txt story02.txt

%% story order (randomize)

% reorder: stories 
rand_files = randperm(8)
for i=1:8
    story_file{i,1} = stories{rand_files(i)}
end

%% text_duration 

for story_i = 1:numel(stories)
    %out{story_i}.story_name = story_file{story_i}
    [out{story_i}, cal_duration, my_length] = pico_text_duration_hj(story_file{story_i});
    fprintf('\n*************************\n text title: %s', story_file{story_i});
    fprintf('\n total time: %.2f seconds', cal_duration);
    fprintf('\n total words: %.f words \n*************************\n', my_length);
    fprintf('\n *************************\n')
end

%%

run_i = 1;
ts{run_i}{1} = out{1};
ts{run_i}{2} = out{2};

run_i = 2;
ts{run_i}{1} = out{3};
ts{run_i}{2} = out{4};

% save ts


end