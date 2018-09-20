clear all;
clc;
close all;

%source for melfcc: http://www.ee.columbia.edu/~dpwe/resources/matlab/rastamat/
fidlist=fopen('C:\Users\rmuser\Desktop\MFCC\HCT_All_forMFCCs_original.txt')
hop=0.01; % hop in s
frm=0.03; % frm in s

    
   path=fgetl(fidlist);
   
for ct=1:180
    clc;display('Current Clip')
    ct
    clear data;
    clear fs;
    
[data fs]=wavread(strcat(path,fgetl(fidlist)));
    fsval(ct)=fs;
szd=size(data);
if(szd(2)>1)
    data=data(:,1);
end

coeff=melfcc(data,fs, 'maxfreq', 8000, 'numcep', 13, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime',frm, 'hoptime', hop, 'preemph', 0, 'dither', 1);

  mfcc_feat_means(ct,:)= mean(coeff');
  mfcc_feat_variances(ct,:)=var(coeff');
end




% 
% for i=1:180
% if(i<=60)
% plot(mfcc_feat_means(i,:))
% hold on;
% elseif(i>60&&i<=120)
% plot(mfcc_feat_means(i,:),'r')
% hold on;
% else
% plot(mfcc_feat_means(i,:),'g')
% hold on;
% end
% end
