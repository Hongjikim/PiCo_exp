%% in subjecdir (should not be in github directory)

% text files
% data
% eye, biopac, etc.
% words_data

%% TEST - short
%cd('/Users/hongji/Dropbox/PiCo_git/data');
ts = pico_test_generate_ts_indi('test');

%% TEST - long
cd('/Users/hongji/Dropbox/PiCo_git/data');
ts = pico_test_generate_ts_indi('long');

%% COMMON TS
cd('/Users/hongji/Dropbox/PiCo_git/data');
ts = pico_fmri_generate_ts_common;

%% INDIVIDUAL TS
% cd('/Users/hongji/Dropbox/PipCo_git/data');
ts= pico_fmri_generate_ts_indi;

%% FREE THINKING (N = 1, 2)
pico_fmri_resting(); % 'biopac', 'eye'); %,'testmode')

%% STORY RUNS (N = 1, 2, 3, 4, 5)
pico_fmri_task_main(); %'biopac', 'eye'); % ('testmode'); % 'biopac', 'fmri',  'eye');

%% post-scan survey
pico_wordsampling_Mac

%% Word survey
words = pico_wholewords_Mac;
a_fast_fmri_survey(words);