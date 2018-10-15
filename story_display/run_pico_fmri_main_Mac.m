 %% in subjecdir (should not be in github directory)

% text files
% data
% eye, biopac, etc.
% words_data

%% TEST - short
cd('/Users/hongji/Dropbox/PiCo_git/data');
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

    %%
    words = pico_wholewords;
    a_fast_fmri_survey(words);
    
%% LAPTOP2 - Transcribe ===================================================
    fast_fmri_transcribe_responses('nosound') % while running fast_fmri_word_generation
    
    %%     
    fast_fmri_transcribe_responses('only_na') % after running fast_fmri_word_generation
    
    %%
    fast_fmri_transcribe_responses('response_n', [8]) % playing sound only a few specific trials
    
            %% if you want to revise already written items.
            savedir = fullfile(pwd, 'data');            
            SID = sprintf('F087');
            SessID = input('Session number? ', 's');  
            save(fullfile(savedir, ['b_responsedata_sub' SID '_sess' SessID '.mat']),'response');

            %%             
            N = input('수정할 행?    ','s');
            content = input('수정할 내용?    ','s');
            dat_file = fullfile(savedir, ['b_responsedata_sub' SID '_sess' SessID '.mat']);          
            load(dat_file);
            response{str2double(N),1} = content;            
            save(fullfile(savedir, ['b_responsedata_sub' SID '_sess' SessID '.mat']),'response');
            
%             save(fullfile(savedir, ['d_surveydata_subF073.mat']),'survey');

            
