function a = polynomial(stepHeight, stepLength)
%POLYNOMIAL Provides foot polynomial with provided specs
%   Detailed ex_footplanation goes here
syms x_foot
a = (27*stepHeight)/(4*stepLength^3)*x_foot^3 + -(27*stepHeight)/(2*stepLength^2)*x_foot^2 + (27*stepHeight)/(4*stepLength)*x_foot + 0;
    
end

