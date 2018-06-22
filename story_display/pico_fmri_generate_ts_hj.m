function ts = pico_fmri_generate_ts(subject_dir)

stories = filenames(fullfile(subject_dir, '*.txt')); % story01.txt story02.txt
% subject_dir = '/Users/hongji/Dropbox/PiCo_git/story_display/Text Files/P000_sample';

%% story order (randomize)

% reorder: stories 
rand_files = randperm(8)
for i=1:8
    story_file{i,1} = stories{rand_files(i)}
end

%% text_duration 

for story_i = 1:numel(stories)
    %out{story_i}.story_name = story_file{story_i}
    out{story_i} = pico_text_duration_hj(story_file{story_i});
    fprintf('\n*************************\ntext title: %s', story_file{story_i});
    %fprintf('\ntotal time: %.2f seconds \n', sum(duration(:,2)));
    %fprintf('total words: %.f words \n*************************\n', my_length);
    
    
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