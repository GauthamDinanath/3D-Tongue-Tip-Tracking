load pmidlle
load pleft
load steroParameters;

fname1 = 'proefpersoon 1.1_M.avi';
fname2 = 'proefpersoon 1.1_L.avi';

% Intialize and read frame
vid1 = VideoReader(fname1,'CurrentTime',0);
vid2 = VideoReader(fname2,'CurrentTime',0);

I1 =rgb2gray((readFrame(vid1)));
I2 =rgb2gray((readFrame(vid2)));


I1=undistortImage(I1,stereoParams.CameraParameters1);
I2=undistortImage(I2,stereoParams.CameraParameters2);


%Intrinsics of both camera
intrinsics=[stereoParams.CameraParameters1.Intrinsics;stereoParams.CameraParameters2.Intrinsics];

% pose of 2nd camera wrt 1st
[R,t] = relativeCameraPose(stereoParams.EssentialMatrix ,stereoParams.CameraParameters1,stereoParams.CameraParameters2,pm,pl)

% obtaining camera poses
vSet = imageviewset();
vSet = addView(vSet,1, rigid3d(eye(3), [0 0 0]), 'Points', pm); 
vSet = addView(vSet,2, rigid3d(R,t), 'Points', pl); 
camPoses=poses(vSet);

%LSE
for i=1:length(pm)
points = [pm(i,1),pm(i,2);pl(i,1),pl(i,2)];
viewIDs = [1 2];
tracks(i) = pointTrack(viewIDs,points);
xyzPoints(i,:) = triangulateMultiview(tracks(i), camPoses,intrinsics); 
end

%Bundle Adjustments for further refining
[xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(xyzPoints, ...
        tracks, camPoses, stereoParams.CameraParameters1);
figure;    
plot3(xyzPoints(:,1),xyzPoints(:,3),-xyzPoints(:,2),'*');