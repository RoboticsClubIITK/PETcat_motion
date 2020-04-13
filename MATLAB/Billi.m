====%All points are homogenized,i.e,extra 1 is appended after z coordinate
	classdef Billi
	properties
		
		
		frontRight;
		frontLeft;
		backRight;
		backLeft;
		body;
	end
	methods
		function obj= Billi(body_obj,l1,l2)%body frame and length of links
			obj.body=body_obj;
			height=obj.body.orient(3,4);%z-coordinate of body
			l=obj.body.length;
			b=obj.body.breadth;
			obj.frontRight=Leg(obj.body.orient*[l/2;-b/2;0;1],obj.body.orient*[l/2;-b/2;-height;1],l1,l2);
			obj.frontLeft=Leg(obj.body.orient*[l/2;b/2;0;1],obj.body.orient*[l/2;b/2;-height;1],l1,l2);
			obj.backRight=Leg(obj.body.orient*[-l/2;-b/2;0;1],obj.body.orient*[-l/2;-b/2;-height;1],l1,l2);
			obj.backLeft=Leg(obj.body.orient*[-l/2;b/2;0;1],obj.body.orient*[-l/2;b/2;-height;1],l1,l2);
		end
		function [obj] = translate(obj,dist)%signed distance along billi x-axis
			obj.body.orient = obj.body.orient*[1 0 0 dist;0 1 0 0;0 0 1 0;0 0 0 1];
			
			l=obj.body.length;
			b=obj.body.breadth;
			obj.frontRight.startPoint=obj.body.orient*[l/2;-b/2;0;1];  
			obj.frontLeft.startPoint= obj.body.orient*[l/2;b/2;0;1];
			obj.backRight.startPoint= obj.body.orient*[-l/2;-b/2;0;1];
			obj.backLeft.startPoint= obj.body.orient*[-l/2;b/2;0;1];
										
		end
		function [obj] = rotate(obj,angle)%rotate billi by given angle(in radians) about z-axis
			obj.body.orient =obj.body.orient*    [cos(angle) -sin(angle) 0 0;
							      sin(angle) cos(angle)  0 0;
							      0          0           1 0;
							      0          0           0 1];
						
			l=obj.body.length;
			b=obj.body.breadth;
			obj.frontRight.startPoint=obj.body.orient*[l/2;-b/2;0;1];
			obj.frontLeft.startPoint= obj.body.orient*[l/2;b/2;0;1];
			obj.backRight.startPoint= obj.body.orient*[-l/2;-b/2;0;1];
			obj.backLeft.startPoint= obj.body.orient*[-l/2;b/2;0;1];                       
		end
		function jointPoint = legPoseRotation( endPoint , startPoint , length1, length2 , angle)

			thetaX = atan2(endPoint(2), endPoint(1));
			endPoint_st = T(startPoint)\[endPoint;1]; % making startpoint the origin 
			endPoint_st = rX(thetaX)\endPoint_st; % rotating along X axis to get endpoint and startpoint in one plane (converting to 2D problem)

			thetaY = atan(endPoint_st(1)/ endPoint_st(3));
			endPoint_st = rY(thetaY)\endPoint_st; % rotating along Y axis to get endpoint and startpoint in one line
			endPoint_st(1) = 0; % setting offset error to zero

			jointPoint = findPoint(endPoint_st, length1, length2, angle);
			% fprintf("1st it: norm(jointPoint) = %.3f\n", norm(jointPoint(1:3)))
			jointPoint = T(startPoint)*rX(thetaX)*rY(thetaY)*jointPoint;
			% fprintf("2nd it: norm(jointPoint) = %.3f\n", norm(jointPoint - [startPoint;1]))
			jointPoint = jointPoint(1:3);
			% fprintf("3rd it: norm(jointPoint) = %.3f\n", norm(jointPoint - startPoint))
		end

		function newPoint = findPoint(newEndPoint, length1, length2, angle)
			% gives location of joint point wrt rotated startPoint coordinates

			% try minimising the use of solve function - in this case use it once in
			% the command window and then copy the equation for theta1 and then use
			% that - reduces computational power required
			syms t1 t2
			eqns = [rZ(angle)*rY(t1)*T([length1;0;0])*rY(t2)*[length2;0;0;1] - [newEndPoint(1);newEndPoint(2);newEndPoint(3);1] == 0 ];
			[solt1, solt2] = solve(eqns, [t1 t2]);
			theta1 = double(solt1(1));

			% fprintf("length1_gv = %f,\t length2_gv = %f\n", length1, length2)
			% fprintf("endPoint = [%.3f %.3f %.3f]\n", newEndPoint(1), newEndPoint(2), newEndPoint(3))
			newPoint = rZ(angle)*rY(theta1)*[length1;0;0;1];
			% fprintf("length1_before = %f,\t length2_before = %f\n", norm(newPoint(1:3)), norm(newEndPoint - newPoint))
		end

		function [transformationMatrix] = T(origin)

			transformationMatrix = [1   0   0   origin(1) ;
						0   1   0   origin(2) ;
						0   0   1   origin(3) ;
						0   0   0          1 ];
			

		end

		function [transformationMatrix] = rY(theta)

			transformationMatrix = [cos(theta)   0    sin(theta)      0    ;
						0            1        0           0    ;
						-sin(theta)  0    cos(theta)      0    ;
						0            0        0           1   ];
			

		end
		function [transformationMatrix] = rX( theta)

			transformationMatrix = [1           0            0     0 ;
						0   cos(theta)  -sin(theta)    0 ;
						0   sin(theta)   cos(theta)    0 ;
						0           0            0     1];
					
		end
		function [transformationMatrix] = rZ( theta)

			transformationMatrix = [cos(theta)  -sin(theta)  0    0  ;
						sin(theta)   cos(theta)  0    0  ;
						0            0       1    0  ;
						0            0       0    1 ];
			
		end
	end
end
