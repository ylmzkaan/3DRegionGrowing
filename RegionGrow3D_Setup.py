# -*- coding: utf-8 -*-
"""
Created on Mon Jun 11 18:50:39 2018

@author: kaany
"""

from distutils.core import setup
from Cython.Build import cythonize
import numpy

setup(
    ext_modules = cythonize("RegionGrow3D.pyx"),
    include_dirs = [numpy.get_include()]
)