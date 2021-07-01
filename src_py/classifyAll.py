#!/usr/bin/env python3
import re
import sqlite3
import classifier
import numpy as np

con = sqlite3.connect("DBv2.db")
cur=con.cursor()
cur.execute("SELECT runID, segment FROM Chords GROUP BY runID, segment;")

for x in cur.fetchall():
    cl=classifier.getClassification(con,x[0],x[1])
    cl= re.sub(r"[')(,]","",str(cl))
    print(x[0],x[1],cl)
    cur.execute("INSERT INTO Classification (runID,segment,tags) VALUES (?,?,?) ON CONFLICT(runID,segment) DO UPDATE SET runID=excluded.runID, segment=excluded.segment, tags=excluded.tags;",(x[0],x[1],cl))

con.commit()
con.close()
