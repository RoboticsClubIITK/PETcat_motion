startPoint = [10 ; 5 ; 0];
endPoint = [5 ; 5 ;0];
angle = pi/2;
length1 = 3;
length2 = 4;
hold off

orientation_matrix = [1 0 0 0 ; 0 1 0 0; 0 0 1 0; 0 0 0 1];
body_obj = Body(10 , 8 , orientation_matrix);

myObj= Billi(body_obj,length1,length2);
myObj= myObj.update([5; 5; 0],[5; -5; 0],[-5; 5; 0],[-5; -5; 0],[0; 0; 6],0);

for i = linspace(0, 2*pi, 30)
    myObj= myObj.update([5*1.414*cos(-pi/4 + i); 5*1.414*sin(-pi/4 + i); 0],[5*1.414*cos(pi/4 + i); 5*1.414*sin(pi/4 + i); 0],[-5*1.414*cos(pi/4 + i); -5*1.414*sin(pi/4 + i); 0],[-5*1.414*cos(-pi/4 + i); -5*1.414*sin(-pi/4 + i); 0],[0; 0; 6],i);

    b =     [myObj.frontLeft.startPoint, myObj.backLeft.startPoint, myObj.backRight.startPoint, myObj.frontRight.startPoint, myObj.frontLeft.startPoint, (myObj.frontRight.startPoint + myObj.frontLeft.startPoint)/2];

    fr =    [myObj.frontRight.startPoint(1:3), myObj.frontRight.joint, myObj.frontRight.endPoint(1:3)];

    fl =    [myObj.frontLeft.startPoint(1:3), myObj.frontLeft.joint, myObj.frontLeft.endPoint(1:3)];

    br =    [myObj.backRight.startPoint(1:3), myObj.backRight.joint, myObj.backRight.endPoint(1:3)];

    bl =    [myObj.backLeft.startPoint(1:3), myObj.backLeft.joint, myObj.backLeft.endPoint(1:3)];
         
    hold off;
    plotPoints(fr);
    hold on;
    plotPoints(fl);
    plotPoints(br);
    plotPoints(bl);
    plotPoints(b);
    
    pause(0.01)
end