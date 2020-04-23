function [hip, knee, foot] = findleg(footP, hipP, l1, l2, angle)
%FINDLEG SummarY of this function goes here
%   Detailed explanation goes here
hip = [hipP;1];
foot = [footP;1];
knee = 0;

foot_n = T(hip)\foot;                       % shift origin to hip

thetaX = atan2(foot_n(3), foot_n(2));       % rotate such that foot_n's z-coordinate = 0
foot_n = rX(thetaX)\foot_n;

thetaZ = atan2(foot_n(2), foot_n(1));       % rotate to align foot_n with x-axis
foot_n = rZ(thetaZ)\foot_n;

knee = findPoint(foot_n, l1, l2, angle);    % coordinates of knee in rotated and translated frame

knee = T(hip)*rX(thetaX)*rZ(thetaZ)*knee;   % converting to world frame

knee = knee(1:3);
foot = foot(1:3);
hip  = hip (1:3);
end

