function [k, double_text] = make_text_PDR(the_text)
%% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

%% load and change file format
%myFile = fopen('pico_story_kor_ANSI.txt', 'r');
%the_text = 'Copy_of_pico_story_kor_ANSI.txt'
myFile = fopen(the_text, 'r');
myText = fgetl(myFile);
fclose(myFile);

% reshape the text
size_my_text = size(myText);
text_length = size_my_text(1,2);
k = ceil(text_length / 125);
new_text_length = 125 * k;
myText(1,text_length + 1 : new_text_length) = ' ';
reshaped_Text = reshape(myText,125,k)'; 

% make it double
double_text = double(reshaped_Text);
end