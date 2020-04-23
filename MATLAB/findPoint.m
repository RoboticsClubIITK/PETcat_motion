function newPoint = findPoint(newEndPoint, length1, length2, angle)
			% gives location of joint newEndPoint(3) wrt rotated startPoint coordinates

			% trY minimising the use of solve function - in this case use it once in
			% the command window and then copy the equation for theta1 and then use
			% that - reduces computational power required

            % fprintf("length1_gv = %f,\t length2_gv = %f\n", length1, length2)
			% fprintf("endPoint = [%.3f %.3f %.3f]\n", newEndPoint(1), newEndPoint(2), newEndPoint(3))
			newPoint = rX(angle)* [length1*cos(2*atan(((length2*(length1 + length2 + newEndPoint(1))^2*(((length1 + length2 - newEndPoint(1))*(length2 - length1 + newEndPoint(1)))/((length1 - length2 + newEndPoint(1))*(length1 + length2 + newEndPoint(1))^3))^(1/2))/(length2 - length1 + newEndPoint(1)) - (length1*(length1 + length2 + newEndPoint(1))^2*(((length1 + length2 - newEndPoint(1))*(length2 - length1 + newEndPoint(1)))/((length1 - length2 + newEndPoint(1))*(length1 + length2 + newEndPoint(1))^3))^(1/2))/(length2 - length1 + newEndPoint(1)) + (newEndPoint(1)*(length1 + length2 + newEndPoint(1))^2*(((length1 + length2 - newEndPoint(1))*(length2 - length1 + newEndPoint(1)))/((length1 - length2 + newEndPoint(1))*(length1 + length2 + newEndPoint(1))^3))^(1/2))/(length2 - length1 + newEndPoint(1)))/(length1 + length2 + newEndPoint(1))));
                                   length1*sin(2*atan(((length2*(length1 + length2 + newEndPoint(1))^2*(((length1 + length2 - newEndPoint(1))*(length2 - length1 + newEndPoint(1)))/((length1 - length2 + newEndPoint(1))*(length1 + length2 + newEndPoint(1))^3))^(1/2))/(length2 - length1 + newEndPoint(1)) - (length1*(length1 + length2 + newEndPoint(1))^2*(((length1 + length2 - newEndPoint(1))*(length2 - length1 + newEndPoint(1)))/((length1 - length2 + newEndPoint(1))*(length1 + length2 + newEndPoint(1))^3))^(1/2))/(length2 - length1 + newEndPoint(1)) + (newEndPoint(1)*(length1 + length2 + newEndPoint(1))^2*(((length1 + length2 - newEndPoint(1))*(length2 - length1 + newEndPoint(1)))/((length1 - length2 + newEndPoint(1))*(length1 + length2 + newEndPoint(1))^3))^(1/2))/(length2 - length1 + newEndPoint(1)))/(length1 + length2 + newEndPoint(1))));
                                   0;
                                   1];

			% fprintf("length1_before = %f,\t length2_before = %f\n", norm(newPoint(1:3)), norm(newEndPoint - newPoint))
        end