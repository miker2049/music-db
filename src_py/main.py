#!/usr/bin/env python3
import loadframes
import sqlite3
from supercollider import Server, Synth, Buffer
from flask import Flask, send_file, request
app = Flask("dbapp")
import os
# server = Server("100.105.205.122")

# loadframes.db_to_buff(1098, server, cur, 3, 0, 120)



@app.route("/")
def main():
    run=request.args.get("run")
    seg=request.args.get("seg")
    n=request.args.get("n")
    if not os.path.exists("/tmp/music-db-renders/"):
        os.mkdir("/tmp/music-db-renders")
    name= f'/tmp/music-db-renders/%s_%s_%s.wav'%(run,seg,n)
    if not os.path.exists(name):
        print("fetching and rendering")
        con = sqlite3.Connection("./test.db")
        cur = con.cursor()
        loadframes.db_to_wav(name, cur, run, seg, n)
    return send_file(name)

@app.route("/hello")
def hello():
    return "42"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
