Buffer.freeAll(s)

// def cosine_similarity(x, y):
//     return np.dot(x, y) / (np.sqrt(np.dot(x, x)) * np.sqrt(np.dot(y, y)))

~db=DB("DBv2.db",s)
(
~results=~db.queryFloats("SELECT load_extension('lib/extension-functions.so'); SELECT * from segmentavgs where (chrr=1.0) AND sff<0.1 ORDER BY sff LIMIT 100;" ,23,true);

~sort=~euclideanSort.value(~results);
~buffs= ~sort.collect({arg e; var b=~db.getSegmentBuffer(e[0],e[1],1); b.bufnum})
)

~bb.play


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
}
)

(
~cosineSim={
	|x,y|
	((x*y).sum)/(((x*x).sum).sqrt*((y*y).sum).sqrt)
}
)


Pdef.removeAll
EDrums()
~bb=(~db.getSegmentBuffer(4,7,1)).play
~bb.play

~eg=EGuitar(s)

(
Pbindef(\guit,
	\type, \guitarEvent,
	\guitar, ~eg,
	\midinote, Place(#[ [60,60,55,67],[72,79] ],inf)-24,
	\amp, 0.2,
	\dur, 0.125/2
).play
)


(
Pbindef(\snare,
	\instrument, \clap,
	\amp, Pseq([0,0.4],inf),
	\dur, Prand([0.25],inf)
).play
)

(
Pbindef(\kick,
	\instrument, \kick3,
	\amp, 0.8,
	\dur, Prand([0.5],inf)
).play;
Pbindef(\play3,
	\instrument, \dbplayer,
	\amp,0.125,
	\time, 0.5,
	// \dur, Prand([0.25,0.125,0.5],inf),
	\dur,0.125,
	\rate,1,
	// \rate, Pwalk(
	// 	Array.fill(5,{ arg i; Scale.majorPentatonic.degreeToRatio(i,1) })
	// 	),
	\bufnum, Pwalk(~buffs, startPos:0),
	// \viewer, Pfunc({|e|
	// 	var plot;
	// 	AppClock.sched(0.0,{
	// 		var tt=e[\bufnum].postln;
	// 		plot=Buffer.cachedBufferAt(s, tt).plot;
	// 	});
	// 	AppClock.sched(e[\time],{
	// 		plot.parent.close;
	// 	});
	// })
).play;
)

(
Pdef(\snare).play;
Pbindef(\play3, \bufnum, Pwalk(~buffs, startPos:70));
)

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