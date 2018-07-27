%% in subjecdir (should not be in github directory)

% text files
% data
% eye, biopac, etc.
% words_data

%%
cd('/Users/hongji/Dropbox/PiCo_git/story_display'); %edit

ts= pico_fmri_generate_ts;  %error 나타나는 위치 질문

%% resting
pico_fmri_resting(); %'testmode');

%% run 1
% run_i = 1;s
%pico_fmri_task_main('testmode'); % 'biopac', 'fmri',  'eye');
pico_fmri_task_main('biopac', 'eye'); % ('testmode'); % 'biopac', 'fmri',  'eye');

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