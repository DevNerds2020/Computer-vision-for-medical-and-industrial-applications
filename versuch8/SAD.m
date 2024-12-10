function Sad_val = SAD(I_win1, I_win2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    Sad_val = sum(sum(abs(I_win1-I_win2)));


end

