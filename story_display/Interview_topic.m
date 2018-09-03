%% SET

topics = {'고통과 아픔', '쾌락과 기쁨', '위협과 위험', '안전과 편안함'};

runs = {1, 2, 3, 4};
runs = runs(perms(1:4));
runs = runs(randperm(size(runs, 1)), :);

%% GET WHAT YOU ALREADLY DID
count = 0 ;
while(1)
    if runs{1,1} == 1 && runs{1,2} == 2 && runs{1,3} == 4 && runs{2,1} == 2 && runs{3,1} == 3 && runs{3,2} == 2 && runs{2,2} == 3 && runs{2,3} ==1
        break;
        count
    else
        runs = runs(randperm(size(runs, 1)), :);
        count = count + 1;
        fprintf('NO\n')
    end
end

runs_save = runs
topics_s = {'고통과 아픔', '쾌락과 기쁨', '위협과 위험', '안전과 편안함'};
topics = {'고통과 아픔', '쾌락과 기쁨', '위협과 위험', '안전과 편안함'};

for i = 2:24
    for j = 1:4
    topics{i,j} = topics{1,j}
    end
end

for i = 1:24
    for j = 1:4
        topics{i,j} = topics_s{1,runs{i,j}}
    end
end

%% SAVE
save('RANDOMIZED_INTERVIEW_TOPIC.mat', 'runs', 'runs_save', 'topics', 'topics_s');