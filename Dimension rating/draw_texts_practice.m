%% Draw texts!!
global korean;

[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

Screen('Preference', 'SkipSyncTests');
% Screen('Preference', 'TextEncodingLocale', 'ko_KR.UTF-8');
% myfont = 'NanumBarunGothic';

myFile = fopen('pico_eng_2copy.txt', 'r');
myText = fgetl(myFile);
fclose(myFile);
     
% sentence1 = '안녕하세요.'; %한글이 안 보인다.ㅠ
% sentence2 = 'Hello World!';

% Screen('TextFont', windowPtr, 'Times');
% Screen('TextSize', windowPtr, 48);
% Screen('DrawText', windowPtr, sentence2, 100, 100, 0);
 
% DrawFormattedText(windowPtr,sentence2,'center','center',0, 10);

DrawFormattedText(windowPtr, myText, 100, 100, 0, 110, 0, 0, 9); %

Screen('Flip', windowPtr);
 
KbStrokeWait;
sca;