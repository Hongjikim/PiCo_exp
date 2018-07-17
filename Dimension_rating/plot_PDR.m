%% vis one person's data
fnames_sr = filenames('*self*relevance*');
fnames_val = filenames('*alence*');
subplot(2,1,1);

for ii = 1:numel(fnames_sr)
    load(fnames_sr{ii});
    
    data.trajectory_save{3,1}=data.trajectory_save{1,1};
    for i = 2:16
        data.trajectory_save{3,i}=data.trajectory_save{1,i}+data.trajectory_save{3,i-1}(end);
    end
    
    for i = 1:2:16, data.trajectory_save{4,i}=data.trajectory_save{2,i}-327; end
    for i = 2:2:16, data.trajectory_save{4,i}=data.trajectory_save{2,i}-655; end
    
    
    hold on;
    plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth',1);
    ylabel('Self-relevance');
    
end

box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 20, 'xlim', [0 20000], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);


subplot(2,1,2);
for ii = 1:numel(fnames_val)
    load(fnames_val{ii});
    
    
    data.trajectory_save{3,1}=data.trajectory_save{1,1};
    for i = 2:16
        data.trajectory_save{3,i}=data.trajectory_save{1,i}+data.trajectory_save{3,i-1}(end);
    end
    
    for i = 1:2:16, data.trajectory_save{4,i}=data.trajectory_save{2,i}-327; end
    for i = 2:2:16, data.trajectory_save{4,i}=data.trajectory_save{2,i}-655; end
    
    hold on;
    plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}), 'linewidth', 1.5)
    ylabel('Valence');
end

box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 20, 'xlim', [0 20000], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);

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

% self-relevance
max_y = 0;
for i = 1:numel(fnames_sr)
    load(fnames_sr{i});
    
    for j = 1:2:16, data.trajectory_save{4,j}=data.trajectory_save{2,j}-327; end
    for j = 2:2:16, data.trajectory_save{4,j}=data.trajectory_save{2,j}-655; end
    
    y{i} = -cat(1,data.trajectory_save{4,:});
    max_y = max(max_y, numel(y{i}));
end

y_all = NaN(max_y, numel(fnames_sr));

for i = 1:numel(fnames_sr)
    y_all(1:numel(y{i}),i) = y{i};
end

cols = [0.4275    0.7020    0.8941
    0.2706    0.6039    0.4627
    0.9373    0.8863    0.3843];
boxplot_wani_2016(y_all, 'violin', 'color', cols)

