syms t1 t2 length1 length2 point
eqns = rZ(t1)*T([length1;0;0])*rZ(t2)*[length2;0;0;1] - [point;0;0;1] == 0 ;
[solt1, ~] = solve(eqns, [t1 t2]);
theta1 = solt1(1);

% fprintf("length1_gv = %f,\t length2_gv = %f\n", length1, length2)
% fprintf("endPoint = [%.3f %.3f %.3f]\n", newEndPoint(1), newEndPoint(2), newEndPoint(3))
newPoint = rZ(theta1)*[length1;0;0;1]