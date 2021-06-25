
~secs=5;
~rowsec= (44100/1024).floor;
~totalSamples=~rowsec*~secs*1024;
~totalrows=(~totalSamples/1024).ceil;
(215*1024)/44100
~bb = Buffer.alloc(s, ~totalSamples; );
43*30

(

var query = "SELECT data FROM Frames where runID = 1 and ORDER BY rowNumber ASC LIMIT %".format();

var command="sqlite3 DBv3.db \"%\"".format(query);
~pipe = Pipe(command,"r");
)
~pipe.getLine;
~test=~pipe.readUpTo($@)
~test2=~pipe.readUpTo($@)
~test.split($,).collect({|e|e.asFloat;}).size;
~test2.split($,).collect({|e|e.asFloat;}).size;
~test == ~test2;
~test2.split($,).size;

(
~bb={ var countquery = "SELECT count(id) FROM Frames where runID = 1 and segment=7;";
	var count;
	var query = "SELECT data FROM Frames where runID = 1 and segment=7 ORDER BY rowNumber ASC;".format(~totalrows);

	var command="sqlite3 DBv3.db \"%\"".format(query);
	var pipe = Pipe(command,"r");
	// var pipe = Pipe(command,"r");
	var l = pipe.readUpTo($@);
	var offset = 0;
	var b;
	count="sqlite3 DBv3.db \"%\"".format(countquery).unixCmdGetStdOut;
	b=Buffer.alloc(s, count.asInteger*1024);
	"before".postln;
	while({l.notNil},{
		b.setn((offset*1024),l.split($,).collect({|e| e.asFloat;}));
		l = pipe.readUpTo($@);
		offset = offset+1;
	});
	"done".postln;
}.value;
)
s.meter;
~bb.play;
Synth(\default, [\amp, 1, \freq, 440]).free

(
var query = "SELECT quote(data) FROM Frames where rowNumber between 150 and 200 ORDER BY rowNumber ASC";
var lines="sqlite3 DBv3.db \"%\"".format(query).unixCmdGetStdOut();
var cl, fl;
// var pipe = Pipe("sqlite3 DBv3.db \"%\"".format(query), "r");
var splitlines=lines.split($X);
var offset=0;
splitlines.do({arg line, linei;
	if( line.size>8, {
		    "doing line %".format(linei).postln;
			line.removeAt(0); // the apostrophe
			line.clump(8).do({ arg word, i;
				var fl;
				word=word.replace("\n","");
				fl=Float.from32Bits(word.hexToInt);
				// fl.postln;
				// ~bb.set(offset+i,fl);
			});
		});
	offset = offset+1024;
});
"done".postln;
)
