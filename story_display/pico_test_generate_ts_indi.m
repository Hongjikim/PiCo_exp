function [ts] = pico_test_generate_ts_indi(varargin)
% 
% function [ts] = pico_fmri_generate_ts
% 
% To make 8 stories into word unit and randomize the order
%
%
% ..
%    Copyright (C) 2018  Cocoan lab
% ..
%
%
%%
clf;

datdir = '/Users/hongji/Dropbox/PiCo_fmri_task_data/data';  % edit 'data'
sid = input('Subject ID? (e.g., pico001): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');

stories = filenames(fullfile(subject_dir, '*.txt')); % story01.txt story02.txt

%% VARAGIN 
shortmode = false;
longmode = false;

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'test', 'short'}
                shortmode = true;
            case {'long'}
                longmode = true; 
        end
    end
end

%% story order (randomize)

% reorder: stories 
rng('shuffle');

rand_order_odd = [2*randperm(3)-1; 2*(randperm(3)+2)];
rand_order_even = [2*randperm(2); 2*(randperm(2)+2)+1];

rand_order_all = [rand_order_odd rand_order_even]; 
mix_order = randperm(5);
for i = 1:5
    rand_order(:,i) = rand_order_all(:,mix_order(i));
end
self_common = [ones(1,5);ones(1,5)*2];
idx = randperm(4,2);
self_common(:,idx) = self_common([2 1],idx);
self_common(:,5) = randperm(2)';

for i = 1:size(rand_order,2)
    rand_order(:,i) = rand_order(self_common(:,i),i);
end

rand_order = rand_order(:);
stories = stories(rand_order);



%% calculate and print out text duration

%load('common_ts09-Sep-2018_16_50.mat');
% common_out = out;

for story_i = 1:10
    %if sum(story_i == find(rand_order<5)) == 1
        if shortmode == true
            [out{story_i}, cal_duration, my_length] = pico_text_duration_test(stories{story_i});
        elseif longmode == true
            [out{story_i}, cal_duration, my_length] = pico_text_duration(stories{story_i});
        end
        
        [~, story_name] = fileparts(stories{story_i});
        out{story_i}{1}.story_name = story_name;
        out{story_i}{1}.story_time = cal_duration;
%        out{story_i}{1}.rating_period_loc = rating_period_loc;
%       out{story_i}{1}.rating_period_time = rating_period_time;
        fprintf('\n*************************\n text file: %s', stories{story_i});
        fprintf('\n total time: %.2f seconds', cal_duration);
        fprintf('\n total words: %.f words \n*************************\n', my_length);
        if rand_order(story_i) == 1 || rand_order(story_i) == 2 || rand_order(story_i) == 3 || rand_order(story_i) == 4
            plot(story_i, cal_duration, 'ro')
        else
            plot(story_i, cal_duration, 'bo')
        end
        hold on;
%     %else
%         out{story_i} = common_out{rand_order(story_i)};
%         plot(story_i, common_out{rand_order(story_i)}{1}.story_time, 'o')
%         hold on;
%     end
end

xlim([0 11])
ylim([200 290])
%ylim([0 2])


plot1 = plot([0 22], [215 215]);
plot2 = plot([0 11], [220 220]);
plot3 = plot([0 22], [225 225]);
plot4 = plot([0 11], [230 230]);
legend([plot1, plot2, plot3, plot4], '215','220', '225', '230')

for story_i = 1:numel(stories)
    fprintf('story order %d: %s\n', story_i, out{story_i}{1}.story_name)
end


%% add out into ts

run_i = 1;
ts{run_i}{1} = out{1};
ts{run_i}{2} = out{2};

run_i = 2;
ts{run_i}{1} = out{3};
ts{run_i}{2} = out{4};

run_i = 3;
ts{run_i}{1} = out{5};
ts{run_i}{2} = out{6};

run_i = 4;
ts{run_i}{1} = out{7};
ts{run_i}{2} = out{8};

run_i = 5;
ts{run_i}{1} = out{9};
ts{run_i}{2} = out{10};

%% save ts
% nowtime = clock;
% savename = fullfile(subject_dir, ['trial_sequence_' date '_' num2str(nowtime(4)) '_' num2str(nowtime(5)) '.mat']);
% save(savename, 'ts');

end