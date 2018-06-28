%% in subjecdir (should not be in github directory)

% text files
% data
% eye, biopac, etc.
% words_data

%%
% subject_dir = '/Users/hongji/Dropbox/PiCo_git/data/pico001_khj'; 
% cd(subject_dir); addpath(genpath(subject_dir));


ts= pico_fmri_generate_ts_hj; 
% ts{1}: run1
% ts{2}: run2..

%% resting
pico_fmri_resting(1);

%% run 1
run_i = 1;
pico_fmri_task_main_hj('testmode'); % 'biopac', 'fmri',  'eye');

%% run 2
run_i = 2;
pico_fmri_task_main(ts{run_i}, 'fmri', 'biopac', 'eye');

%% run 3
run_i = 3;
pico_fmri_task_main(ts{run_i}, 'fmri', 'biopac', 'eye');

%% run 4
run_i = 4;
pico_fmri_task_main(ts{run_i}, 'fmri', 'biopac', 'eye');

%% resting
pico_fmri_resting(2);

%% post-scan survey
pico_post_survey(subjecdir); % read the subject's word data in the directory