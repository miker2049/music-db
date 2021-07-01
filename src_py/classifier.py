#!/usr/bin/env python3

import sqlite3
import struct
import tensorflow as tf
import tensorflow_hub as hub
import numpy as np
import csv
import io
import scipy.signal as sig

class SoundData:
    def __init__(self):
        self.count = bytes()

    def step(self, value):
        self.count += bytes(value)

    def finalize(self):
        return bytes(self.count)

def getSegmentData(con, runID, segment):
    con.create_aggregate("mysum", 1, SoundData)
    cur = con.cursor()
    cur.execute("select count(data) from Frames where runID=? AND segment=?",(runID,segment))
    count = int(cur.fetchone()[0])*1024
    cur.execute("select mysum(data) from Frames where runID=? AND segment=?",(runID,segment))
    data=cur.fetchone()[0]
    data=struct.unpack(">%sf"%count,data)
    return data

def class_names_from_csv(class_map_csv_text):
  """Returns list of class names corresponding to score vector."""
  class_map_csv = io.StringIO(class_map_csv_text)
  class_names = [display_name for (class_index, mid, display_name) in csv.reader(class_map_csv)]
  class_names = class_names[1:]  # Skip CSV header
  return class_names

def getClassification(db,runID,segment):
    seg=getSegmentData(db,runID,segment)
    secs=len(seg)/44100
    seg=sig.resample(seg,int(secs*16000))
    # # Load the model.
    model = hub.load('https://tfhub.dev/google/yamnet/1')

    waveform = np.float32(seg)

    # Run the model, check the output.
    scores, embeddings, log_mel_spectrogram = model(waveform)
    scores.shape.assert_is_compatible_with([None, 521])
    embeddings.shape.assert_is_compatible_with([None, 1024])
    log_mel_spectrogram.shape.assert_is_compatible_with([None, 64])

    # Find the name of the class with the top score when mean-aggregated across frames.
    class_map_path = model.class_map_path().numpy()
    class_names = class_names_from_csv(tf.io.read_file(class_map_path).numpy().decode('utf-8'))
    highest= scores.numpy().mean(axis=0)
    highest=np.argsort(highest)[-5:]
    return (class_names[highest[0]],class_names[highest[1]],class_names[highest[2]],class_names[highest[3]],class_names[highest[4]],)

# print(getClassification("DBv2.db",219, 9))
# print(getClassification("DBv2.db",248, 9))
# print(getClassification("DBv2.db",42, 9))
# print(getClassification("DBv2.db",215, 9))
# print(getClassification("DBv2.db",309, 9))
