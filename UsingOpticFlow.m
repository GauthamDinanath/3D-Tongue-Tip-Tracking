close all
clear variables
%% Intialization
fname = 'proefpersoon 2_M.avi';
vidReader = VideoReader(fname,'CurrentTime',0);
frameRGB = readFrame(vidReader);

% v = VideoWriter('proefpersoon 2_M_OpticalFLow.avi');
% open(v) % video writer

imshow(frameRGB);
title('Outer corner of the Eyes');
objectRegion=round(getPosition(imrect));% marking the ROI around the mouth
e=getpts; % marking the outer end of the eyes on two sides

imshow(frameRGB);
title('Facial Landmark');
[land_mark(:,1),land_mark(:,2)] =getpts;
tl=vision.PointTracker('MaxBidirectionalError',1);% tracker for facial landmark
initialize(tl,[land_mark(:,1) land_mark(:,2)],frameRGB);


frameGray = rgb2gray(frameRGB);

%objectRegion=[360  474   357  250 ]; %M
%objectRegion=[ 123   500   360   204];%L
frame=imcrop(frameGray,objectRegion);

opticFlow = opticalFlowFarneback;
t=vision.PointTracker('MaxBidirectionalError',1);

x=1; % defaulting the marker points 
y=1;
initialize(t,[x y],frame);
count=1;
i=1
%% Point Tracking
while hasFrame(vidReader)
    frameRGB = readFrame(vidReader);
    frameGray = rgb2gray(frameRGB);
    frame=imcrop(frameGray,objectRegion);
   
    flow = estimateFlow(opticFlow,frame);
 
    [y,x]=find(flow.Magnitude == max(flow.Magnitude(:))); 
    
    if max(flow.Magnitude(:))>=6.2 ...
          & x+objectRegion(1)>e(1) & x+objectRegion(1)<e(2)
        count=2;
%       max(flow.Magnitude(:));
        release(t);
        initialize(t,[x y],frame); % Intializing tracker after detecting motion
    else
        p=t(frame);
        x=p(1);
        y=p(2);
    end
    
    if count==1;
        x=objectRegion(1)+(objectRegion(3)/2);
        y=objectRegion(2)+(objectRegion(4)/2);
    end
      x=x+objectRegion(1);
      y=y+objectRegion(2);
      
      l=tl(frameRGB);
    
    imshow(frameRGB)
    hold on
    plot(x, y, 'ro','Color','blue', 'MarkerSize', 25);
    plot(l(:,1),l(:,2),'+','Color','blue');
    hold off
    drawnow
    if count==2
     pl(i,:)=[x,y];
     i=i+1;
    end
%     F= getframe(gcf);
%     writeVideo(v,F);     

end

% close(v)





