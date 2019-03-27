function words = pico_wholewords_Mac
%%
% savedir = fullfile(pwd, 'data');
basedir =   '/Users/hongji/Dropbox/PiCo_fmri_task_data'; 
datdir = fullfile(basedir, 'data') ;
sid = input('Subject ID? (e.g., pico001): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');
[~, sid] = fileparts(subject_dir);
sid = sid(1:7);

dat_file{1} = fullfile(subject_dir, ['WORDSAMPLING_' sid '_run1.mat']);
dat_file{2} = fullfile(subject_dir, ['WORDSAMPLING_' sid '_run2.mat']);
dat_file{3} = fullfile(subject_dir, ['WORDSAMPLING_' sid '_run3.mat']);
dat_file{4} = fullfile(subject_dir, ['WORDSAMPLING_' sid '_run4.mat']);
dat_file{5} = fullfile(subject_dir, ['WORDSAMPLING_' sid '_run5.mat']);
dat_file{6} = fullfile(subject_dir, ['WORDSAMPLING_' sid '_run6.mat']);
dat_file{7} = fullfile(subject_dir, ['WORDSAMPLING_' sid '_run7.mat']);
% dat_file{5} = fullfile(savedir, ['b_responsedata_sub' SID '_sess5.mat']);

data = cell(7, 6);
%
for i=1:7
    load(dat_file{i});
    data(i,:)=response;
end

words = data;
words

end



