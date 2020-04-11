orient=[cos(0.2) -sin(0.2) 0 6;
       sin(0.2) cos(0.2)  0 4;
       0          0           1 10;
       0          0           0 1];
body=Body(4,4,orient);
l1=3;
l2=4;

meow=Billi(body,l1,l2);
hold on;
%plot(meow.body.orient(1,4),meow.body.orient(2,4),'rs');
%pbaspect([1,1,1]);
for i= (1:50)
    plot3([meow.frontLeft.endPoint(1)],[meow.frontLeft.endPoint(2)],[meow.frontLeft.endPoint(3)],'ro');
    plot3([meow.frontLeft.startPoint(1) meow.frontRight.startPoint(1) meow.backRight.startPoint(1) meow.backLeft.startPoint(1)],[meow.frontLeft.startPoint(2) meow.frontRight.startPoint(2) meow.backRight.startPoint(2) meow.backLeft.startPoint(2)],[meow.frontLeft.startPoint(3) meow.frontRight.startPoint(3) meow.backRight.startPoint(3) meow.backLeft.startPoint(3)],'ro');
    plot3(meow.body.orient(1,4),meow.body.orient(2,4),meow.body.orient(3,4),'rs');
    meow=translate(meow,1);
    if i==10||i==20||i==30||i==40||i==50
    meow=rotate(meow,pi/2);
    end
    pause(0.1);
end

