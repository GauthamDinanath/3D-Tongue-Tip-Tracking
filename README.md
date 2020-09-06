# 3D-Tongue-Tip-Tracking

## Motivation: 
Patients undergoing surgery and/or radiotherapy in the oral region, especially the tongue, have the
risk of limited tongue mobility with serious deterioration of oral functions, such as speech, food transport,
swallowing, and mastication. To measure the range of motion, patients are asked to move their tongue to
standardized, extreme positions, left, right, forward, downward and upward

## Problem statement: 
Develop and test a method that is able to track the tip of the tongue and some facial landmarks
so as to find the 3D positions of these points.

## Dataset: 
University provided dataset containing videos of 3 subjects moving the tongue to the standardized extreme postions taken using a triple camera setup. 

## Requirements:
`Matlab 2019b`

## Approach:
Two approaches were tried:

1.Optical flow method: 
Morphological operations did not isolate the tongue tip effectively inorder to track the tip. In most cases other parts of the lips intefered with tracking. Optical flow provided with the best possible means to detect tongue tip due to movement and thereby carry out tracking

![Test Image 1](https://user-images.githubusercontent.com/64839751/92323194-fe165c80-f036-11ea-8bfc-fbf900de2dc9.png)
  
2.Contrast segmentation method ( When markers were used to annotate the tip of the tongue ):
Since markers were placed at the tip of the tongue, It was much easier to carrry out contrast based isolation of  the tongue tip and hence provided better tracking results.

## Results:

![Test Image 2](https://user-images.githubusercontent.com/64839751/92323195-feaef300-f036-11ea-97ad-899324b98f5e.png)
 

