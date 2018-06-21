function ts = pico_fmri_generate_ts(subject_dir)

stories = filenames(fullfile(subject_dir, '*.txt')); % story01.txt story02.txt

%% story order (randomize)

% reorder: stories 

%% text_duration 

for story_i = 1:numel(stories)
    out{story_i} = pico_text_duration(stories{story_i});
end

%%
% fprintf('\n*************************\ntext title: %s', Filename{s_num});
% fprintf('\ntotal time: %.2f seconds \n', sum(duration(:,2)));
% fprintf('total words: %.f words \n*************************\n', my_length);


run_i = 1;
ts{run_i}{1} = out{1};
ts{run_i}{2} = out{2};

run_i = 2;
ts{run_i}{1} = out{3};
ts{run_i}{2} = out{4};

% save ts


end