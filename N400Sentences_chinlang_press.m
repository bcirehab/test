function N400Sentences_chinlang_press(SubjectNr,CondNr,BlockNr)
tic
if BlockNr==1
TrialFile=[];
else
matdic='J:\11111111\passive\mat\';
FileName=['Vp_' num2str(SubjectNr) 'Vp' num2str(SubjectNr) 'N400Sentences' '_' num2str(CondNr)];
dataset=[matdic FileName];
load (dataset);
end
%%% Preliminary checks for PTB-3 and the function arguments
AssertOpenGL;

%%% Check the function arguments. If not specified, provide default.
if nargin < 1
    SubjectNr = 99;
end
if nargin < 2
    CondNr = 99;
end

%%% define specific stuff
freq = 44100; % set into the needed frequency

%%% set output paths
PathOut=' J:\11111111\passive\';
FileName=['Vp' num2str(SubjectNr) 'N400Sentences' '_' num2str(CondNr)];

%%% Change directory back to the experimental directory.
cd('J:\11111111\passive')

%%% Define the pathway of the tones
SoundDir = 'J:\11111111\passive\chan_wav\';
AudFiles = dir([SoundDir '*.wav']); % find .wav files
nFiles = length(AudFiles);
Wave = [];

%%% Define a cell array where the wordfiles are kept
for i=1:nFiles
    Wave{i} = [SoundDir AudFiles(i).name];
end

%%%%% Initialization of the Sound Drive
% Initialize the sound drive, check very low latency option.
InitializePsychSound(1) % Chose 1 to enable very low latency

%%%%% Open the sound drive and define a handle for the drive for later
% PsychPortAudio operation
nrChannels=2; % define if mono or stereo chan   nels
paHandle = PsychPortAudio('Open', [], 1, 1, freq, nrChannels);

%%%%% Fill the sound files into the Buffer
buffer = [];
j = 0;
for i=1:nFiles
    [AudData, inFreq] = wavread(char(Wave{i}));
    j = j + 1;
   ninChannels = size(AudData,2);
    AudData = repmat(transpose(AudData), nrChannels / ninChannels, 1);
    buffer(j)=PsychPortAudio('CreateBuffer', [], AudData);
    % Fill the buffer with the audiofiles and give label
    [a, fName] = fileparts(char(Wave(j)));
    fprintf('Filling audiobuffer handle %i with soundfile %s ...\n', buffer(j), fName);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Display the screen instructions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  detScreen=Screen('Screens'); % determine the numbers of screen available
%  screenNum=max(detScreen); % screen number is used for experiment, i.e., secondary screen= experimental monitor
%  dGray=(BlackIndex(screenNum)+GrayIndex(screenNum))/2; % determine the background colour of the experimental screen
%  [dispW] = Screen('OpenWindow', screenNum, dGray); %dispW = the handle for the display window
%  Screen('TextSize', dispW, 28);
%  DrawFormattedText(dispW, 'Please pay attention to the sound!', 'center', 'center', WhiteIndex(dispW));
%  Screen('Flip', dispW);
% %  pause
% %  DrawFormattedText(dispW, 'Bitte hören Sie auf die Sätze und \n \n schauen Sie dabei auf das Fixationskreuz \n \n in der Mitte des Bildschirms.', 'center', 'center', WhiteIndex(dispW));
% %  Screen('Flip', dispW);
% %  pause
% %  DrawFormattedText(dispW, 'Sind Sie bereit? \n \n Das Experiment startet in 5 Sekunden.', 'center', 'center', WhiteIndex(dispW));
% %  Screen('Flip', dispW);
%  WaitSecs(5)
%  
%  Screen('TextSize', dispW, 32);
%  DrawFormattedText(dispW, '+', 'center', 'center', WhiteIndex(dispW));
%  Screen('Flip', dispW);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Different Conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if BlockNr==1
[matTrials]= chinlang_rand( SubjectNr,CondNr );
% [matTrials]= chinlang_rand;
filename=['matTrial_' num2str(SubjectNr) '_' num2str(CondNr) '.mat'];
save(filename,'matTrials');
else
filename=['matTrial_' num2str(SubjectNr) '_' num2str(CondNr) '.mat'];
load(filename);
end
% Produces a 400x2 matrix consisting of buffer codes and long SOAs
% spDelay=zeros(length(matTrials),1); % calculate the sound card delay
% sptime = zeros(length(matTrials),1); % calculate time
%%%%%%%lqy
spDelay=[]; % calculate the sound card delay
sptime = []; % calculate time


