DB {
	var dbpath, <segmentcount, localserver, dbcommand;

	var countquery = "SELECT count(id) FROM Frames where runID
						= % and segment between % and %;";
	// postgres
	var framequery = "SELECT '    X'||encode(data, 'hex') FROM Frames where runID = % and segment between % and % ORDER BY rowNumber ASC;";
	// sqlite
	// var framequery = "SELECT quote(data) FROM Frames where runID = % and segment between % and % ORDER BY rowNumber ASC;";

	*new{
		| dbpathh, localserverr, dbcom |
		if(localserverr.hasBooted.not,{Error("Server needs to be booted!").throw});
		^super.new.init( dbpathh, localserverr, dbcom);
	}


	init{
		|dbpathh,localserverr, dbcom|
		dbcommand=dbcom;
		localserver=localserverr;
		dbpath=dbpathh;
		SynthDef(\dbplayer, { |out, bufnum, start, time, amp, rate = 1|
			var sig = PlayBuf.ar(1, bufnum,
				rate: rate * BufRateScale.kr(bufnum),
				startPos: start, loop: 0
			),
			env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp),
				doneAction: Done.freeSelf);
			Out.ar(out, (sig * env).dup);
		}).add;
	}

	getSegmentBuffer{
		|runID, segment, n|
		var count, segmentCount;
		var command="% % \"%\"".format(dbcommand, dbpath, framequery.format(runID,segment,segment+n));
		var pipe = Pipe(command,"r");
		//to first X
		var l = pipe.readUpTo($X);
		var offset = 0;
		var b;
		//through full frame
		//kasjndas
		l = pipe.readUpTo($X);

		count="% % \"%\"".format(dbcommand, dbpath,countquery.format(runID,segment,segment+n)).unixCmdGetStdOut;
		b=Buffer.alloc(Server.default, count.asInteger*1024);
		"before".postln;

		while({l.notNil},{
			var clumps;
			l=l.tr($',$ );
			l=l.stripWhiteSpace;
			clumps=l.clump(8).collectAs({ |clump|
				Float.from32Bits(hexToInt(clump));
			}, FloatArray);
			b.setn((offset*1024),clumps);
			l = pipe.readUpTo($X);
			offset = offset+1;
		});
		"done".postln;
		^b;
	}

	getSegmentCount{
		|runID|

		var segcountquery = "SELECT segment FROM chords WHERE runID=% ORDER BY segment DESC LIMIT 1;";
		var count="% % \"%\"".format(dbcommand, dbpath,segcountquery.format(runID)).unixCmdGetStdOut;
		^count.asInteger;
	}

	getRandomChords{
		|chord|
		var chordquery = "SELECT runID, segment FROM Chords WHERE
							chord=% and segment>0 GROUP BY segment ORDER BY random() limit 20;".format(chord);
		var result="% % \"%\"".format(dbcommand, dbpath,chordquery)
		.unixCmdGetStdOut.tr($\n,$|)
		.postln;
		result=result.split($|).collectAs({arg i; i.asInteger;},Array).clump(2);
		result.removeAt(result.size-1);
		^result;
	}

	getRandomChordBuffers{
		|chord|
		^this.getRandomChords(chord).collect({arg e; var b = if(e.size>1,{b=this.getSegmentBuffer(e[0],e[1],1)});b;});
	}

	hexToInt{

		|str|
		var result = 0, i, size, digit;

		str.do { |char|
			digit = char.digit;
			if(digit.notNil) {
				result = (result << 4) | digit;
			} {
				"Invalid hex digit found at % in %".format(char, str).warn;
				result = (result << 4);
			};
		};

		result;
	}

	getMFCC{
		|whereClause="WHERE runID=1"|
		var mfccQuery=" SELECT
MFCC.runID,
MFCC.segment,
avg(MFCC.CepsNbCoeff1) as c1,
avg(MFCC.CepsNbCoeff2) as c2,
avg(MFCC.CepsNbCoeff3) as c3,
avg(MFCC.CepsNbCoeff4) as c4,
avg(MFCC.CepsNbCoeff5) as c5,
avg(MFCC.CepsNbCoeff6) as c6,
avg(MFCC.CepsNbCoeff7) as c7,
avg(MFCC.CepsNbCoeff8) as c8,
avg(MFCC.CepsNbCoeff9) as c9,
avg(MFCC.CepsNbCoeff10) as c10,
avg(MFCC.CepsNbCoeff11) as c11,
avg(MFCC.CepsNbCoeff12) as c12,
avg(MFCC.CepsNbCoeff13) as c13
FROM MFCC, Chords % GROUP BY MFCC.runID, MFCC.segment ORDER BY MFCC.segment ASC LIMIT 100;".format(whereClause);
		var result="% % \"%\"".format(dbcommand, dbpath,mfccQuery)
		.unixCmdGetStdOut.tr($\n,$|);
		result=result.split($|).collectAs({arg i; i.asFloat;},Array).clump(15);
		^result;
	}

	getMFCCSortedBuffer{
		|whereClause, offset=0, amount=40 baseI=0|
		var output;
		var rest, diffs, base;
		var floatArray = this.getMFCC(whereClause);
		output= Array.new(floatArray.size);
		output.insert(0,floatArray[baseI]);
		base=floatArray[baseI][2..floatArray.size-1];
		floatArray.removeAt(floatArray.size-1);
		diffs = floatArray.collect({
			|e, i|
			var dist =this.euclidean_distance(base,e[2..floatArray.size-1]);
			[e[0],e[1],0]
		});
		^diffs.sort({|a,b| a[2]<b[2]})[offset..offset+amount].collect({arg e; this.getSegmentBuffer(e[0].asInteger,e[1].asInteger,1)})

	}

	euclideanSort{
		|arr, baseI=0| //2d, with first and second elements runID and segment

		var output;
		var rest, diffs, base;
		output= Array.new(arr.size);
		output.insert(0,arr[baseI]);
		base=arr[baseI][2..arr.size-1];
		diffs = arr.collect({
			|e, i|
			var dist =this.euclidean_distance(base,e[2..arr.size-1]);
			[e[0],e[1],dist]
		});
		^diffs.sort({|a,b| a[2]<b[2]});
}

queryFloats{ | q, colN, dropFirst=false |
	var result="% % \"%\"".format(dbcommand, dbpath,q)
	.unixCmdGetStdOut.tr($\n,$|)
	.split($|).collect({|e| e.asFloat});
	if(dropFirst,{result.removeAt(0)});
	^result.clump(colN).removeAllSuchThat({arg e; e.size == colN});
}

euclidean_distance{
	arg x,y;
	var out;
	^x.sum({|e,i|
		var out =e-y[i];
		out.pow(2);
	}).sqrt;
}
}