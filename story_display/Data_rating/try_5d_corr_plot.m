%% Val, SR, TIme, Vid, Safe

cd(  '/Users/hongji/Downloads/pico005_sej_real');
fnames_story_run = filenames('*S_run*');
load('surveydata_subpico005_sej_real.mat');

%% subject-collected


for sub = 1:2
    clear data
    clear survey
    
    cd(  '/Users/hongji/Downloads/pico005_sej_real/Plot_try');
    if sub == 2
        fnames_story_run = filenames('*real_S_run*');
        load('surveydata_subpico005_sej_real.mat');
    else
        fnames_story_run = filenames('*lhj_run*');
        load('surveydata_subpico003_lhj.mat');
    end
    
    
    for run_i = 1:5
        clear data
        load(fnames_story_run{run_i});
        
        for story_num = 1:2
            if story_num == 1
                story_i = run_i * 2 -1;
            else
                story_i = run_i * 2;
            end
            
            for i = 1:5
                mri_5d{story_i}(i) = data.postrunQ{story_num}.dat{i}.rating;
            end
            if story_num == 1
                for j = 1:3
                    for k = 1:5
                        word_5d{story_i}(j,k) = survey.dat{j,run_i+1}{k}.rating;
                    end
                end
            else
                for j = 4:6
                    for k = 1:5
                        word_5d{story_i}(j-3,k) = survey.dat{j,run_i+1}{k}.rating;
                    end
                end
            end
        end
    end
    
    %
    for i = 1:10
        mean_word_5d(i,:) = mean(word_5d{i});
    end
    
    %
    
    %corr(mri_5d{1}', mean_word_5d(1,:)')
    
    %
    %plot1 = plot([-1 1], [-1 1], 'linewidth', 1, 'Color', 'r'); % 'color', [0.9 0 0]);
    % set(gca, 'linewidth', 2, 'color', [100 0 0]);
    hold on;
    %name_short = {'Valence', 'Self-Relevance', 'Time', 'Vividness', 'Safe&Threat'} ;
    name = {'Valence', 'Self-Relevance', 'Time', 'Vividness', 'Safe&Threat'} ;
    
    for j = 1:5
        for i = 1:10
            mr_coll(i,j) = mri_5d{i}(j);
            ws_coll(i,j) = mean_word_5d(i,j);
        end
    end
    
    for i = 1:5
        [corr_r(i), corr_p(i)] = corr(mr_coll(:,i), ws_coll(:,i));
        %corr_plot(i) = corr(mr_coll(:,i), ws_coll(:,i));
    end
    
    %Fcolor{sub} = abs([rand(1,3,1); rand(1,3,1); rand(1,3,1); rand(1,3,1); rand(1,3,1)]);
    Color10 = [158,1,66;
        213,62,79;
        255,125,0;
        255,140,0
        254,0,240;
        0,0,228;
        10,205,200;
        50,200,100;
        50,136,189;
        94,79,162]/255;
    Fcolor{1} = [Color10(1,:); Color10(3,:); Color10(5,:); Color10(7,:); Color10(9,:)] ;
    Fcolor{2} = [Color10(6,:); Color10(10,:); Color10(8,:); Color10(2,:); Color10(4,:)] ;
    
    %
    for j = 1:5
        subplot(3,5,j)
        
        %    for i = 1:10
        %        scatter(mri_5d{i}(j), mean_word_5d(i,j))
        scatter(mr_coll(:,j), ws_coll(:,j), 'filled', 'MarkerEdgeColor', Fcolor{sub}(j,:), 'MarkerFaceColor', Fcolor{sub}(j,:)); %[0, .7, .7])
        % set(gcf, 'color', 'w');
        set(gca, 'fontsize', 14, 'xlim', [-1 1], 'ylim', [-1 1], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);
        xlabel('Rating in fMRI');
        ylabel('Rating in WS');
        hold on;
        %         if j == 3
        %             if sub == 1
        %                 title([char('pico003'), sprintf('\n')]);
        %             else
        %                 title([char('pico005'), sprintf('\n')]);
        %             end
        %         end
        %title(char('r='), char(sprintf('%.3f',corr_r(j))), char(', p= '), char(sprintf('%.3f',corr_p(j))), char('')]);
        %title([char(name(j)), char(' (r='), char(sprintf('%.3f',corr_r(j))), char(', p= '), char(sprintf('%.3f',corr_p(j))), char(')')]);
        title(name(j)); %, char(' (r='), char(sprintf('%.3f',corr_r(j))), char(', p= '), char(sprintf('%.3f',corr_p(j))), char(')')]);
        
        if sub == 2
            h = lsline;
            %set(h,'Color',Fcolor{1}(j,:));
            h(1).Color = Fcolor{1}(j,:);
            h(2).Color = Fcolor{2}(j,:);
        end
    end
end


%% individual

