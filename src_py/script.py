#!/usr/bin/env python
import statistics
import yaafelib as yaafe
import math

samplerate=16000
frame_samplerate= 44100
stepSize=512
blockSize=1024

secondRows=samplerate/stepSize
peakFindWindowSize=0.25*secondRows


fp = yaafe.FeaturePlan( sample_rate=16000, resample=1)
fp.loadFeaturePlan("./featureConfig")
df=fp.getDataFlow()

onset_fp = yaafe.FeaturePlan( sample_rate=16000, resample=1)
onset_fp.addFeature("onset: ComplexDomainOnsetDetection blockSize=1024  stepSize=512")
onset_df=onset_fp.getDataFlow()

frames_fp = yaafe.FeaturePlan( sample_rate=44100, resample=1)
frames_fp.addFeature("frames: Frames blockSize=1024 stepSize=1024")
frames_df=frames_fp.getDataFlow()




# create your AudioFileProcessor
# leave output format to None

def process( dff, engine, filepath):
    afp = yaafe.AudioFileProcessor()
    engine.load(dff)
    afp.processFile(engine, filepath)
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
    return filtered

def getPeakRows(onsetsDataa):
    return getUnfiltered(onsetsDataa)
    # return filterClumps(getUnfiltered(onsetsDataa))

def getFileSegments(filepath):
    engine = yaafe.Engine()
    onsets=process( onset_df, engine, filepath)
    engine.reset()
    onsetsData=onsets[1]['onset']
    segments=getPeakRows(onsetsData)
    return (segments, onsets[0])

def getFileFeatures(filepath):
    engine = yaafe.Engine()
    onsets=process( onset_df, engine, filepath)
    engine.reset()
    onsetsData=onsets[1]['onset']
    segments=getPeakRows(onsetsData)
    return segments

print(getFileSegments( "./julien_crop.wav")[1])
# retrieve features from engine
# do what you want with your feature data
# engine.load
