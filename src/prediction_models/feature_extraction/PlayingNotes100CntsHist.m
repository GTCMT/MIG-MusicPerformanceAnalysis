%% 10 cent bin width histogram of notes folded to 100cents
% AV@GTCMT, 2015
% goodness_measure = PlayingNotes100CntsHist(PitchRead)
% objective: Find accuracy of playing notes across the audio without the score being given
%
% INPUTS
% PitchRead: nx1 float array, pitch values in Hz
%
% OUTPUTS
% goodness_measure: value from 0-1 (1: indicating good, low value indicating bad playing style)

function goodness_measure = PlayingNotes100CntsHist(PitchRead)

PitchInCents=1200*log2(PitchRead/440);

% Folding in a single note of the pitch contour
FoldingInNote=PitchInCents;
for i=1:length(PitchInCents)
    k=abs(mod(PitchInCents(i),100));
    FoldingInNote(i)=k;
end

stpSize=10; % 10cent bin intervals
NoteSpan=0:(stpSize/2):100;  % one note spans 100cents and this array specifies the boundaries for comparing and binning values within a note into a histogram
HistFoldedToSingleNote=zeros(length(NoteSpan),2);
HistFoldedToSingleNote(:,1)=NoteSpan;

HistFinal=zeros(floor(length(NoteSpan)/2),2);
ffldh_row=(stpSize/2):stpSize:(100-stpSize/2);
HistFinal(:,1)=ffldh_row';

for i=1:length(FoldingInNote)              % compare the values in the input pitch contour with the boundaries in the NoteSpan array.
    if isnan(FoldingInNote(i))~=1
        for j=1:2:length(HistFoldedToSingleNote)-1
            if FoldingInNote(i)>HistFoldedToSingleNote(j,1) && FoldingInNote(i)<=HistFoldedToSingleNote(j+2,1)  % if the value lies between values at odd locations of NoteSpan the put them in the even value between these values
               HistFoldedToSingleNote((j+1),2)=HistFoldedToSingleNote((j+1),2)+1;
            end
        end
              
    end
end

HistFinal(:,2)=HistFoldedToSingleNote(2:2:length(HistFoldedToSingleNote),2);   % since in the previous step we have a histogram with values at even locations, here we put those together

[~,locshiftInCent]=max(HistFinal(:,2));

% area 10cents before and after the maximum peak location / total area will
% give the godness_measure

if locshiftInCent-1~=0 && locshiftInCent+1<length(HistFinal)
    goodness_measure=sum(HistFinal(locshiftInCent-1:locshiftInCent+1,2))/sum(HistFinal(:,2));
elseif locshiftInCent-1==0
    goodness_measure=(sum(HistFinal(locshiftInCent:locshiftInCent+1,2))+HistFinal(end,2))/sum(HistFinal(:,2));
else
   goodness_measure=(sum(HistFinal(locshiftInCent-1:locshiftInCent,2))+HistFinal(1,2))/sum(HistFinal(:,2)); 
end

end