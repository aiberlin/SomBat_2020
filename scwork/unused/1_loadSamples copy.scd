// 1_loadSamples

var twoWays = ["long", "short"];
var twoPaths, twoPathsExist, foldersThere = false;

q.bufDict = ();

twoPaths = twoWays.collect{|p| q.baseSamplePath +/+ p };

twoPathsExist = twoPaths.collect{|p| File.exists(p.postln) };
foldersThere = twoPathsExist.collect(_. binaryValue).sum > 0;

if( foldersThere ){
	var sfpaths, bufList;
	"cool: Sample path // USB Stick present!".postln;
	twoWays.collect{ |folda, i|
		//var sfpaths, bufList;
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
			bufList = sfpaths.collect{|p|
				Buffer.readChannel(s, p, channels: [0], action: {|buf| buf.normalize});
			};
			q.bufDict.put(folda.asSymbol, bufList);
		}{
			"sorry, no sound files in folder \"%\"!".format(folda).warn;
		};
	};

}{
	"sorry, no Sample path // USB Stick present!".error;
	q.bufDict = nil;
};

/*
q.bufDict.short[2].plot;
*/