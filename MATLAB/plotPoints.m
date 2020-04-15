function [x, y, z] = plotPoints(A)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [~, len] = size(A);
    x = [];
    y = [];
    z = [];
    for i = 1:len
        x = [x; A(1,i)];
        y = [y; A(2,i)];
        z = [z; A(3,i)];
    end
    plot3(x, y, z, 'k-o')
    grid on 
    axis([-10 10 -10 10 0 10])
    pbaspect([2 2 1])
    view([10 10 10])
end

