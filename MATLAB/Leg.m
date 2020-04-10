classdef Leg
    
    
    
    properties
        startPoint;
        l1;
        joint;
        l2;
        endPoint;
    end
    methods
        function obj=Leg(s,e,l1,l2)
            obj.startPoint=s;
            obj.endPoint=e;
            obj.l1=l1;
            obj.l2=l2;
            
        end
    end
end