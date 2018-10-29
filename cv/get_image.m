function im = get_image(expTime)
%GET_IMAGE Get image from a XIMEA attached camera. Get a
% single image from it saved to variable "im".

vid = videoinput('gentl', 1, 'BGRA8Packed');
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;

triggerconfig(vid, 'manual');
triggerconfig(vid, 'immediate');

src.ExposureTime = expTime;
% src.WhiteBalanceBlue = 1;
% src.WhiteBalanceGreen = 1;
% src.WhiteBalanceRed = 1;
src.BalanceWhiteAuto = 'Continuous';
start(vid);

im = getdata(vid);
% imshow(im)
%% TODO
% Do image processing (top down transform, undistorted, imbinarize,
% iblobs to identify objects and their centroid+area, do motion planning
% then finally convert config space (in pixels) to IK pose angles
