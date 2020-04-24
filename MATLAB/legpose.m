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

for i = linspace(0, 2*pi, 1)
    com = [i; 0; 6];
    myObj= myObj.update([5*1.414*cos(-pi/4 + i); 5*1.414*sin(-pi/4 + i); -5] + com,...     % location of fr.endPoint
                        [5*1.414*cos(pi/4 + i); 5*1.414*sin(pi/4 + i); -6] + com,...       % location of fl.endPoint
                        [-5*1.414*cos(pi/4 + i); -5*1.414*sin(pi/4 + i); -6] + com,...     % location of br.endPoint
                        [-5*1.414*cos(-pi/4 + i); -5*1.414*sin(-pi/4 + i); -6] + com,...   % location of bl.endPoint
                        com,...                                               % location of CoM
                        i);                                                         % heading angle of quadruped

    plotBody(myObj, com);
    poly = plotFootPolygon(myObj, true);        % PLots the foot polygon (polygon connecting feet on ground)
    pause(0.01)
end