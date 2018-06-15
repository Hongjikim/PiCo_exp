function showParagraph()

global ptb_drawformattedtext_disableClipping
ptb_drawformattedtext_disableClipping = 1;

myFile = fopen('pico_eng_2copy.txt', 'r');
myText = fgetl(myFile);
fclose(myFile);

Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]);

textColor = 50;
wrapAt = 50;

Screen('TextFont', windowPtr, 'Times');
Screen('TextSize', windowPtr, 40);
DrawFormattedText(windowPtr, myText, 'center', 'center', textColor, wrapAt);
Screen('Flip', windowPtr);

KbStrokeWait;
sca;

end