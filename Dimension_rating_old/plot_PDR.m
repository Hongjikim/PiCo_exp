%%
% 
%  ¿ø°æ¾¾²¨¸¸ µû·Î »©±â
%  ³ª¸ÓÁö´Â Á» ¾ã°í Åõ¸íÇÏ°Ô
%  »ö±ò ¸ÂÃß±â
%  ¹ÙÀÌ¿Ã¸° ÇÃ¶ù
 
%% vis one person's data
cd('/Users/hongji/Dropbox/PiCo_git/Dimension_rating/Data_PDR');
fnames_sr = filenames('*self*relevance*');
fnames_val = filenames('*alence*');

%%
subplot(2,1,1);

for ii = 1:numel(fnames_val)
    load(fnames_val{ii});
    line_number =  numel(data.trajectory_save)/2 ; 
    
    for i = 1:line_number
        length_line{ii,i} = numel(data.trajectory_save{1,i});
    end
end

for i = 1:line_number
    minmin(i) = min([length_line{:,i}]);
end

self_val = filenames('*self_val*');

for ii = 1:numel(self_val)
    load(self_val{ii});
    line_number =  numel(data.trajectory_save)/2 ; 

    
    data.trajectory_save{3,1} = data.trajectory_save{1,1}(1:minmin(1)) - 220;
    for i = 2:line_number
        data.trajectory_save{3,i} = data.trajectory_save{1,i}(1:minmin(i)) + data.trajectory_save{3,i-1}(end) -220;
    end
    
    for i = 1:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - 480;
    end
    
    for i = 2:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - 960;
    end
    
    g = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 2.5);
    ylabel('Valence');
    
    self_val_data = -cat(1,data.trajectory_save{4,:}); 
end

for ii = 1:numel(fnames_val)
    load(fnames_val{ii});
    line_number =  numel(data.trajectory_save)/2 ; 

    
    data.trajectory_save{3,1} = data.trajectory_save{1,1}(1:minmin(1)) - 220;
    for i = 2:line_number
        data.trajectory_save{3,i} = data.trajectory_save{1,i}(1:minmin(i)) + data.trajectory_save{3,i-1}(end) -220;
    end
    
    for i = 1:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - 480;
    end
    
    for i = 2:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - 960;
    end
    
    hold on;
    plot2 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 1);
    plot2.Color(4) = 0.3; 
    ylabel('Valence');

    cat_trajectory{ii,:} = - cat(1,data.trajectory_save{4,:});
    %numel(cat_trajectory{1})
    %all_y_dat_val{ii} = cat(1,data.trajectory_save{4,:}) ;
    
end

% temp = zeros(14705,1);
% 
% for i = 1:9
%     temp = temp + [cat_trajectory{i}];
% end
% mean_temp_val = temp./9 ;
% 
% hold on;
% plot(cat(1,data.trajectory_save{3,:}), mean_temp_val, '--b', 'linewidth', 3.0, 'Color', [1 0 0]); % 'Color', [1 0 0]) ; 

    
for i = 1:9
    for j = 1:numel(cat_trajectory{1})
        new_num_val(i,j) = cat_trajectory{i}(j);
    end
end

mean_val = mean(new_num_val)' ;

f = plot(cat(1,data.trajectory_save{3,:}), mean(new_num_val), '--b', 'linewidth', 3.0, 'Color', [0 1 0]); % 'Color', [1 0 0]) ; 
e = plot(cat(1,data.trajectory_save{3,:}), std(new_num_val)+mean(new_num_val), '--', 'linewidth', 1.0, 'Color', [1 0 0]); % 'Color', [1 0 0]) ; 
plot(cat(1,data.trajectory_save{3,:}), -std(new_num_val)+mean(new_num_val), '--', 'linewidth', 1.0, 'Color', [1 0 0]); % 'Color', [1 0 0]) ; 

legend([e, f, g], 'SD', 'Mean', 'Story Owner', 'Location', 'NorthEastOutside')

