%All points are homogenized,i.e,extra 1 is appended after z coordinate
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
    end
end