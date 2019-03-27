 %% in subjecdir (should not be in github directory)

% text files
% data
% eye, biopac, etc.
% words_data

%% TEST - short
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
%cd('C:\Users\Cocoanlab_WL01\Desktop\Dropbox\fMRI_task_data\data');
ts = pico_test_generate_ts_indi('test');

%% TEST - long
cd('C:\Users\Cocoanlab_WL01\Desktop\Dropbox\fMRI_task_data\data');
ts = pico_test_generate_ts_indi('long');

%% COMMON TS
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
ts = pico_fmri_generate_ts_common;

%% INDIVIDUAL TS
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
ts= pico_fmri_generate_ts_indi; 

%% PRACTICE 5D Survey (N=3)
Copy_of_pico_fmri_resting(); 

%% FREE THINKING (N = 1, 2)
clear;
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
pico_fmri_resting('eye', 'biopac'); %, 'eye'); %, 'eye'); %, 'eye'); %'biopac', 'eye'); %, 'eye'); % 'biopac', 'eye'); %,'testmode')

%% STORY RUNS (N = 1, 2, 3, 4, 5)
clear;
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
pico_fmri_task_main('biopac', 'eye'); %'biopac'); %, 'eye'); %'biopac', 'eye'); %'biopac','eye'); % ('ptestmode'); % 'biopac', 'fmri',  'eye');

%% INPUT WORDS
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
pico_wordsampling      

%% WORD SURVEY
words = pico_wholewords;
a_fast_fmri_survey(words);
