#!/usr/bin/env python3
import ffmpeg
import sys
import runFeatures
import random
import os
from pathlib import Path

def createWavRandomCrop(filename):
    print(filename)
    dur=ffmpeg.probe(filename)['streams'][0]['duration']
    # dur=ffmpeg.probe(filename)

    print(dur)
    dur=int(float( dur ))
    out, _ = (
        ffmpeg
        .input(filename, ss=random.randint(0,dur-30), t=15, vn=None)
        .output(filename+".wav", format='wav' )
        .run()
    )
    return filename+".wav"

# result = list(Path(sys.argv[1]).rglob("*.mp3"))
# result = random.sample(result,1)


# print(result)
with open(sys.argv[1]) as f:

    content = f.readlines()
    path= random.choice(content)
    path="/home/mik/nextcloud/familyshare/mike_music_full/music/"+path
    path=path.rstrip()
    print(path)
    wavout=createWavRandomCrop(path)
    print(wavout)
    runFeatures.main("DBv2.db",wavout)
    os.remove(wavout)
# print(sys.argv[1])
