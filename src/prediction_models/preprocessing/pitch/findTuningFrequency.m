%Tuning frequency detection for the student recordings
%Input is the pitch contour
%Output is the tuning frequency (in cents) for adjusting the pitch and a special case indicator
%if the tuning is around 50 cents (sc)
function [tf,sc] = findTuningFrequency(f0)

wav_pitch_contour_in_midi = 69+12*log2(f0/440);
wav_pitch_contour_in_midi(wav_pitch_contour_in_midi == -Inf) = 0;

%remove leading and trailing zeros
a = find(wav_pitch_contour_in_midi ~= 0);
wav_pitch_contour_in_midi = wav_pitch_contour_in_midi(a(1):a(end));
wav_pitch_contour_in_midi(wav_pitch_contour_in_midi == 0) = [];

wav_dev = mod(wav_pitch_contour_in_midi,1);
wav_dev = wav_dev*100;

I = mode(wav_dev);
sc = 0;
if(45< I && I <55)
    sc = 1;
end
if I>50
    I = I-100;
end

tf = I;


