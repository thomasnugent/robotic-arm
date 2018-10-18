function [poses] = get_inverse_kinematics(link1Length, link2Length, x, y)

beth = make_robot(link1Length, link2Length);

r = eye(3);
t = [x; y; 1];
tr = rt2tr(r, t);
ik = beth.ikine(tr, 'mask', [ 1 1 0 0 0 0]);

poses = ik;
beth.animate([-link1Length, -link2Length; x, y]);
beth.plot([-link1Length, -link2Length; x, y]);
end