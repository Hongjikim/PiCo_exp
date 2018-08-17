%%
% 
%  ¿ø°æ¾¾²¨¸¸ µû·Î »©±â
%  ³ª¸ÓÁö´Â Á» ¾ã°í Åõ¸íÇÏ°Ô
%  »ö±ò ¸ÂÃß±â
%  ¹ÙÀÌ¿Ã¸° ÇÃ¶ù
 
%% vis one person's data
cd('/Users/hongji/Dropbox/PiCo_git/Dimension_rating/data_lsw');
fnames_sr = filenames('*self*relevance*');
fnames_val = filenames('*alence*');
fnames_vid = filenames('*ividness*');

%% valence - individual

for ii = 1:numel(fnames_val)
    load(fnames_val{ii});
    line_number =  numel(data.trajectory_save)/2 ; 

    for i = 1:line_number
        length_line{ii,i} = numel(data.trajectory_save{1,i});
        minmin(i) = min([length_line{:,i}]);
    end
    
    data.trajectory_save{3,1} = data.trajectory_save{1,1}(1:minmin(1)) - data.trajectory_save{1,1}(1);
    for i = 2:line_number
        data.trajectory_save{3,i} = data.trajectory_save{1,i}(1:minmin(i)) + data.trajectory_save{3,i-1}(end) - data.trajectory_save{1,1}(1);
    end
    
    for i = 1:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - data.trajectory_save{2,1}(1);
    end
    
    for i = 2:2:line_number
        gap1_2 = data.trajectory_save{2,2}(end) - data.trajectory_save{2,3}(1);
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - data.trajectory_save{2,1}(1) - gap1_2;
    end
    
    
    subplot(5,2,ii)
    plot2 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 2, 'color', [0 0.2 0.9]);
    hold on;
    plot([1 numel(cat(1,data.trajectory_save{3,:}))], [0 0], 'linewidth', 1);
    %plot2.Color(4) = 0.3; 
    ylabel('Valence');
    stories = filenames(fullfile('/Users/hongji/Desktop/hongji 2/PiCo/Dimension_rating/pico010_lsw', '*.txt'));
    [~, text_title] = fileparts(stories{ii}); 
    title(char(text_title));

    %box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 10, 'xlim', [0 numel(cat(1,data.trajectory_save{3,:})) + 300], 'ylim', [-150 150], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);

end

clear minmin

%% self-relevance - individual

for ii = 1:numel(fnames_sr)
    load(fnames_sr{ii});
    line_number =  numel(data.trajectory_save)/2 ; 

    for i = 1:line_number
        length_line{ii,i} = numel(data.trajectory_save{1,i});
        minmin(i) = min([length_line{:,i}]);
    end
    
    data.trajectory_save{3,1} = data.trajectory_save{1,1}(1:minmin(1)) - data.trajectory_save{1,1}(1);
    for i = 2:line_number
        data.trajectory_save{3,i} = data.trajectory_save{1,i}(1:minmin(i)) + data.trajectory_save{3,i-1}(end) - data.trajectory_save{1,1}(1);
    end
    
    for i = 1:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - data.trajectory_save{2,1}(1);
    end
    
    for i = 2:2:line_number
        gap1_2 = data.trajectory_save{2,2}(end) - data.trajectory_save{2,3}(1);
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - data.trajectory_save{2,1}(1) - gap1_2;
    end
    
    
    subplot(3,2,ii)
    plot2 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 2, 'color', [0 0.5 0.3]);
    hold on;
    % plot([1 numel(cat(1,data.trajectory_save{3,:}))], [0 0], 'linewidth', 1);
    %plot2.Color(4) = 0.3; 
    ylabel('Self-R');
    stories = filenames(fullfile('/Users/hongji/Desktop/hongji 2/PiCo/Dimension_rating/pico010_lsw', '*.txt'));
    [~, text_title] = fileparts(stories{ii}); 
    title(char(text_title));

    %box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 10, 'xlim', [0 numel(cat(1,data.trajectory_save{3,:})) + 300], 'ylim', [0 130], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);
%set(gca, 'fontsize', 10, 'xlim', [0 16000], 'ylim', [-150 150], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);

    %cat_trajectory{ii,:} = - cat(1,data.trajectory_save{4,:});
    %numel(cat_trajectory{1})
    %all_y_dat_val{ii} = cat(1,data.trajectory_save{4,:}) ;
    
end

for ii = 1:numel(fnames_vid)
    load(fnames_vid{ii});
    line_number =  numel(data.trajectory_save)/2 ; 

    for i = 1:line_number
        length_line{ii,i} = numel(data.trajectory_save{1,i});
        minmin(i) = min([length_line{:,i}]);
    end
    
    data.trajectory_save{3,1} = data.trajectory_save{1,1}(1:minmin(1)) - data.trajectory_save{1,1}(1);
    for i = 2:line_number
        data.trajectory_save{3,i} = data.trajectory_save{1,i}(1:minmin(i)) + data.trajectory_save{3,i-1}(end) - data.trajectory_save{1,1}(1);
    end
    
    for i = 1:2:line_number
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - data.trajectory_save{2,1}(1);
    end
    
    for i = 2:2:line_number
        gap1_2 = data.trajectory_save{2,2}(end) - data.trajectory_save{2,3}(1);
        data.trajectory_save{4,i} = data.trajectory_save{2,i}(1:minmin(i)) - data.trajectory_save{2,1}(1) - gap1_2;
    end
    
    
    subplot(3,2,4+ii)
    plot2 = plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 2, 'color', [0.8 0.4 0.1]);
    hold on;
    % plot([1 numel(cat(1,data.trajectory_save{3,:}))], [0 0], 'linewidth', 1);
    %plot2.Color(4) = 0.3; 
    ylabel('Vividness');
    stories = filenames(fullfile('/Users/hongji/Desktop/hongji 2/PiCo/Dimension_rating/pico010_lsw', '*.txt'));
    [~, text_title] = fileparts(stories{ii}); 
    title(char(text_title));

    %box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 10, 'xlim', [0 numel(cat(1,data.trajectory_save{3,:})) + 300], 'ylim', [0 130], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);
%set(gca, 'fontsize', 10, 'xlim', [0 16000], 'ylim', [-150 150], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);

    %cat_trajectory{ii,:} = - cat(1,data.trajectory_save{4,:});
    %numel(cat_trajectory{1})
    %all_y_dat_val{ii} = cat(1,data.trajectory_save{4,:}) ;
    
end

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