box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 20, 'xlim', [0 16000], 'ylim', [-250 250], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);

clear minmin

% self-relevance
hold on; 
subplot(2,1,2);

for ii = 1:numel(fnames_sr)
    load(fnames_sr{ii});
    line_number =  numel(data.trajectory_save)/2 ; 
    
    for i = 1:line_number
        length_line{ii,i} = numel(data.trajectory_save{1,i});
    end
end

for i = 1:line_number
    minmin(i) = min([length_line{:,i}]);
end

self_sr = filenames('*self_self*');
for ii = 1:numel(self_sr)
    load(self_sr{ii});
    line_number =  numel(data.trajectory_save)/2 ; 

    data.trajectory_save{3,1} = data.trajectory_save{1,1}(1:minmin(1)) - 220;
    for i = 2:line_number
        data.trajectory_save{3,i} = data.trajectory_save{1,i}(1:minmin(i)) + data.trajectory_save{3,i-1}(end) -220;
    end
    
    for i = 1:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - 480;
    end
    
    for i = 2:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - 960;
    end
    
    hold on;
    d = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 2.5);
    ylabel('Self-Releavnce');
    %legend('story owner');
    
    self_sr_data = -cat(1,data.trajectory_save{4,:}); 
    
end


for ii = 1:numel(fnames_sr)
    load(fnames_sr{ii});
    line_number =  numel(data.trajectory_save)/2 ; 

    
    data.trajectory_save{3,1} = data.trajectory_save{1,1}(1:minmin(1)) - 220;
    for i = 2:line_number
        data.trajectory_save{3,i} = data.trajectory_save{1,i}(1:minmin(i)) + data.trajectory_save{3,i-1}(end) -220;
    end
    
    for i = 1:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - 480;
    end
    
    for i = 2:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - 960;
    end
    
    hold on;
    plot2 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 1);
    plot2.Color(4) = 0.3; 
    ylabel('Self-relevance');

    cat_trajectory{ii,:} = - cat(1,data.trajectory_save{4,:});
    %numel(cat_trajectory{1})
    %all_y_dat_val{ii} = cat(1,data.trajectory_save{4,:}) ;
    
end

% temp = zeros(14704,1);
% 
% for i = 2:10
%     temp = temp + [cat_trajectory{i}];
% end
% mean_temp = temp./9 ;
% 
% hold on;
% plot(cat(1,data.trajectory_save{3,:}), mean_temp, 'linewidth', 3.0, 'Color', [1 0 0]); % 'Color', [1 0 0]) ; 

for i = 1:9
    for j = 1:numel(cat_trajectory{1})
        new_num_sr(i,j) = cat_trajectory{i}(j);
    end
end

mean_sr = mean(new_num_sr)';

c = plot(cat(1,data.trajectory_save{3,:}), mean(new_num_sr), '--b', 'linewidth', 3.0, 'Color', [0 1 0]); % 'Color', [1 0 0]) ; 


hold on
a = plot(cat(1,data.trajectory_save{3,:}), std(new_num_sr)+mean(new_num_sr), '--', 'linewidth', 1.0, 'Color', [1 0 0]); % 'Color', [1 0 0]) ; 
b = plot(cat(1,data.trajectory_save{3,:}), -std(new_num_sr)+mean(new_num_sr), '--', 'linewidth', 1.0, 'Color', [1 0 0]); % 'Color', [1 0 0]) ; 
legend([a, c, d], 'SD', 'Mean', 'Story Owner', 'Location', 'NorthEastOutside')

% er_bar = errorbar(cat(1,data.trajectory_save{3,:}),  -cat(1,data.trajectory_save{4,:}), std(new_num_sr)) ;
% er_bar.Color(4) = 0.2; 



box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 20, 'xlim', [0 16000], 'ylim', [-10 350],  'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);
set(gcf, 'Position',  [433 841 2128 497]);
% set(gcf, 'Position', [62         842        1911         349]);
% 
% savename = 'example_box.pdf';
% 
% pagesetup(gcf);
% saveas(gcf, savename);
% 
% pagesetup(gcf);
% saveas(gcf, savename);

