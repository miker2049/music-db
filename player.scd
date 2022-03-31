Buffer.freeAll(s)

// def cosine_similarity(x, y):
//     return np.dot(x, y) / (np.sqrt(np.dot(x, x)) * np.sqrt(np.dot(y, y)))
Server.supernova
~db=DB("music -c",s, "PGPASSWORD=postgres psql -t -q -h 100.98.141.12 -p 6543 -U postgres --no-password")
~db=DB("db.db",s, "sqlite3")
(
~euclideanSort={
	|arr, baseI=0| //2d, with first and second elements runID and segment

	var output;
	var rest, diffs, base;
	output= Array.new(arr.size);
	output.insert(0,arr[baseI]);
	base=arr[baseI][2..arr.size-1];
	diffs = arr.collect({
		|e, i|
		var dist =~cosineSim.value(base,e[2..e.size-1]);
		[e[0],e[1],dist]
	});
	diffs.sort({|a,b| a[2]<b[2]});
};
~cosineSim={
	|x,y|
	((x*y).sum)/(((x*x).sum).sqrt*((y*y).sum).sqrt)
};
// ~results=~db.queryFloats("SELECT load_extension('lib/extension-functions.so'); SELECT * from segmentavgs where (chrr=4.0) AND kurtosiss>0.4 AND pshh < 1 ORDER BY kurtosiss LIMIT 100 OFFSET 0;" ,23,true);
fork {
~results=~db.queryFloats(" SELECT * from segmentavgs where (chrr=3.0) AND kurtosiss>0.4 AND spreadd < 50 AND skewness < 4 ORDER BY spreadd LIMIT 50 OFFSET 0;" ,23,true);

~sort=~euclideanSort.value(~results);
~buffs= ~sort.collect({arg e; var b=~db.getSegmentBuffer(e[0],e[1],1); b.normalize; b.bufnum});
~buffs.removeAllSuchThat({arg bb; Buffer.cachedBufferAt(s,bb).numFrames < 100})

}
)

~buffs.removeAllSuchThat({arg bb; Buffer.cachedBufferAt(s,bb).numFrames < 100})
"Hey'hey\'"

Pdef.removeAll
EDrums()
~bb=(~db.getSegmentBuffer(1,102,1)).play
~tt= ~db.getSegmentBuffer(1,102,1)
~tt.plot;
~tt.play;
3.print;
~bb.play

~eg=EGuitar(s)
~buffs[2]

(
fork {


	~buffs.do({|bb| bb.postln; Synth(\dbplayer, [\out, 0, \bufnum, bb, \time, 2, \amp, 0.3]); 1.wait;})
}
)

Buffer.cachedBufferAt(s, 83).numFrames > 0

(
Pbindef(\guit,
	\type, \guitarEvent,
	\guitar, ~eg,
	\midinote, Place(#[ [60,60,55,67],[72,79] ],inf)-24,
	\amp, 0.2,
	\dur, 0.125/2
).stop
)
s.meter

(
Pbindef(\snare,
	\instrument, \clap,
	\amp, Pseq([0,0.4],inf),
	\dur, Prand([0.25],inf)
)
)
~buffs.size
(
Pbindef(\kick,
	\instrument, \kick3,
	\amp, 0.8,
	\dur, Prand([0.5],inf)
).play;
Pbindef(\play3,
	\instrument, \dbplayer,
	\amp,0.25,
	\time, 0.5,
	\dur,0.125,
	\rate,1,
	\bufnum, Pwalk(~buffs, Pseq([1],inf), Pseq([1, -1], inf)),
	// \viewer, Pfunc({|e|
	// 	var plot;
	// 	AppClock.sched(0.0,{
	// 		var tt=e[\bufnum].postln;
	// 		plot=Buffer.cachedBufferAt(s, tt).plot("NOFOCUS");
	// 	});
	// 	AppClock.sched(e[\time],{
	// 		plot.parent.close;
	// 	});
	// })
).play;
)

s.prepareForRecord("sss.wav",2)
s.record;
s.stopRecording

(
Pdef(\snare).play;
Pbindef(\play3, \bufnum, Pwalk(~buffs, startPos:20));
)

Buffer.new(s,2).plot("NOFOCUS")

(
Pdef(\snare).pause;
Pdef(\kick).play;
Pdef(\guit).play;
Pbindef(\play3, \bufnum, Pwalk(~buffs, startPos:0));
)

(
SynthDef(\dbplayer, { |out, bufnum, start, time, amp, rate = 1|
	var sig = PlayBuf.ar(1, bufnum,
		rate: rate * BufRateScale.kr(bufnum),
		startPos: start, loop: 0
	),
	env = EnvGen.kr(Env.linen(0.06, time, 0.06, level: amp),
		doneAction: Done.freeSelf);
	sig = FreeVerb.ar(sig, 0.3, 0.9,0.6);
	sig=Normalizer.ar(sig);
	Out.ar(out, (sig * env).dup);
}).add;
)
//if its >= 12, its minor,  24 dim, over 36 augmented, over 48 suspended,
//over 60 is 7
//and then the difference from that is the tonal center?
//so, bsus should be 59