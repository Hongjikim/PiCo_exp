function pico_wordsampling_Mac(varargin)

% This function can be used to transcribe the PiCo fmri word generation responses.
%
% :Usage:
% ::
%       fast_fmri_transcribe_responses(varargin)
%
%
% :Optional Inputs: Enter keyword followed by variable with values
%
%   **'savedir':**
%           default is /data of the current directory
%
%   **'response_n':**
%           If you want to transcribe some specific numbers, you can use
%           this option.
%
%   **'nosound':**
%           You can use this option while running the word generation task
%           in the scanner (fast_fmri_word_generation.m).
%
%   **'only_na':**
%           This will play the sound for the responses you couldn't hear at
%           the first try ('na').
%
% :Example:
%    fast_fmri_transcribe_responses('nosound') % while running fast_fmri_word_generation in the scanner
%
%    fast_fmri_transcribe_responses('only_na') % after running fast_fmri_word_generation
%
%    fast_fmri_transcribe_responses('response_n', [2 6 38]) % playing sound only a few specific trials
%
%    fast_fmri_transcribe_responses('response_n', [2 6 38], 'nosound') % playing sound only a few specific trials
%
%    fast_fmri_transcribe_responses % after running fast_fmri_word_generation
%
% ..
%    Copyright (C) 2017 COCOAN lab
% ..
%
%    If you have any questions, please email to:
%
%          Byeol Kim (roadndream@naver.com) or
%          Wani Woo (waniwoo@skku.edu)
%

%% PARSING OUT OPTIONAL INPUT
savedir = fullfile(pwd, 'data');
% do_playsound = true;


%% INFO CHECK
basedir = '/Users/hongji/Dropbox/PiCo_fmri_task_data';
datdir = fullfile(basedir, 'data') ;

sid = input('Subject ID? (e.g., pico001): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');
[~, sid] = fileparts(subject_dir);

run_n = input('RUN number? (1=preFT, 2~6 = Story, 7 = postFT): ');

%% CREATE AND SAVE DATA

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = sid;
data.datafile = fullfile(subject_dir, ['WORDSAMPLING_', sprintf('%.7s', sid), '_run', sprintf('%.1d', run_n), '.mat']);
data.version = 'PICO_v1_09-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

if exist(data.datafile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', data.subject, subjdate);
    cont_or_not = input(['\nYou type the run number that is inconsistent with the data previously saved.', ...
        '\nWill you go on with your run number that typed just before?', ...
        '\n1: Yes, continue with typed run number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Breaked.')
    elseif cont_or_not == 1
        save(data.datafile, 'data');
    end
else
    save(data.datafile, 'data');
end

% dat_file = fullfile(datdir, ['a_wordsampling_sub' SID '_sess' SessID '.mat']);
% %save_file = fullfile(savedir, ['b_responsedata_sub' SID '_sess' SessID '.mat']);
%
% load(dat_file);
% %load(save_file);

% Response_N
% response_n = 1:numel(wgdata.audiodata); % wgdata.audiodata = 1x40
response_n = [1:6];
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'nosound'}
                response_n = [1:40];
            case {'response_n'}
                response_n = varargin{i+1};
                if size(response_n,1) > size(response_n,2), response_n = response_n'; end
            case {'only_na'}
                response_n = (find(strcmp(response, 'na'))')-1;  % If the two strings are same, the result is 1. If not, 0.
        end
    end
end

%% PLAY RESPONSES

for response_i = response_n   % in case of no-sound, 1:40
    
    str{1} = '==================================================';
    str{2} = sprintf('    %2dth word sampling   ', response_i);
    str{3} = '==================================================';
    
    % clc;  % clear the screen...
    
    for i = 1:numel(str), disp(str{i}); end
    
    input_key = '';
    while isempty(deblank(input_key))
        sprintf('    %2d번째 자유생각 단어는 무엇인가요   ', response_i);
        input_key = input('단어를 적고 엔터키를 눌러주세요. 못들었으면 ''X''를 적은 후 엔터키를 눌러주세요:  ', 's');
    end
    
    response{response_i} = input_key;
    
    save(data.datafile, 'response'); % save the data
end
response

end