%%% indicates start of the experiment
lptwrite(888,255);
WaitSecs(0.004);
lptwrite(888,0);
WaitSecs(3.000);
Keywords=[];
Respontime=[];
%for i=1:length(matTrials)

for i=1+(BlockNr-1)*200:BlockNr*200
    PsychPortAudio('FillBuffer', paHandle,matTrials(i,1));
    PsychPortAudio('Start', paHandle, 1, inf, 0);

    % Wait for 100 msecs so that hardware is running and settled,
    % then start port audio immediately.
    WaitSecs(0.100);
    PsychPortAudio('RescheduleStart', paHandle, 0, 0);
   
    % Provide offset and wait until the first sample is played for
    % more precise time index of playback and more accurate
    % presentation of triggers.
    offset = 0;
    t1=GetSecs;
    while offset == 0
        status = PsychPortAudio('GetStatus', paHandle);
        offset = status.PositionSecs;
        if offset>0
            break;
        end
        WaitSecs('YieldSecs', 0.001);
    end
    
    % Send trigger for the Sentences
    WaitSecs(0.010); % Compensate residual delay so that triggers coincide with sounds.
    lptwrite(888,matTrials(i,3));
    WaitSecs(0.004);
    lptwrite(888,0);

    
    
    

    
    %oekeys=RestrictKeysForKbCheck([]); % Restore key responses from restricted access
%%%%%%%%%%%%%lqy
% sptime(i,1) = t1;

t2=GetSecs;
% spDelay(i,1)=t2-t1+.100-0.014; % See the delay in real time
spDelay=[spDelay;t2-t1+.100-0.014];
sptime=[sptime;t1];
soatime=matTrials(i,2);
audiostatus=1;

t3=GetSecs;
if soatime==5
  WaitSecs(5); 
end
  
% if soatime==5
%     
%    [CurrentTime,KeyWord,PressTime]=KbPressWait([],t3+5); 
%    ResponseTime=CurrentTime-t3;
%    ch=find(KeyWord~=0);
%    if isempty(ch)
%        ch=0;
%    end
%    Keywords=[Keywords;ch];
%    Respontime=[Respontime;ResponseTime];
% else
%     ResponseTime=0;
%      Keywords=[Keywords;0];
%    Respontime=[Respontime;0];
% end

% while audiostatus~=0
%         status = PsychPortAudio('GetStatus', paHandle);
%          audiostatus = status.Active;
%         if audiostatus==0
%             WaitSecs(soatime-ResponseTime);
%             break;
%         end
% end


end

WaitSecs(5.000);
lptwrite(888,254);
WaitSecs(0.004);
lptwrite(888,0);

    
TrialFile= [TrialFile;matTrials(1+(BlockNr-1)*200:BlockNr*200,:) sptime spDelay ];

%%% save mat Files
save([PathOut '\mat\Vp_' num2str(SubjectNr) FileName '.mat'], 'TrialFile');
%%% save txt File
% fid = fopen([PathOut '\txt\Vp' num2str(SubjectNr) FileName '.txt'],'wt');
% fprintf(fid,'%u %4.4f %8.8f\n',TrialFile');
% fclose(fid);

%% Close everything
PsychPortAudio('Stop', paHandle);
PsychPortAudio('DeleteBuffer');
PsychPortAudio('Close');
Screen('CloseAll')
fprintf('Done!\n');

