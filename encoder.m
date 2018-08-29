function [out,B0,B1,B2,B3] = encoder(x)
%ADPCM Encoder.
% Args:
%   x: An audio file with the format as Microsoft WAVE ".wav".
%
% Returns:
%   out: A row matrix containing the quantified and encoded decimal stream transformed from the
%        encoded binary bit stream, with the ADPCM encoded.
%   B0: A row matrix containing the lowest order of each output(out) in binary format.
%   B1: A row matrix containing the second low order of each output(out) in binary format.
%   B2: A row matrix containing the second high order of each output(out) in binary format.
%   B3: A row matrix containing the highest order of each output(out) in binary format.
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
pre_data = 0;
B0=zeros(size(x));
B1=zeros(size(x)); 
B2=zeros(size(x)); 
B3=zeros(size(x));
% L=0;
out = zeros(size(x));

for i = 1:length(x),
    current_data = x(i);                % input current data
    diff = current_data - pre_data;     % calculate data-increment

    % Calculate the B3,B2,B1,B0 step by step following the References-1 as
    % follows:
    %     let B3 = B2 = B1 = B0 = 0 
    %     if (d(n) < 0)    
    %         then B3 = 1 
    %     d(n) = ABS(d(n)) 
    %     if (d(n) >= ss(n))    
    %         then B2 = 1 and d(n) = d(n) - ss(n) 
    %     if (d(n) >= ss(n) / 2)    
    %         then B1 = 1 and d(n) = d(n) - ss(n) / 2 
    %     if (d(n) >= ss(n) / 4)    
    %         then B0 = 1 L(n) = (10002 * B3) + (1002 * B2) + (102 * B1) + B0   
    if diff<0,
        diff = abs(diff); 
        B3(i) = 1; 
    end
    
    if diff < ss(index+1)/4,
        B2(i) = 0; B1(i) = 0; B0(i) = 0;
    elseif diff > ss(index+1)/4 && diff < ss(index+1)/2,
        B2(i) = 0; B1(i) = 0; B0(i) = 1;
    elseif diff > ss(index+1)/2 && diff < ss(index+1)*3/4,
        B2(i) = 0; B1(i) = 1; B0(i) = 0;
    elseif diff > ss(index+1)*3/4 && diff < ss(index+1),
        B2(i) = 0; B1(i) = 1; B0(i) = 1;
    elseif diff > ss(index+1) && diff < ss(index+1)*5/4,
        B2(i) = 1; B1(i) = 0; B0(i) = 0;
    elseif diff > ss(index+1)*5/4 && diff < ss(index+1)*3/2,
        B2(i) = 1; B1(i) = 0; B0(i) = 1;
    elseif diff > ss(index+1)*3/2 && diff < ss(index+1)*7/4,
        B2(i) = 1; B1(i) = 1; B0(i) = 0;
    elseif diff > ss(index+1)*7/4,
        B2(i) = 1; B1(i) = 1; B0(i) = 1;
    end

    L = 8*B3(i) + 4*B2(i) + 2*B1(i) + B0(i); % Convert the binary number "(B3B2B1B0)_2" to decimal number L as output
    out(i) = L;
    
    % Get the data-increment based on step_sizes_table and index
    diff = fix(ss(index+1)/8) + fix(B0(i)*ss(index+1)/4) + fix(B1(i)*ss(index+1)/2) + fix(B2(i)*ss(index+1));
    diff = (-1)^B3(i)*diff;
    pre_data = pre_data + diff; % Get the predicted data according to the data-increment
    
    index = index + Ml_values_table(4*B2(i) + 2*B1(i) + 1*B0(i) + 1);  % Convert the binary number "(B2B1B0)_2" to decimal number

    if (index<0),
        index=0;
    elseif (index>48),
        index=48;     % Limit the index in the range of step_sizes_table:(0,49)
    end
    
end
end