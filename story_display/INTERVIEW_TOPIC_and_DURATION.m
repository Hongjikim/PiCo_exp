%% TOPIC ORDER
load('RANDOMIZED_INTERVIEW_TOPIC.mat')
subj_num = input('몇번째 참가자입니까?: ');

while subj_num > 24
    subj_num = subj_num - 24;
end

fprintf('subj_num: %d5', subj_num);
topics(subj_num,:)


%% DURATION CALCULATION during INTERVIEW

clear
myText = input('\n 전체 글을 한 줄로 입력하시오: \n', 's');
doubleText = double(myText);

% if exist('curr_story', 'var') == 0
%     curr_story = ' ';
% end
% 
% new_sentence = input('\n **** 다음 문장을 입력하시오:', 's');
% this_story = [curr_story, new_sentence];
% doublestory = double(this_story);
% 
% if doublestory(end) ~= 32
%     doublestory= [doublestory 32];
%     this_story = char(doublestory);
% end

letter_time =  0.6;   %0.15*4
period_time = 1.5; %3;
comma_time = 1; %1.5;
base_time = 0;

if doubleText(end) ~= 32
    doubleText= [doubleText 32];
end

space_loc = find(doubleText==32); % location of space ' '
comma_loc = find(doubleText==44);
ending_loc = find(doubleText==46);

space_loc = [0 space_loc];
my_length = length(space_loc)-1;

cal_duration = 0;  % 63, 93, 139

aa = find([0 space_loc] - [space_loc space_loc(end)] == -1) ; 
if  numel(aa) > 0
    fprintf('******** \n 연속된 빈칸이 %d번째 단어에 있으니 확인 바람.\n', aa)
end

for j = 1:length(comma_loc)
    if sum(comma_loc(j) + 1 == space_loc) == 0
        disp('*** error in contents! ***')
        fprintf('쉼표 위치: %s \n', myText(comma_loc(j)-2:comma_loc(j)))
        fprintf('%s \n', fname)
        break
    end
    for k = 1:length(ending_loc)
        if sum(ending_loc(k) + 1 == space_loc) == 0
            disp ('*** error in contents! ***')
            fprintf('마침표 위치: %s', myText(ending_loc(k)-2:ending_loc(k)))
            fprintf('%s \n', fname)
            return
        end
    end
end

%while final_duration > 225 || final_duration < 220
    
    time_interval = rand(1,my_length)*.7; % *0.1
    cal_duration = 0;
    
    for i = 1:my_length
        
        % letter_num = space_loc(i+1) - space_loc(i);
        if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
            out{i}.total_duration= letter_time + base_time + comma_time + abs(time_interval(i));
            out{i}.word_type = 'comma';
            out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
        elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
            out{i}.total_duration= letter_time + base_time + period_time + abs(time_interval(i));
            out{i}.word_type = 'period';
            out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
        else
            out{i}.total_duration= letter_time + base_time + abs(time_interval(i));
            out{i}.word_type = 'words';
            out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
        end
        
        cal_duration = cal_duration + out{i}.total_duration;
        out{i}.word_duration = letter_time + base_time + abs(time_interval(i));
        msg = doubleText(space_loc(i)+1:space_loc(i+1));
        msg(msg==32) = []; % deblank
        out{i}.msg = char(msg);
        out{i}.msg_double = msg;
    end
    final_duration = cal_duration;
%end

fprintf('\n')
disp('***************')
disp(['단어수:  ', num2str(my_length), '단어 ///  시간:  ', num2str(final_duration), '초'])
disp('***************')
fprintf('\n')
