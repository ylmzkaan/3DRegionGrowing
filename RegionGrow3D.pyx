# -*- coding: utf-8 -*-
"""
Created on Mon Jun 11 18:50:26 2018

@author: kaany
"""

from collections import deque
import numpy as np
cimport numpy as np
cimport cython
import logging
logging.basicConfig(level=logging.debug)

cdef class RegionGrow3D:
    
    cdef int[:,:,:] images
    cdef int[:,:,:] masks
    cdef int[:,:,:] tracheaMask
    cdef int upperThreshold
    cdef int lowerThreshold
    cdef neighborMode
    cdef queue
    
    def __cinit__(self, int[:,:,:] images, int[:,:,:] masks, 
                  int upperThreshold, int lowerThreshold, neighborMode):
        self.images = images
        self.masks = masks
        self.outputMask = np.zeros_like(self.slices)
        self.upperThreshold = upperThreshold
        self.lowerThreshold = lowerThreshold
        self.neighborMode = neighborMode
        self.queue = deque()
    
    def main(self, seed):
        
        cdef int newItem[3]
        cdef int neighbors[26][3]
        newItem = seed
        
        self.outputMask[newItem[0], newItem[1], newItem[2]] = 1
        self.queue.append((seed[0], seed[1], seed[2]))
        
        while len(self.queue) != 0:
            newItem = self.queue.pop()
            if self.neighborMode == "26n":
                neighbors = [[newItem[0]-1, newItem[1]-1, newItem[2]-1],   [newItem[0]-1, newItem[1]-1, newItem[2]],   [newItem[0]-1, newItem[1]-1, newItem[2]+1],
                             [newItem[0]-1, newItem[1], newItem[2]-1],     [newItem[0]-1, newItem[1], newItem[2]],     [newItem[0]-1, newItem[1], newItem[2]+1],
                             [newItem[0]-1, newItem[1]+1, newItem[2]-1],   [newItem[0]-1, newItem[1]+1, newItem[2]],   [newItem[0]-1, newItem[1]+1, newItem[2]+1],
                             [newItem[0], newItem[1]-1, newItem[2]-1],     [newItem[0], newItem[1]-1, newItem[2]],     [newItem[0], newItem[1]-1, newItem[2]+1],
                             [newItem[0], newItem[1], newItem[2]-1],       [newItem[0], newItem[1], newItem[2]+1],     [newItem[0], newItem[1]+1, newItem[2]-1],
                             [newItem[0], newItem[1]+1, newItem[2]],       [newItem[0], newItem[1]+1, newItem[2]+1],   [newItem[0]+1, newItem[1]-1, newItem[2]-1],
                             [newItem[0]+1, newItem[1]-1, newItem[2]],     [newItem[0]+1, newItem[1]-1, newItem[2]+1], [newItem[0]+1, newItem[1], newItem[2]-1],
                             [newItem[0]+1, newItem[1], newItem[2]],       [newItem[0]+1, newItem[1], newItem[2]+1],   [newItem[0]+1, newItem[1]+1, newItem[2]-1],
                             [newItem[0]+1, newItem[1]+1, newItem[2]],     [newItem[0]+1, newItem[1]+1, newItem[2]+1]] 
                for neighbor in neighbors:
                    self.checkNeighbour(neighbor[0], neighbor[1], neighbor[2])
            elif self.neighborMode == "6n":
                self.checkNeighbour(newItem[0], newItem[1], newItem[2]-1)
                self.checkNeighbour(newItem[0], newItem[1], newItem[2]+1)
                self.checkNeighbour(newItem[0], newItem[1]-1, newItem[2])
                self.checkNeighbour(newItem[0], newItem[1]+1, newItem[2])
                self.checkNeighbour(newItem[0]-1, newItem[1], newItem[2])
                self.checkNeighbour(newItem[0]+1, newItem[1], newItem[2])
        return self.outputMask
        
    cdef checkNeighbour(self, int z, int y, int x):
        cdef int intensity
        if (x < 513 and y < 513 and z < 513 
            and x > -1 and y > -1 and z > -1 
            and self.masks[z,y,x] == 1):
            intensity = self.images[z, y, x]
            if self.isIntensityAcceptable(intensity) and self.outputMask[z,y,x] == 0:
                self.outputMask[z,y,x] = 1
                self.queue.append((z, y, x))
    
    cdef isIntensityAcceptable(self, int intensity):
        if intensity < self.upperThreshold and intensity > self.lowerThreshold:
            return True
        return False  
