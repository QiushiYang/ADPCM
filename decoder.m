function [out] = decoder(x,B0,B1,B2,B3)
%ADPCM Decoder.
% Args:
%   x: An audio file with the format as Microsoft WAVE ".wav".
%   B0: A row matrix containing the lowest order of each output(out) in binary format.
%   B1: A row matrix containing the second low order of each output(out) in binary format.
%   B2: A row matrix containing the second high order of each output(out) in binary format.
%   B3: A row matrix containing the highest order of each output(out) in binary format.
%
%Returns:
%   out: A row matrix containing the decimal stream decoded from the quantified and encoded 
%        stream, with the ADPCM decoded.     
%
%References:
%   1.http://www.cs.columbia.edu/~hgs/audio/dvi/IMA_ADPCM.pdf 
%   2.https://en.wikipedia.org/wiki/Adaptive_differential_pulse-code_modulation 
%
%Finished by Qiushi Yang, 6/12/2018.

Ml_values_table = [-1,-1,-1,-1,2,4,6,8];
step_sizes_table = [16,17,19,21,23,25,28,31,34,37,41,45,50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552];
ss = step_sizes_table;

% Initialization 
index = 0;
current_sample = 0;
out = zeros(size(x));

for i = 1:length(x),
    % Calculate the B3,B2,B1,B0 step by step following the References-1 as
    % follows:
    % d(n) = (ss(n)*B2)+(ss(n)/2*B1)+(ss(n)/4*BO)+(ss(n)/8) 
    % if (B3 = 1)    
    %     then d(n) = d(n) * (-1) 
    % X(n) = X(n-1) + d(n)
    diff = fix(ss(index+1)/8) + fix(B0(i)*ss(index+1)/4) + fix(B1(i)*ss(index+1)/2) + fix(B2(i)*ss(index+1));
    if B3(i) == 1,
        diff = -diff;
    end
   
    current_sample = current_sample + diff;  % Get the current_sample from the data-increment
    % Limit current_sample in the range:(-2^15,2^15) because of the
    % representation ability of float-type 
    if current_sample>32767,
        output = 32767;
    elseif current_sample<-32768, 
        output = -32768;
    else
        output = current_sample;
    end
    
    out(i) = output;
    
    index = index + Ml_values_table(4*B2(i) + 2*B1(i) + 1*B0(i) + 1); % Convert the binary number "(B2B1B0)_2" to decimal number
    if (index<0),
        index=0;             
    elseif (index>48),
        index=48;       % Limit the index in the range of step_sizes_table:(0,49)
    end

end

end