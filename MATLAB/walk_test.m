clear; clc;close all;
%% define billi specs
link1 = 3;      % linkLength1 
link2 = 4;      % linkLength2

length = 10;    % length of body
width  = 8;     % width of body

orientation_matrix = [1 0 0 0 ; 0 1 0 0; 0 0 1 0; 0 0 0 1];     % orientation of body
body_obj = Body(length ,width , orientation_matrix);            % declare body object

moti_billi = Billi(body_obj,link1,link2);                       % declare Billi object

% initial pose of quad
com = [0; 0; 6];
moti_billi = moti_billi.update( [5*1.414*cos(-pi/4) ; 5*1.414*sin(-pi/4) ; -6] + com,...        % location of fr.endPoint
                                [5*1.414*cos(pi/4)  ; 5*1.414*sin(pi/4)  ; -6] + com,...        % location of fl.endPoint
                                [-5*1.414*cos(pi/4) ; -5*1.414*sin(pi/4) ; -6] + com,...        % location of br.endPoint
                                [-5*1.414*cos(-pi/4); -5*1.414*sin(-pi/4); -6] + com,...        % location of bl.endPoint
                                com,...                                                         % location of CoM
                                0);                                                             % heading angle of quadruped
plotBody(moti_billi, com);
plotFootPolygon(moti_billi, true);

%% define step specs
stepLength = 3; % max range of foot
stepHeight = 1; % max height attained by foot while in motion 
poly = CubicSpline(stepHeight, stepLength);

%% define walk parameters
t_step = 1;     % 1 second for 1 footstep
num_steps = 2;
num_its = 10;   % no of substeps in one footstep
c_step = t_step/num_its;

%% describing walk motion

for i = 1:num_steps
    % first half
    init_feet = [moti_billi.frontRight.endPoint, moti_billi.frontLeft.endPoint, moti_billi.backRight.endPoint, moti_billi.backLeft.endPoint]; 
    init_com = moti_billi.com;
    for t = linspace(0, t_step, num_its)
        x_foot = (t/t_step)*stepLength;
        y_foot = 0;
        z_foot = subs(poly);
        
        x_com = x_foot/2;
        y_com = (moti_billi.body.breadth/moti_billi.body.length)*x_com;
        z_com = 0;
        
        moti_billi = moti_billi.update( init_feet(:,1) + [x_foot; y_foot; z_foot],... % location of fr.endPoint
                                        init_feet(:,2),...                            % location of fl.endPoint
                                        init_feet(:,3),...                            % location of br.endPoint
                                        init_feet(:,4) + [x_foot; y_foot; z_foot],... % location of bl.endPoint
                                        init_com + [x_com; y_com; z_com],...          % location of CoM
                                        0);
        plotBody(moti_billi, init_com + [x_com; y_com; z_com]);
        bounding_poly = plotFootPolygon(moti_billi, true);
        pause(c_step);
    end
    
    % second half
    init_feet = [moti_billi.frontRight.endPoint, moti_billi.frontLeft.endPoint, moti_billi.backRight.endPoint, moti_billi.backLeft.endPoint]; 
    init_com = moti_billi.com;
    for t = linspace(0, t_step, num_its)
        x_foot = (t/t_step)*stepLength;
        y_foot = 0;
        z_foot = subs(poly);
        
        x_com = x_foot/2;
        y_com = -(moti_billi.body.breadth/moti_billi.body.length)*x_com;
        z_com = 0;
        
        moti_billi = moti_billi.update( init_feet(:,1),...                            % location of fr.endPoint
                                        init_feet(:,2) + [x_foot; y_foot; z_foot],... % location of fl.endPoint
                                        init_feet(:,3) + [x_foot; y_foot; z_foot],... % location of br.endPoint
                                        init_feet(:,4),...                            % location of bl.endPoint
                                        init_com + [x_com; y_com; z_com],...          % location of CoM
                                        0);
        plotBody(moti_billi, init_com + [x_com; y_com; z_com]);
        bounding_poly = plotFootPolygon(moti_billi, true);
        pause(c_step);
    end
end