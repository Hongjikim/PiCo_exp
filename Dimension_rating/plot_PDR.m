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

self_val = filenames('*self_val*');

for ii = 1:numel(self_val)
    load(self_val{ii});

    data.trajectory_save{3,1}=data.trajectory_save{1,1} - 220;
    for i = 2:14
        data.trajectory_save{3,i} = data.trajectory_save{1,i} + data.trajectory_save{3,i-1}(end);
    end
    
    for i = 1:2:14, data.trajectory_save{4,i}=data.trajectory_save{2,i}-480; end
    for i = 2:2:14, data.trajectory_save{4,i}=data.trajectory_save{2,i}-960; end
    
    hold on;
    plot2 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 2.5);
    ylabel('Valence');
end

for ii = 1:numel(fnames_val)
    load(fnames_val{ii});

    data.trajectory_save{3,1}=data.trajectory_save{1,1} - 220;
    for i = 2:14
        data.trajectory_save{3,i} = data.trajectory_save{1,i} + data.trajectory_save{3,i-1}(end);
    end
    
    for i = 1:2:14, data.trajectory_save{4,i}=data.trajectory_save{2,i}-480; end
    for i = 2:2:14, data.trajectory_save{4,i}=data.trajectory_save{2,i}-960; end
    
    hold on;
    plot2 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 1);
    plot2.Color(4) = 0.3; 
    ylabel('Valence');
    
    all_y_dat_val{ii} = cat(1,data.trajectory_save{4,:}) ;
    
end

all_y_cat_dat_val = cat(1,all_y_dat_val{1,:}) ; 
mean_y_val = - mean(all_y_cat_dat_val);
hold on;
plot([0 20000], [mean_y_val mean_y_val], '--b', 'linewidth', 2.0); % 'Color', [1 0 0]) ; 
    
box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 20, 'xlim', [0 18500], 'ylim', [-250 250], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);

hold on; 
subplot(2,1,2);

self_sr = filenames('*self_self*');
for ii = 1:numel(self_sr)
    load(self_sr{ii});

    data.trajectory_save{3,1}=data.trajectory_save{1,1} - 220;
    for i = 2:14
        data.trajectory_save{3,i} = data.trajectory_save{1,i} + data.trajectory_save{3,i-1}(end);
    end
    
    for i = 1:2:14, data.trajectory_save{4,i}=data.trajectory_save{2,i}-480; end
    for i = 2:2:14, data.trajectory_save{4,i}=data.trajectory_save{2,i}-960; end
    
    hold on;
    plot2 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 2.5);
    ylabel('Valence');
end

for ii = 1:numel(fnames_sr)
    load(fnames_sr{ii});
   
    data.trajectory_save{3,1}=data.trajectory_save{1,1} - 220;
    for i = 2:14
        data.trajectory_save{3,i}=data.trajectory_save{1,i}+data.trajectory_save{3,i-1}(end);
    end
    
    for i = 1:2:14, data.trajectory_save{4,i}=data.trajectory_save{2,i}-480; end
    for i = 2:2:14, data.trajectory_save{4,i}=data.trajectory_save{2,i}-960; end
    
    
    hold on;
    plot1 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth',1);
    plot1.Color(4) = 0.3; 
    ylabel('Self-relevance');
    
    all_y_data_sr{ii} = cat(1,data.trajectory_save{4,:})
    
end

all_y_data_cat_sr = cat(1,all_y_data_sr{1,:}) ; 
mean_y_sr = - mean(all_y_data_cat_sr);
hold on;
plot([0 20000], [mean_y_sr mean_y_sr], '--b', 'linewidth', 2.0); %'Color', [1 0 0]) ; 



box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 20, 'xlim', [0 18500], 'ylim', [-10 350],  'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);
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


%% boxplot

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
    
    for j = 1:2:14, data.trajectory_save{4,j}=data.trajectory_save{2,j}-480; end
    for j = 2:2:14, data.trajectory_save{4,j}=data.trajectory_save{2,j}-960; end
    
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

