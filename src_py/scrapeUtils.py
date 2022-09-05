#!/usr/bin/env python3


import importlib
import statistics
import yaafelib as yaafe
import math
import json
from inspect import getsourcefile
from os.path import dirname
# this_filename="./sounds/julien_crop.wav"
samplerate=16000
frame_samplerate= 44100
stepSize=512
blockSize=1024

secondRows=samplerate/stepSize
peakFindWindowSize=0.25*secondRows





main_engine = yaafe.Engine()


# create your AudioFileProcessor
# leave output format to None

def process( dff, engine, filepath):
    engine.reset()
    engine.load(dff)
    print('processing')
    if type(filepath) is str:
        afp = yaafe.AudioFileProcessor()
        print('get afp')
        afp.processFile(engine, filepath)
        print('processed afp')
        engine.flush()
    else:
        try:
            print(filepath)
            engine.writeInput('audio', filepath)
            engine.process()
        except Exception:
            print('cant process audio')

    return (engine.getOutputs(), engine.readAllOutputs())



# getting the half bit before this frame
def getWindowAverages(index, arr):
    before_start=math.floor( index-peakFindWindowSize )
    after_end=math.floor( index+peakFindWindowSize )

    before_arr=arr[before_start : index]
    after_arr=arr[index : after_end]

    beforeMedian=statistics.median([0] if len(before_arr) < 1 else before_arr)
    afterMedian=statistics.median([0] if len(after_arr) < 1 else after_arr)

    return (beforeMedian, afterMedian)


# print(getWindow(onsets[1]['onset'], 31/4, 430))
def getUnfiltered(onsetsDataa):
    segments = []
    for index, onset in enumerate(onsetsDataa, start=0):
        avgs = getWindowAverages(index, onsetsDataa)
        if onset>avgs[0] and onset > avgs[1]:
            segments.append(index)
    return segments

def filterClumps(arr):
    filtered = []
    for index, frame in enumerate(arr, start=0):
        if arr[index-1] != frame-1:
            filtered.append(frame)
    print(filtered)
    return filtered

def getPeakSecs(onsetsDataa):
    filtered= filterClumps(getUnfiltered(onsetsDataa))
    ms = []
    for i in filtered:
        ms.append((i*stepSize)/samplerate)
    return ms
    # return filterClumps(getUnfiltered(onsetsDataa))

def getFrames(filepath):
    frame_fp = yaafe.FeaturePlan( sample_rate=frame_samplerate, resample=1)
    frame_fp.addFeature("frame: Frames blockSize=1024  stepSize=1024")
    frame_df=frame_fp.getDataFlow()
    print("got dataflowww")
    frames=process( frame_df, main_engine, filepath)
    return frames

def getFileFeatures(filepath):
    fp = yaafe.FeaturePlan( sample_rate=16000, resample=1)
    cwd = dirname(getsourcefile(lambda:0))
    print(cwd)
    fp.loadFeaturePlan(cwd+"/featureConfig")
    df=fp.getDataFlow()
    output=process( df, main_engine, filepath)
    onsetsData=output[1]['onset']
    segments=getPeakSecs(onsetsData)
    print("flushed file features")
    return output + (segments,)

def findInRange(arr,i):
    arr=enumerate(sorted(arr), start=0)
    last=1
    for pos,item in arr:
        if i < item:
            return pos -1
        last = pos -1
    return last

class FeatureDataIterator:
    def __init__(self, runID, features, segments):
        self.runID = runID
        self.features = features
        self.segments = segments
        self.songIndex = 0
        self.length = len(self.features[1]["mfcc"])
        print(self.length)

    def __iter__(self):
        return self

    def __next__(self):
        if self.songIndex < self.length-1:
            # print(self.songIndex, self.length)
            sss = self.getFeatFrame(self.songIndex, 'sss'),
            if len(sss) < 4:
                sss = ((-1,-1,-1,-1),)
            self.songIndex +=1
            return ( self.runID,
                     self.songIndex-1,
                     findInRange(self.segments,self.songIndex),
                     json.dumps(list(self.getFeatFrame(self.songIndex, 'lx'))),
                     json.dumps(list(self.getFeatFrame(self.songIndex, 'chr'))),
                     json.dumps(list(self.getFeatFrame(self.songIndex, 'chr2'))),
                     json.dumps(list(self.getFeatFrame(self.songIndex, 'lpc'))),
                     float(self.getFeatFrame(self.songIndex, 'chord')[0]),
                     json.dumps(list(self.getFeatFrame(self.songIndex, 'mfcc'))),
                     float(self.getFeatFrame(self.songIndex, 'sf')[0]),
                     float(self.getFeatFrame(self.songIndex, 'sd')[0]),
                     sss[0][0], sss[0][1], sss[0][2], sss[0][3],
                     float(self.getFeatFrame(self.songIndex, 'ss')[0]),
                     float(self.getFeatFrame(self.songIndex, 'sv')[0]),
                     float(self.getFeatFrame(self.songIndex, 'psp')[0]),
                     float(self.getFeatFrame(self.songIndex, 'psh')[0]),
                     float(self.getFeatFrame(self.songIndex, 'onset')[0]),
                     json.dumps(list(self.getFeatFrame(self.songIndex, 'obsi'))),
                     json.dumps(list(self.getFeatFrame(self.songIndex, 'obsir'))),
                     json.dumps(list(self.getFeatFrame(self.songIndex, 'am'))),
                    )
        else:
            raise StopIteration

    def getFeatFrame(self,index,feat):
        out = (-1,)
        if index <= len(self.features[1][feat])-1:
            out=self.features[1][feat][index]
        return out
