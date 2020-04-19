function [] = plotBody(billi, CoM)
%PLOTBODY Summary of this function goes here
%   Detailed explanation goes here
    b =     [billi.frontLeft.startPoint, billi.backLeft.startPoint, billi.backRight.startPoint, billi.frontRight.startPoint, billi.frontLeft.startPoint, (billi.frontRight.startPoint + billi.frontLeft.startPoint)/2];

    fr =    [billi.frontRight.startPoint(1:3), billi.frontRight.joint, billi.frontRight.endPoint(1:3)];

    fl =    [billi.frontLeft.startPoint(1:3), billi.frontLeft.joint, billi.frontLeft.endPoint(1:3)];

    br =    [billi.backRight.startPoint(1:3), billi.backRight.joint, billi.backRight.endPoint(1:3)];

    bl =    [billi.backLeft.startPoint(1:3), billi.backLeft.joint, billi.backLeft.endPoint(1:3)];
         
    hold off;
    plotPoints(fr);
    hold on;
    plotPoints(fl);
    plotPoints(br);
    plotPoints(bl);
    plotPoints(b);
    plotPoints(CoM);
    plotPoints([CoM(1); CoM(2); 0]);
    axis([-10 + CoM(1), 10 + CoM(1), -10, 10, 0 , 10])
    grid on 
    pbaspect([2 2 1])
    view([-10 1 2])
end

