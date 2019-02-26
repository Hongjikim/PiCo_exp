% Filename = 'sample_3.txt'


myFile = fopen('story_11_KJH.txt','r'); %fopen('pico_story_kor_ANSI.txt', 'r');
myText = fgetl(myFile);
fclose(myFile);
doubleText = double(myText);

if doubleText(end) ~= 32
    doubleText= [doubleText 32 32 32 32 32];
end

%%
space_loc = find(doubleText==32); % location of space ' '
comma_loc = find(doubleText==44);
ending_loc = find(doubleText==46);

space_loc = [0 space_loc];
my_length = length(space_loc)-1;

% line_num = round(my_length/15);
u = 50;

for i = 1:ceil((max(size(doubleText)))/u)
    line{i} = doubleText((u*i-(u-1)):u*i); 
    text{i} = char(line{i});
end

for i = 1:ceil((max(size(doubleText)))/u)
    fprintf(char(line{i}));
    fprintf('\n\n\n\n\n\n\n\n\n');
end


for j = 1:length(comma_loc)
    if sum(comma_loc(j) + 1 == space_loc) == 0
        disp('*** error in contents! ***')
        fprintf('쉼표 위치: %s \n', doubleText(comma_loc(j)-15:comma_loc(j)))
        sca
        break
    end
end

for k = 1:length(ending_loc)
    if sum(ending_loc(k) + 1 == space_loc) == 0
        disp ('*** error in contents! ***')
        fprintf('마침표 위치: %s', doubleText(ending_loc(k)-15:ending_loc(k)))
        sca
        break
    end
end


% a = '보통 성공한 직장인이나 사업가의 이미지는 고급 차 혹은 시계로 대표된다. 하지만 나는 면허증은 있지만'