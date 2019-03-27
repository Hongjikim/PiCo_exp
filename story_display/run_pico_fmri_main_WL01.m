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

%% FREE THINKING (N = 1, 2)
clear;
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
pico_fmri_resting('biopac'); %biopac'); 
%%
Copy_of_pico_fmri_resting(); %'eye'); 
%% STORY RUNS (N = 1, 2, 3, 4, 5)
clear;
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
pico_fmri_task_main('biopac');

%% post-scan survey
cd('C:\Users\Cocoanlab_WL01\Desktop\PiCo-master\story_display');
pico_wordsampling      

    %%
    words = pico_wholewords; 
    a_fast_fmri_survey(words);   