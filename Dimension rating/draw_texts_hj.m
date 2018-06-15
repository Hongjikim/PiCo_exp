%% Draw texts!!
%global korean;

[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

Screen('Preference', 'SkipSyncTests',1);
% Screen('Preference', 'TextEncodingLocale', 'ko_KR.UTF-8');
% myfont = 'NanumBarunGothic';

sentence1 = '안녕하세요.'; %한글이 안 보인다.ㅠ
sentence2 = 'Hello World!';

% Screen('TextFont', windowPtr, 'Times');
% Screen('TextSize', windowPtr, 48);
% Screen('DrawText', windowPtr, sentence2, 100, 100, 0);
 
DrawFormattedText(windowPtr,'안녕하세요','center','center',0);

Screen('Flip', windowPtr);

KbStrokeWait;
sca;