(
~bb={
	|runID, segment, n|
	var countquery = "SELECT count(id) FROM Frames where runID = % and segment between % and %;".format(runID, segment, segment+n);
	var query = "SELECT quote(data) FROM Frames where runID = % and segment between % and % ORDER BY rowNumber ASC;".format(runID, segment, segment+n);
	var count;
	var command="sqlite3 DBv2.db \"%\"".format(query);
	var pipe = Pipe(command,"r");
	//to first X
	var l = pipe.readUpTo($X);
	var offset = 0;
	var b;
	//through full frame
	l = pipe.readUpTo($X);

	count="sqlite3 DBv2.db \"%\"".format(countquery).unixCmdGetStdOut;
	b=Buffer.alloc(s, count.asInteger*1024);
	"before".postln;

	while({l.notNil},{
		var clumps;

		l=l.tr($',$ );
		l=l.stripWhiteSpace;
		clumps =  l.clump(8).collectAs({ |clump|
			//hexToInt here relies on big endian
			Float.from32Bits(~hexToInt.value(clump));
			// Float.from32Bits(clump.hexToInt);
		}, FloatArray);
		b.setn((offset*1024),clumps);
		// b.setn((offset*1024),l.split($,).collect({|e| e.asFloat;}));
		// l = pipe.readUpTo($@);
		l = pipe.readUpTo($X);
		// l.tr($',"");
		offset = offset+1;
	});
	"done".postln;
	b;
}.value(15,22,1);
)
~bb.play;
Synth(\default, [\amp, 1, \freq, 440])


(
~hexToInt= {
	// assumes each character of string is a valid hex digit (0-9, A-F)
	// doesn't handle negatives
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
)
