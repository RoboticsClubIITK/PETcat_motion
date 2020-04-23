function a = trackFeet(billi)
%TRACKFEET Summary of this function goes here
%   Detailed explanation goes here
    trackfoot(billi.frontLeft.endPoint);
    trackfoot(billi.frontRight.endPoint);
    trackfoot(billi.backLeft.endPoint);
    trackfoot(billi.backRight.endPoint);
    
    axis([-10 + billi.com(1), 10 + billi.com(1), -10, 10, 0 , 10])
    grid on 
    pbaspect([2 2 1])
    view([-10 1 2])
end

