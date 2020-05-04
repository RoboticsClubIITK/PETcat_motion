clear; clc;close all;
h = figure('Position', [10 10 1000 1000]);

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
moti_billi = moti_billi.update( [5*1.414*cos(-pi/4) ; 5*1.414*sin(-pi/4) ; -com(3)] + com,...        % location of fr.endPoint
                                [5*1.414*cos(pi/4)  ; 5*1.414*sin(pi/4)  ; -com(3)] + com,...        % location of fl.endPoint
                                [-5*1.414*cos(pi/4) ; -5*1.414*sin(pi/4) ; -com(3)] + com,...        % location of br.endPoint
                                [-5*1.414*cos(-pi/4); -5*1.414*sin(-pi/4); -com(3)] + com,...        % location of bl.endPoint
                                com,...                                                              % location of CoM
                                0);                                                                  % heading angle of quadruped
plotBody(moti_billi, h, false);
bounding_poly = plotFootPolygon(moti_billi, true);
%%rotation specs
step_angle=pi/12;
angle=step_angle;
num_steps = 4;%%replace it with the "desired_turning_angle/step_angle"
%%applying cycloid trajectory to legs%%
for i = 1:num_steps
meow=moti_billi.rotate(step_angle);
init_feet = [moti_billi.frontRight.endPoint, moti_billi.frontLeft.endPoint, moti_billi.backRight.endPoint, moti_billi.backLeft.endPoint]; 
final_feet = [meow.frontRight.endPoint, meow.frontLeft.endPoint, meow.backRight.endPoint, meow.backLeft.endPoint]; %%updated position of cat
dist_frbl = sqrt((final_feet(1,1)-init_feet(1,1))^2 + (final_feet(2,1)-init_feet(2,1))^2);%%distance to be moved by front right and back left legs
dir_frbl = [(final_feet(1,1)-init_feet(1,1)) (final_feet(2,1)-init_feet(2,1)) ]./dist_frbl;%%direction unit vector from prev. position of front right foot to current positon 
dist_flbr = sqrt((final_feet(1,2)-init_feet(1,2))^2 + (final_feet(2,2)-init_feet(2,2))^2);%%distance to be moved by front left and back right legs
dir_flbr = [(final_feet(1,2)-init_feet(1,2)) (final_feet(2,2)-init_feet(2,2)) ]./dist_flbr;%%direction unit vector from prev. position of front left foot to current positon 
%%
%% define step specs
stepLength = dist_frbl; % max range of foot for front right and back left

%% define walk parameters
t_step = 1;     % 1 second for 1 footstep

num_its = 20;   % no of substeps in one footstep
c_step = t_step/num_its;


%% describing walk motion

    % first half
    init_feet = [moti_billi.frontRight.endPoint, moti_billi.frontLeft.endPoint, moti_billi.backRight.endPoint, moti_billi.backLeft.endPoint]; 
    init_com = moti_billi.com;
    for t = linspace(0, t_step, num_its)

        x_foot = (stepLength/pi)*0.5*(t/t_step*2*pi - sin(t/t_step*2*pi))*dir_frbl(1);
        y_foot = (stepLength/pi)*0.5*(t/t_step*2*pi - sin(t/t_step*2*pi))*dir_frbl(2);
        z_foot = 0.5*(1 - cos(t/t_step*2*pi));
        
        moti_billi = moti_billi.update( init_feet(:,1) + [x_foot;y_foot; z_foot],... % location of fr.endPoint
                                        init_feet(:,2),...                            % location of fl.endPoint
                                        init_feet(:,3),...                            % location of br.endPoint
                                        init_feet(:,4) + [-x_foot; -y_foot; z_foot],... % location of bl.endPoint
                                        init_com,...                                     % location of CoM
                                        angle);
        
        plotBody(moti_billi, h, false);
        bounding_poly = plotFootPolygon(moti_billi, true);
        pause(c_step);
    end
    %%second half
    stepLength=dist_flbr;%%for front left and baack right
    init_feet = [moti_billi.frontRight.endPoint, moti_billi.frontLeft.endPoint, moti_billi.backRight.endPoint, moti_billi.backLeft.endPoint]; 
    init_com = moti_billi.com;
    for t = linspace(0, t_step, num_its)

        x_foot = (stepLength/pi)*0.5*(t/t_step*2*pi - sin(t/t_step*2*pi))*dir_flbr(1);
        y_foot = (stepLength/pi)*0.5*(t/t_step*2*pi - sin(t/t_step*2*pi))*dir_flbr(2);
        z_foot = 0.5*(1 - cos(t/t_step*2*pi));
        
        moti_billi = moti_billi.update( init_feet(:,1),...                            % location of fr.endPoint
                                        init_feet(:,2) + [x_foot; y_foot; z_foot],... % location of fl.endPoint
                                        init_feet(:,3) + [-x_foot; -y_foot; z_foot],... % location of br.endPoint
                                        init_feet(:,4),...                            % location of bl.endPoint
                                        init_com, ...                                    % location of CoM
                                        angle);
        plotBody(moti_billi, h, false);
        bounding_poly = plotFootPolygon(moti_billi, true);
        pause(c_step);
    end
    angle= angle+step_angle;%%orientation angle for billi in next loop
end
