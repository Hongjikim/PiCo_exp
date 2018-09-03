    InitializePsychSound;
        pahandle = PsychPortAudio('Open', [], 2, 0, 44100, 2);
        % Sound recording: Preallocate an internal audio recording  buffer with a capacity of 10 seconds
        PsychPortAudio('GetAudioData', pahandle, 10);


   % beeping
            beep = MakeBeep(1000,.2);
            Snd('Play',beep);