#!/usr/bin/env python
import importlib
import yaafelib as yaafe
import scrapeUtils as scr

# frames_fp = yaafe.FeaturePlan( sample_rate=44100, resample=1)
# frames_fp.addFeature("frames: Frames blockSize=1024 stepSize=1024")
# frames_df=frames_fp.getDataFlow()

thisfilename="./sounds/julien_crop.wav"
segs=scr.getFileSegments(thisfilename)
frames=scr.getFrames(thisfilename)
print(segs)

import sys
print(sys.argv)
print(scr.findInRange([5,8,10,100,32,500,45,67], int(sys.argv[1])))

# feats=scrapeUtils.getFileFeatures(thisfilename)
# print(feats[0])
# retrieve features from engine
# do what you want with your feature data
# engine.load
