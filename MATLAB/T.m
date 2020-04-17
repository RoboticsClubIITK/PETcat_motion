function R = T(origin)
%RZ Summary of this function goes here
%   Detailed explanation goes here
R = [1   0   0   origin(1) ;
     0   1   0   origin(2) ;
     0   0   1   origin(3) ;
     0   0   0          1 ];
end