subplot(2,1,1)
vp = plot(self_val_data); 
hold on; 
vmp = plot(mean_val);
legend([vp, vmp], 'story owner', 'mean (N=9)')
ylabel('valence')
title ('corr = 0.9362')

subplot(2,1,2)
vp = plot(self_sr_data); 
hold on; 
vmp = plot(mean_sr);
legend([vp, vmp], 'story owner', 'mean (N=9)')
ylabel('self-relavance')
title ('corr = 0.2055')


cor_val = corr(self_val_data, mean_val)
corr_sr = corr(self_sr_data, mean_sr)
%%
boxplot

% valence
max_y = 0;
for i = 1:numel(fnames_val)
    load(fnames_val{i});
    
    for j = 1:2:14, data.trajectory_save{4,j}=data.trajectory_save{2,j}-480; end
    for j = 2:2:14, data.trajectory_save{4,j}=data.trajectory_save{2,j}-960; end
    
    y{i} = -cat(1,data.trajectory_save{4,:});
    max_y = max(max_y, numel(y{i}));
end

y_all = NaN(max_y, numel(fnames_val));

for i = 1:numel(fnames_val)
    y_all(1:numel(y{i}),i) = y{i};
end

cols = [8,81,156
    213,62,79
244,109,67
253,174,97
254,224,139
230,245,152
171,221,164
102,194,165
50,136,189
63.7500   63.7500  165.7500]/255;

boxplot_wani_2016(y_all, 'violin', 'refline', 0, 'colors', cols, 'boxlinewidth', .1, 'box_trans', .8);
set(gcf, 'Position',  [382 783 1348 472]);
hold on;
plot([0 20000], [mean_y_val mean_y_val], '--b', 'linewidth', 2.0); %'Color', [1 0 0]) ; 

% title('Valence of 10 subjects')

%% 
% self-relevance

max_y = 0;
for i = 1:numel(fnames_sr)
    load(fnames_sr{i});
    
    for j = 1:2:numel(data.trajectory_save)/2, data.trajectory_save{4,j}=data.trajectory_save{2,j}-480; end
    for j = 2:2:numel(data.trajectory_save)/2, data.trajectory_save{4,j}=data.trajectory_save{2,j}-960; end
    
    y{i} = -cat(1,data.trajectory_save{4,:});
    max_y = max(max_y, numel(y{i}));
end

y_all = NaN(max_y, numel(fnames_sr));

for i = 1:numel(fnames_sr)
    y_all(1:numel(y{i}),i) = y{i};
end



cols = [8,81,156
    213,62,79
244,109,67
253,174,97
254,224,139
230,245,152
171,221,164
102,194,165
50,136,189
63.7500   63.7500  165.7500]/255;


% cols = [0 0 0
%     213,62,79
% 244,109,67
% 253,174,97
% 254,224,139
% 230,245,152
% 171,221,164
% 102,194,165
% 50,136,189
% 63.7500   63.7500  165.7500]/255;


boxplot_wani_2016(y_all, 'violin', 'refline', 0, 'colors', cols, 'boxlinewidth', .1, 'box_trans', .8);
set(gcf, 'Position',  [382 783 1348 472]);
% title('Self-relevance of 10 subjects')

hold on;
plot([0 20000], [mean_y_sr mean_y_sr], '--b', 'linewidth', 2.0); %'Color', [1 0 0]) ; 

% 
% cols = [1 0.5 0.5
%     0.1 0.6 0.6
%     0.7 0.5 0.5
%     0.95 0.95 0.95
%     0.52 0.75 0
%     0.99 0.82 0.65
%     0.650980392	0.160784314	0.160784314	
%     0.4275    0.7020    0.8941
%     0.2706    0.6039    0.4627];
%     % 0.9373    0.8863    0.3843];
% boxplot_wani_2016(y_all, 'violin', 'color', cols); %, 'color', cols)
% alpha(0.5)

