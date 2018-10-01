# 3DRegionGrowing

This is an implementation of 3D Region Growing (RG) algorithm used in computer vision.

The algorithm receives a 3D image, a seed which is a point in 3D space inside the 3D image
and also a 3D mask which specifies which regions of the 3D image will go through the 3D RG algorithm. 
If the user doesn't want to specify such limitation, a 3D array of ones with a shape equal to that of 
3D image's can be used as the mask.

The user also have to specify the upper and lower threshold for the algorithm.

Flow:
1- The algorithm starts by checking all 26 Neighbors of the seed point given by the user
2- For each neighbor, if the intensity of the neighbor is within the upper and lower thresholds, the neighbor's coordinate
is marked as 1 on the output mask. Finally, the neighbor is pushed into a queue. 
3- When all the neighbors of the seed are finished being analysed, a new point's coordinate (newItem) is popped out of the queue.
4- The for newly popped coordinate steps 1-3 are repeated until the queue is empty.

RegionGrow3D class:
Constructer Input arguments:

  images: 3D numpy array, datatype = int
  masks: 3D numpy array, datatype = int
  upperThreshold: int
  lowerThreshold: int
  
Class Methods:
  outputMask = RegionGrow3D.Main(seed)
    
  Input arguments:
    seed: vector with dims=(1,3), datatype = int
    
   Returns:
    outputMask: 3D numpy array, datatype = int
