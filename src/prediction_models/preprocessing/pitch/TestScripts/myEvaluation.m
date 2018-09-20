%% Evaluate the results
% [errCent_rms, false_negatives, false_positives] = myEvaluation(estimation, annotation)
% Input:
%   estimation = numBlocks*1 float vector, estimated pitch (Hz) per block   
%   annotation = numBlocks*1 float vector, annotated pitch (Hz) per block
% Output:
%   errCent_rms = float, rms of the difference between estInMidi and annInMidi 
%                 Note: please exclude the blocks when ann(i) == 0
%   false_negatives = % of points where annotated pitch is non-zero 
%                     but estimated pitch is zero
%   false_postives = % of points where annotated pitch is zero but
%                    estimated  pitch is non-zero
% CW @ GTCMT 2015

function [errCent_rms, false_negatives, false_positives] = myEvaluation(estimation, annotation)

ref_freq = 440; % A4 note
num_blocks = min(length(estimation),length(annotation));

i=1;
j=1;

false_negatives = 0;
false_positives = 0;

while(i <= num_blocks)
   if annotation(i) ~= 0 
       if estimation(i) ~= 0
           estimation_Midi(j) = 69 + 12*log2(estimation(i)/ref_freq);
           annotation_Midi(j) = 69 + 12*log2(annotation(i)/ref_freq);
           j = j+1;
       else
           false_negatives = false_negatives + 1;
       end
   else 
       if estimation(i) ~= 0 
           false_positives = false_positives + 1;
       end
   end
   i = i+1;
end

errCent = 100*(estimation_Midi-annotation_Midi);
errCent_rms = sqrt(sum(errCent.*errCent)/length(errCent));
%percent_Err = mean(abs(errCent)./annotation_Midi)
false_negatives = false_negatives*100/length(errCent);
false_positives = false_positives*100/(num_blocks - length(errCent));


figure;
plot(estimation_Midi,'r');
hold;
plot(annotation_Midi,'b');
hold off;
figure;
plot(errCent);

end