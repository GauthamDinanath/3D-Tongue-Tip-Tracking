close all
clear variables
videoReader = VideoReader('proefpersoon 1.1_M.avi','CurrenTtime',4);

objectRegion=[360  474   361  250 ];
%objectRegion=[ 401   615   270   202];

frame = readFrame(videoReader);
frame1=imcrop(frame,objectRegion);

opticflow=opticalFlowFarneback;
t=vision.PointTracker('MaxBidirectionalError',5);

row=1;
col=1;
initialize(t,[row col],frame1);
count=1;
  
while hasFrame(videoReader)
      frame = readFrame(videoReader);
      frame2=imcrop(frame,objectRegion);
           
      mask=rgb2gray(frame2);
      mask(mask<80)=0;
      mask=imbinarize(mask);
      
      mask = imclearborder(mask);
      mask = imfill(mask, 'holes');
      mask = bwpropfilt(mask, 'Area',[-Inf, 200 - eps(500)])
      se=strel('disk',7);
      mask=bwareaopen(mask,50)
      mask=imclose(mask,se);
      
      
      
      flow=estimateFlow(opticflow,mask);
      [rp,cp]=find(flow.Magnitude == max(flow.Magnitude(:)));
    
      if max(flow.Magnitude(:))>=7.5 & max(flow.Magnitude(:))<=8
         max(flow.Magnitude(:))
         release(t);
         initialize(t,[cp rp],frame2);
      else
        [pt,point_validity] = t(frame2);
        cp=pt(1);
        rp=pt(2);
      end
      
  %if mean(frame2(:))>73 & mean(frame2(:))<73.6
%        [points,validity]=t(frame2);
 


      z=imoverlay(frame2,mask,'red');
      imshow(z);
      hold on
      plot(cp, rp, 'ro', 'MarkerSize', 30);
      %plot(p.selectStrongest(1));
      hold off
      drawnow
end



