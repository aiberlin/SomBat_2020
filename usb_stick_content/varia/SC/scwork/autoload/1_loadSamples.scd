// 1_loadSamples

var twoPaths, twoPathsExist, foldersThere = false;

q.twinFolders = ["long", "short"];
q.bufDict = ();

twoPaths = q.twinFolders.collect{|p| q.baseSamplePath +/+ p };

twoPathsExist = twoPaths.collect{|p| File.exists(p.postln) };
foldersThere = twoPathsExist.collect(_. binaryValue).sum > 0;

if( foldersThere ){
	var sfpaths, bufList;
	"cool: Sample path // USB Stick present!".postln;
	q.twinFolders.collect{ |folda, i|
		sfpaths = [];
		sfpaths = (q.baseSamplePath +/+ folda +/+ "/*").postcln.pathMatch.collect{|p|
			var sf = SoundFile.openRead(p);
			if(sf.notNil){
				// load'em!
				var pa = sf.path;
				sf.close;
				pa
			};
		}.select( _.notNil );

		if(sfpaths.notEmpty){
			var bufList = List[];
			q.bufDict.put(folda.asSymbol, bufList);
			/*bufList = */
			sfpaths.collect{|p|
				Buffer.readChannel(s, p, channels: [0], action: {|buf|
					buf.normalize;
					bufList.add(buf)
				});
			};
		}{
			"sorry, no sound files in folder \"%\"!".format(folda).warn;
		};
	};

	if(q.verbose){
		{
		"\n\nCOOL ! loaded the following Samples into .short:\n".postln;
		( q.bufDict.short.collect{|b| b.path.basename }).printAll;
		"\nloaded the following Samples into .long:\n".postln;
		( q.bufDict.long.collect{|b| b.path.basename }).printAll;
		"\n\n".postln;
		}.defer(5); // ugly!!

	};

}{
	"sorry, no Sample path // USB Stick present!".error;
	q.bufDict = nil;
};

/*
q.bufDict.short[2].plot;
*/