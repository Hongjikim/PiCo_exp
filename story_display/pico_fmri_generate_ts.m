function ts = pico_fmri_generate_ts(subject_dir)

stories = filenames(fullfile(subject_dir, '*.txt')); % story01.txt story02.txt

%% story order (randomize)




%% text_duration 

for story_i = 1:numel(stories)
    out = pico_text_duration(stories{story_i})
end

%%
% fprintf('\n*************************\ntext title: %s', Filename{s_num});
% fprintf('\ntotal time: %.2f seconds \n', sum(duration(:,2)));
% fprintf('total words: %.f words \n*************************\n', my_length);

% save ts

end