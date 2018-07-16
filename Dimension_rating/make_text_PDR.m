function [k, double_reshaped_text] = make_text_PDR(the_text)

%% load and change file format
%myFile = fopen('pico_story_kor_ANSI.txt', 'r');

% the_text = 'story_1_KJH.txt';
myFile = fopen(the_text, 'r');
myText = fgetl(myFile);
fclose(myFile);
doubleText = double(myText);

if doubleText(end) ~= 32
    doubleText= [doubleText 32];
end

space_loc = find(doubleText==32); % location of space ' '
comma_loc = find(doubleText==44);
ending_loc = find(doubleText==46);

space_loc = [0 space_loc];
my_length = length(space_loc)-1;

for j = 1:length(comma_loc)
    if sum(comma_loc(j) + 1 == space_loc) == 0
        disp('*** error in contents! ***')
        fprintf('½°Ç¥ À§Ä¡: %s \n', doubleText(comma_loc(j)-15:comma_loc(j)))
        sca
        break
    end
end

for k = 1:length(ending_loc)
    if sum(ending_loc(k) + 1 == space_loc) == 0
        disp ('*** error in contents! ***')
        fprintf('¸¶Ä§Ç¥ À§Ä¡: %s', doubleText(ending_loc(k)-15:ending_loc(k)))
        sca
        break
    end
end


%% new 

text_length = numel(myText);
s_unit = 65; % sentence length
k = ceil(text_length / s_unit);
new_text_length = s_unit * k;

for i = 1:k
    while myText(s_unit*(i-1)+1) == ' '
        myText = [myText(1:s_unit*(i-1)) myText(s_unit*(i-1)+2:end)];
        doubleText = double(myText);
        space_loc = find(doubleText==32);
        space_loc = [0 space_loc];
    end
    if sum(space_loc == s_unit*i) == 0 % s_unitÀÇ ¹è¼ö¿¡ ºóÄ­ÀÌ ¤¤¤¤
        add_space_n = min(abs(space_loc(find(space_loc < s_unit*i)) - s_unit*i)) ; 
        add_space(1:add_space_n) = ' ';
        myText = [myText(1:s_unit*i - add_space_n) add_space myText(s_unit*i - add_space_n + 1:end)] ; 
        reshaped_Text(i,:) = myText(s_unit*(i-1)+1:s_unit*i) ;
        doubleText = double(myText);
        space_loc = find(doubleText==32);
        space_loc = [0 space_loc];
    elseif sum(space_loc == s_unit*i) == 1 % s_unitÀÇ ¹è¼ö¿¡ ºóÄ­ÀÌ ¤·¤·
            reshaped_Text(i,:) = myText(s_unit*(i-1)+1:s_unit*i);
    end
end

reshaped_Text; 

%% 
double_reshaped_text = double(reshaped_Text);
end