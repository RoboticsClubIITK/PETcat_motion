classdef Body
    properties
        
        
        length;
        breadth;
        orient;%orientation matrix of billi,position of com and angular orientation,4x4
    end
    methods
    function obj = Body(l,b,orient)
        obj.length=l;
        obj.breadth=b;
        obj.orient=orient;
    end
    end
end