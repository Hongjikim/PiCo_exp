%%
cd('/Users/hongji/Dropbox/PiCo_git/Dimension_rating');
data = dimension_rating('practice')

%%
subject_ID = input('Subject ID?:', 's');
for subject_number = 1:10
    cd('/Users/hongji/Dropbox/PiCo_git/Dimension_rating');
    data = dimension_rating('valence', subject_ID, subject_number)
end

%%
subject_ID = input('Subject ID?:', 's');
for subject_number = 1:10
    cd('/Users/hongji/Dropbox/PiCo_git/Dimension_rating');
    data = dimension_rating('self_relevance', subject_ID, subject_number)
end

%%
subject_ID = input('Subject ID?:', 's');
self_rand = randperm(4,2);
common_rand = randperm(6,2) + 4;
both_rand = [self_rand common_rand];
for i = 1:4
    subject_number = both_rand(i);
    cd('/Users/hongji/Dropbox/PiCo_git/Dimension_rating');
    data = dimension_rating('vividness', subject_ID, subject_number, rand_rodr_vivid)
end