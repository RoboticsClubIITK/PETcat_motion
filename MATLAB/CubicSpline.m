function a = polynomial(stepHeight, stepLength)
%POLYNOMIAL Provides foot polynomial with provided specs
%   Detailed ex_footplanation goes here
a = [(27*stepHeight)/(4*stepLength^3), -(27*stepHeight)/(2*stepLength^2), (27*stepHeight)/(4*stepLength), 0];
    
end

