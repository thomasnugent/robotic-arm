function [t1, t2] = ik2(x, y, L1, L2)
% Inverse Kinematics for a 2R arms
% Returns a real solution if it exists, or returns imaginary numbers
% otherwise
% Always returns the elbow down solution, where possible
% See Lecture 3 for info on how this is implemented
ct2 = (x^2+y^2-L1^2-L2^2)/2*L1*L2;
if abs(ct2) > 1
    t1 = 1i;
    t2 = 1i;
else
    t2 = acos(ct2); st2 = sin(t2);
    ct1 = x*(L1+L2*ct2) + y*L2*st2; % cos theta 1 ratio
    st1 = -x*L2*st2+y*(L1+L2*ct2);
    t1 = abs(atan2(st1 , ct2));
end