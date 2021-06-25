#!/usr/bin/env python3
import json
import math
import codecs
import yaafelib as yaafe
import scrapeUtils as scr
import queries
import struct
qs=queries.qs
import sys
import numpy as np
from datetime import datetime
# datetime object containing current date and time
now = datetime.now()
dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

import sqlite3

con = sqlite3.connect(sys.argv[2])
# enable extension loading
con.enable_load_extension(True)
# Load the fulltext search extension
con.load_extension("lib/extension-functions")
db = con.cursor()

filename=sys.argv[1]
feats=scr.getFileFeatures(filename)
frames=scr.getFrames(filename)
segments=feats[2]

db.execute(qs['meta'], (filename,
                                json.dumps(feats[0]['lx']),
                                json.dumps(feats[0]['chr']),
                                json.dumps(feats[0]['chr2']),
                                json.dumps(feats[0]['chord']),
                                json.dumps(feats[0]['psp']),
                                json.dumps(feats[0]['psh']),
                                json.dumps(feats[0]['ss']),
                                json.dumps(feats[0]['sv']),
                                json.dumps(feats[0]['sd']),
                                json.dumps(feats[0]['sf']),
                                json.dumps(feats[0]['sss']),
                                json.dumps(feats[0]['mfcc']),
                                json.dumps(feats[0]['lpc']),
                                json.dumps(feats[0]['obsi']),
                                json.dumps(feats[0]['obsir']),
                                json.dumps(feats[0]['am']),
                                json.dumps(feats[0]['onset']),
                                json.dumps(frames[0]['frame']),
                                dt_string
) )
this_run_id=db.execute("Select id from ProcessingRunsMeta order by id desc limit 1;").fetchone()
this_run_id=this_run_id[0]

for key in feats[1].keys():
    # print(key)
    rate=feats[0][key]['sampleRate']
    step=feats[0][key]['sampleStep']

    # print(sr,step)
    for index,row in enumerate(feats[1][key]):
        # this index multiplied by step gives the current sample pos, divide by rate to get sec
        this_seg=scr.findInRange(segments, (index*step)/rate )
        tup=tuple([this_run_id,this_seg,index])+tuple(row)
        db.execute(qs[key],tup)


frames_rate=frames[0]['frame']['sampleRate']
frames_step=frames[0]['frame']['sampleStep']
total_rows=len(frames[1]['frame'])
for index,row in enumerate(frames[1]['frame']):
    this_seg=scr.findInRange(segments, (index*frames_step)/frames_rate )
    tx=np.array2string(row, threshold=frames_step+5, separator=",")+"@"
    # tx=row.tobytes()
    tx = tx[1 : len(tx)-2] + "@"
    per= math.ceil((index/total_rows)*100)
    print("frames {p}% done".format(p=per))
    tup=tuple([this_run_id,this_seg,index,tx])
    # tup=tuple([this_run_id,0,index])+(row.tobytes(),)
    db.execute(qs['frame'],tup)




# print(frametest[0][1])
# print(frametest[0][2])
# print(frametest[0][3])
# print(struct.unpack('>1024f',frametest[0])[0])
# meta=feats[0]
# print(feats[0].keys())
# for feature in meta.keys():
#     print(meta[feature])
# js=json.dumps({ 'hey': 20 })



# this_run_id=cur.execute("Select id from ProcessingRunsMeta order by id desc limit 1;").fetchone()
# this_run_id=this_run_id[0]
# print(len( list(feats[1]['sf'])))
# print(len( list(feats[1]['mfcc'])))
# it=iter(scr.FeatureDataIterator(this_run_id,feats,feats[2]))

# # print(next(it))
# # print(next(it))
# # print(next(it))
# # print(next(it))
# for val in it:
#     # print(len(val))
#     cur.execute(insert_feature_query,val)

con.commit()
con.close()
