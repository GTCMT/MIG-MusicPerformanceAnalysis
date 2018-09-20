function [H,out] = PreFilter(input,fs)

b1 = [1.53512485958697,-2.69169618940638,1.19839281085285];
a1 = [1,-1.69065929318241,0.73248077421585];

b2 = [1,-2,1];
a2 = [1,-1.99004745483398,0.99007225036621];

H1 = freqz(b1,a1,fs*0.4);
H2 = freqz(b2,a2,fs*0.4);


H = H1.*H2;



out = filter(b1,a1,input);
out = filter(b2,a2,out);

end