for sub = 1:2
    clear data
    clear survey
    
    cd(  '/Users/hongji/Downloads/pico005_sej_real/Plot_try');
    if sub == 2
        fnames_story_run = filenames('*real_S_run*');
        load('surveydata_subpico005_sej_real.mat');
    else
        fnames_story_run = filenames('*lhj_run*');
        load('surveydata_subpico003_lhj.mat');
    end
    
    
    for run_i = 1:5
        clear data
        load(fnames_story_run{run_i});
        
        for story_num = 1:2
            if story_num == 1
                story_i = run_i * 2 -1;
            else
                story_i = run_i * 2;
            end
            
            for i = 1:5
                mri_5d{story_i}(i) = data.postrunQ{story_num}.dat{i}.rating;
            end
            if story_num == 1
                for j = 1:3
                    for k = 1:5
                        word_5d{story_i}(j,k) = survey.dat{j,run_i+1}{k}.rating;
                    end
                end
            else
                for j = 4:6
                    for k = 1:5
                        word_5d{story_i}(j-3,k) = survey.dat{j,run_i+1}{k}.rating;
                    end
                end
            end
        end
    end
    
    %
    for i = 1:10
        mean_word_5d(i,:) = mean(word_5d{i});
    end
    
    %
    
    %corr(mri_5d{1}', mean_word_5d(1,:)')
    
    %
    %plot1 = plot([-1 1], [-1 1], 'linewidth', 1, 'Color', 'r'); % 'color', [0.9 0 0]);
    % set(gca, 'linewidth', 2, 'color', [100 0 0]);
    hold on;
    %name_short = {'Valence', 'Self-Relevance', 'Time', 'Vividness', 'Safe&Threat'} ;
    name = {'Valence', 'Self-Relevance', 'Time', 'Vividness', 'Safe&Threat'} ;
    
    for j = 1:5
        for i = 1:10
            mr_coll(i,j) = mri_5d{i}(j);
            ws_coll(i,j) = mean_word_5d(i,j);
        end
    end
    
    for i = 1:5
        [corr_r(i), corr_p(i)] = corr(mr_coll(:,i), ws_coll(:,i));
        %corr_plot(i) = corr(mr_coll(:,i), ws_coll(:,i));
    end
    
    %Fcolor{sub} = abs([rand(1,3,1); rand(1,3,1); rand(1,3,1); rand(1,3,1); rand(1,3,1)]);
    Color10 = [158,1,66;
        213,62,79;
        255,125,0;
        255,140,0
        254,0,240;
        0,0,228;
        10,205,200;
        50,200,100;
        50,136,189;
        94,79,162]/255;
    Fcolor{1} = [Color10(1,:); Color10(3,:); Color10(5,:); Color10(7,:); Color10(9,:)] ;
    Fcolor{2} = [Color10(6,:); Color10(10,:); Color10(8,:); Color10(2,:); Color10(4,:)] ;
    
    %
    for j = 1:5
        if sub ==1
            subplot(3,5,j+5)
        else
            subplot(3,5,j+10)
        end
        
        %    for i = 1:10
        %        scatter(mri_5d{i}(j), mean_word_5d(i,j))
        scatter(mr_coll(:,j), ws_coll(:,j), 'filled', 'MarkerEdgeColor', Fcolor{sub}(j,:), 'MarkerFaceColor', Fcolor{sub}(j,:)); %[0, .7, .7])
        % set(gcf, 'color', 'w');
        set(gca, 'fontsize', 14, 'xlim', [-1 1], 'ylim', [-1 1], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);
        xlabel('Rating in fMRI');
        ylabel('Rating in WS'); 
        hold on;
        if j == 3
            if sub == 1
                title([newline, char('pico003'), newline, char('r='), char(sprintf('%.3f',corr_r(j))), char(', p= '), char(sprintf('%.3f',corr_p(j))), char('')]);
            else
                title([char('pico005'), newline, char('r='), char(sprintf('%.3f',corr_r(j))), char(', p= '), char(sprintf('%.3f',corr_p(j))), char('')]);
            end
        else
            title([char('r='), char(sprintf('%.3f',corr_r(j))), char(', p= '), char(sprintf('%.3f',corr_p(j))), char('')]);
        end
        %title([char(name(j)), char(' (r='), char(sprintf('%.3f',corr_r(j))), char(', p= '), char(sprintf('%.3f',corr_p(j))), char(')')]);
        %title(name(j)); %, char(' (r='), char(sprintf('%.3f',corr_r(j))), char(', p= '), char(sprintf('%.3f',corr_p(j))), char(')')]);
        
        clear h
        h = lsline;
        h.Color = Fcolor{sub}(j,:);
        
    end
end

%     if sub == 2
%         clear h
%         h = lsline;
%         %set(h,'Color',Fcolor{1}(j,:));
%         h(1).Color = Fcolor{1}(j,:);
%         h(2).Color = Fcolor{2}(j,:);
%     end

%%
for k = 1:5
    subplot(1,5,k)
    hold on;
    test_lm = fitlm(mr_coll(:,k), ws_coll(:,k), 'linear')
    plot(test_lm)
end


% lsline
% Fcolor = abs([rand(1,3,1); rand(1,3,1); rand(1,3,1); rand(1,3,1); rand(1,3,1)]);

%plot1 = plot([-1 1], [-1 1]);

%legend([plot(1:10)], 'story1', 'story2', 'story3', 'story4', 'story5', 'story6', 'story7', 'story8', 'story9', 'story10')


% set(gca, 'fontsize', 10, 'xlim', [-1 1], 'ylim', [-1 1], 'linewidth', 1.2, 'tickdir', 'out', 'ticklength', [.005 .005]);
% xlabel('Rating in story run (fMRI)');
% ylabel('Rating in word survey (Behavioral)');

