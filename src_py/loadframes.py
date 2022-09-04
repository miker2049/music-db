#!/usr/bin/env python3 

"""
Example: Buffer creation and playback.

Before running this script, the SC server must be started, and the following
SynthDef stored:

SynthDef(\playbuf, { |out = 0, bufnum = 0, gain = 0.0|
    var data = PlayBuf.ar(1, bufnum, loop: 1) * gain.dbamp;
    Out.ar(out, Pan2.ar(data));
}).store;
"""

from supercollider import Server, Synth, Buffer
import math
import time
import random
import sqlite3
import struct
import wave
import numpy as np
from tqdm import tqdm


def get_frame_count(cur, run, start, end ):
    res = cur.execute( "SELECT count(id) FROM Frames where runID = ? and segment between ? and ?;", (run, start, end))
    return res.fetchone()[0]

def db_to_buff(bufnum, s, cur, run, start, end):
    res = cur.execute( "SELECT data FROM Frames where runID = ? and segment between ? and ? ORDER BY rowNumber ASC;", (run, start, end))
    fs = res.fetchall()
    count = len(fs)
    buf = Buffer.alloc(s, 1024*count, num_channels=1, id=109)
    for l in tqdm(enumerate(fs)):
        un = struct.unpack( ">1024f", l[1][0])
        buf.set(un, l[0]*1024)
        s.sync()

def db_to_wav(wavp, cur, run, start, end):
    res = cur.execute( "SELECT data FROM Frames where runID = ? and segment between ? and ? ORDER BY rowNumber ASC;", (run, start, end))
    fs = res.fetchall()
    count = len(fs)
    wav = wave.open(wavp, "wb")
    wav.setnframes(count)
    wav.setnchannels(1)
    wav.setsampwidth(2)
    wav.setframerate(44100)
    for l in tqdm(enumerate(fs)):
        baw = [ int( sample * 32767 ) for sample in struct.unpack( ">1024f", l[1][0]) ]
        wav.writeframesraw(struct.pack("<1024h", *baw))



# db_to_wav("harf.wav", cur, 3, 0, 120)

#-------------------------------------------------------------------------------
# Create connection to default server on localhost:57110
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Create a Buffer, loop playback, and periodically rewrite its contents
# with uniformly random samples.
#-------------------------------------------------------------------------------
# print("Created buffer: %s" % buf.get_info())
#
# print("Created buffer with id: %s" % buf.id)

#synth = Synth(server, 'playbuf', { "bufnum" : buf, "gain" : -18.0 })

# out = []
# dt = np.dtype(np.float32)
# dt = dt.newbyteorder('>')
# make_pcm = lambda x: int( x * 32767 )
# m = np.vectorize(make_pcm)
# np_out = np.array([], dt)

    # print(unpb[0], baw[0])
