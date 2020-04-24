function R = Rx(theta)
%RZ Summary of this function goes here
%   Detailed explanation goes here
R = [1           0           0    0 ;
     0   cos(theta) -sin(theta)   0 ;
     0   sin(theta)  cos(theta)   0 ;
     0           0           0    1];
end

