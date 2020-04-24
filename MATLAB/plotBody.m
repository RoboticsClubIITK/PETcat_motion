function [] = plotBody(billi, h ,detailed)
%PLOTBODY Summary of this function goes here
%   Detailed explanation goes here

    CoM =   billi.com;

    b  =    [billi.frontLeft.startPoint, billi.backLeft.startPoint, billi.backRight.startPoint, billi.frontRight.startPoint, billi.frontLeft.startPoint, (billi.frontRight.startPoint + billi.frontLeft.startPoint)/2];

    fr =    [billi.frontRight.startPoint(1:3), billi.frontRight.joint, billi.frontRight.endPoint(1:3)];

    fl =    [billi.frontLeft.startPoint(1:3), billi.frontLeft.joint, billi.frontLeft.endPoint(1:3)];

    br =    [billi.backRight.startPoint(1:3), billi.backRight.joint, billi.backRight.endPoint(1:3)];

    bl =    [billi.backLeft.startPoint(1:3), billi.backLeft.joint, billi.backLeft.endPoint(1:3)];
    
    if detailed == true
        figure(h);
        subplot(2,2,1)
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
            view([-10 5 5])
        subplot(2,2,2)
            hold off;
            plotPoints(fr);
            hold on;
            plotPoints(fl);
            plotPoints(br);
            plotPoints(bl);
            plotPoints(b);
            plotPoints(CoM);
            plotPoints([CoM(1); CoM(2); 0]);
            title('Top View');
            axis([-10 + CoM(1), 10 + CoM(1), -10, 10, 0 , 10])
            grid on 
            pbaspect([2 2 1])
            view([0 0 8])
        subplot(2,2,3)
            hold off;
            plotPoints(fr);
            hold on;
            plotPoints(fl);
            plotPoints(br);
            plotPoints(bl);
            plotPoints(b);
            plotPoints(CoM);
            plotPoints([CoM(1); CoM(2); 0]);
            title('Side View');
            axis([-10 + CoM(1), 10 + CoM(1), -10, 10, 0 , 10])
            grid on 
            pbaspect([2 2 1])
            view([0 8 0])
        subplot(2,2,4)
            hold off;
            plotPoints(fr);
            hold on;
            plotPoints(fl);
            plotPoints(br);
            plotPoints(bl);
            plotPoints(b);
            plotPoints(CoM);
            plotPoints([CoM(1); CoM(2); 0]);
            title('Front View');
            axis([-10 + CoM(1), 10 + CoM(1), -10, 10, 0 , 10])
            grid on 
            pbaspect([2 2 1])
            view([8 0 0])
    else
        figure(h);
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
            view([-10 5 5])
    end
end

