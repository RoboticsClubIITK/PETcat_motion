function newPoint = findPoint(newEndPoint, length1, length2, angle)
			% gives location of joint point wrt rotated startPoint coordinates

			% trY minimising the use of solve function - in this case use it once in
			% the command window and then copy the equation for theta1 and then use
			% that - reduces computational power required
			newEndPoint(1:2) = 0;
            
            syms t1 t2
			eqns = rY(t1)*T([length1;0;0])*rY(t2)*[length2;0;0;1] - newEndPoint == 0 ;
			[solt1, ~] = solve(eqns, [t1 t2]);
			theta1 = double(solt1(1));

			% fprintf("length1_gv = %f,\t length2_gv = %f\n", length1, length2)
			% fprintf("endPoint = [%.3f %.3f %.3f]\n", newEndPoint(1), newEndPoint(2), newEndPoint(3))
			newPoint = rZ(angle)*rY(theta1)*[length1;0;0;1];
			% fprintf("length1_before = %f,\t length2_before = %f\n", norm(newPoint(1:3)), norm(newEndPoint - newPoint))
        end