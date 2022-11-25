#!/usr/bin/env python3
from multiprocessing import Pool, TimeoutError
from threading import Lock
import essentia
import essentia.standard as es
import loadframes
import sqlite3
import tempfile
run=32

lock=Lock()
def extract_run(r):
   con = sqlite3.Connection("../music-db_/db.db", timeout=120.0)
   cur = con.cursor()
   run=r[0]
   with tempfile.NamedTemporaryFile() as tmp:
       loadframes.db_run_to_wav(tmp.name, cur, run)
       segs = get_segments(tmp.name)
       ffeatures, _ = es.MusicExtractor(lowlevelStats=['mean', 'stdev'],
                                                     rhythmStats=['mean', 'stdev'],
                                                     tonalStats=['mean', 'stdev'])(tmp.name)
       with tempfile.NamedTemporaryFile() as result:
           es.YamlOutput(filename=result.name, format="json")(ffeatures)
           with open(result.name) as json:
               t=json.read()
               cur.execute("INSERT INTO music_extract (run, val) VALUES  (?, ?)", (run, t))
       for seg in enumerate(segs):
           features, features_frames = es.MusicExtractor(startTime=seg[1][0], endTime=seg[1][1],
                                                         lowlevelStats=['mean', 'stdev'],
                                                         rhythmStats=['mean', 'stdev'],
                                                         tonalStats=['mean', 'stdev'])(tmp.name)
           with tempfile.NamedTemporaryFile() as result:
               es.YamlOutput(filename=result.name, format="json")(features)
               with open(result.name) as json:
                   t=json.read()
                   cur.execute("INSERT INTO music_extract_segs (run, val, seg) VALUES  (?, ?, ?)", (run, t, seg[0]))
   lock.acquire()
   con.commit()
   lock.release()


def onsets_to_segments(onsets):
    out=[]
    for on in enumerate(onsets):
        start = on[1]
        end = on[1]
        if on[0]+1 < len(onsets):
            end = onsets[on[0]+1]
            out.append((start,end))
    return out


def get_onsets(audioname):
    audio, sr, chan, _, _, _ = es.AudioLoader(filename=audioname)()
    left, right = es.StereoDemuxer()(audio)
    # 1. Compute the onset detection function (ODF).
    # The OnsetDetection algorithm provides various ODFs.
    od_hfc = es.OnsetDetection(method='hfc')
    od_complex = es.OnsetDetection(method='complex')
    # We need the auxilary algorithms to compute magnitude and phase.
    w = es.Windowing(type='hann')
    fft = es.FFT() # Outputs a complex FFT vector.
    c2p = es.CartesianToPolar() # Converts it into a pair of magnitude and phase vectors.
    # Compute both ODF frame by frame. Store results to a Pool.
    pool = essentia.Pool()
    for frame in es.FrameGenerator(left, frameSize=1024, hopSize=512):
        magnitude, phase = c2p(fft(w(frame)))
        pool.add('odf.hfc', od_hfc(magnitude, phase))
        pool.add('odf.complex', od_complex(magnitude, phase))
        # 2. Detect onset locations.
    onsets = es.Onsets()
    onsets_hfc = onsets(essentia.array([pool['odf.hfc']]), [1])
    onsets_complex = onsets(essentia.array([pool['odf.complex']]), [1])
    return onsets_complex

def main():
    cur.execute("select distinct runID from Frames");
    for row in cur.fetchall():
        print("starting")
        res=extract_run(row[0])
        print(res, row[0])
    con.commit()


def get_segments(filename):
    o=get_onsets(filename)
    f=onsets_to_segments(o)
    return f[:-1]

def frame_file_secs(start, dur):
   con = sqlite3.Connection("../music-db_/db.db")
   cur = con.cursor()


#main()
if __name__ == '__main__':
    # start 4 worker processes
    with Pool(processes=8) as pool:
        con = sqlite3.Connection("../music-db_/db.db")
        cur = con.cursor()
        cur.execute("select distinct runID from Frames");
        l=cur.fetchall();
        for row in l:
           extract_run(row)
