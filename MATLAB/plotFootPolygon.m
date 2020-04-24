function foot_poly = plotFootPolygon(billi, plot_poly)
%PLOTFOOTPOLYGON Summary of this function goes here
%   Detailed explanation goes here
feet = [billi.frontRight.endPoint billi.frontLeft.endPoint billi.backLeft.endPoint billi.backRight.endPoint];
foot_poly = [];
for i = 1:size(feet,2)
    if feet(3,i) <= 0
        foot_poly = [feet(:,i), foot_poly];
    end
end
if plot_poly
    figure(1);
    plot_t = [foot_poly, foot_poly(:,1)];
    hold on
    plot3(plot_t(1,:), plot_t(2,:), plot_t(3,:), 'r-.')
end
end

