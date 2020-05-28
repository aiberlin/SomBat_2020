
// sample sounds /////////////////////////////////////////////////
// all sounds = mono dup'd to Stereo!

/*
for middle button

ToDo:

- SynthDef for granular
- a List of currently active sounds

*/
(

Ndef('sampleDummy', { |buf=0, gateSomBat=0|
	Silent.ar(2)
} );


SynthDef(\sampGrain2, { |out, buf, amp=0.1, rate = 1, stretchGrn=1, pan=0, ovlp = 18, trigrate=60, jitter=0.001|
	var bdur = BufDur.ir(buf);
	var trig = Dust.ar(trigrate);
	var pos  = Line.ar(0, bdur, bdur * stretchGrn, doneAction: 2) + TRand.ar(jitter.neg, jitter, trig).madd(bdur);
	var snd  = TGrains.ar(2, trig, buf, rate, pos, trigrate.reciprocal*ovlp, pan, amp );
	OffsetOut.ar(out, snd
		* EnvGate.new
		* Ndef('ampBus').kr
	);
}).add;

SynthDef(\sampGrainTime, { |out, buf, amp=0.1, rate = 1, time=10, pan=0, ovlp = 12, gdur=0.3, trigrate=60, jitter=0.001|
	var bdur = BufDur.ir(buf);
	var trig = Dust.ar(trigrate);
	var pos  = Line.ar(0, bdur, time, doneAction: 2) + TRand.ar(jitter.neg, jitter, trig).madd(bdur);
	var snd  = TGrains.ar(2, trig, buf, rate, pos, /*trigrate.reciprocal*ovlp*/ gdur, pan, amp );
	OffsetOut.ar(out, snd);
}).add;
);


/*
(instrument: \sampGrainTime, buf: q.bufNums.long.choose, amp: 1/2, rate: 0.9, time: 10, ovlp: 50, trigrate: 100, jitter:0.01).play;

(instrument: \sampGrainTime, buf: q.bufNums.long.choose, amp: 1/2, rate: 0.9, time: 10, gdur: 0.3, jitter:0.01).play;

(instrument: \sampGrainTime, buf: q.bufNums.long.first, amp: 1/2, rate: 1.2, time: 25, gdur: 0.3, jitter: 0.0).play;

(instrument: \sampGrainTime, buf: q.bufNums.long.first, amp: 1/2, rate: 1.2, time: 2).play;

(instrument: \sampGrainTime, buf: q.bufNums.long.choose, amp: 1/2, rate: 1.2, time: 30).play;

(instrument: \sampGrain2, buf: q.bufNums.long.choose, amp: 1/2, rate: exprand(0.5, 2), stretchGrn: 1/3).play;
*/

q.longones = ();
q.longones.list = List[];
(
q.longones.trigNew = {|ev, buf=100, b|
	var rate = q.mktl.elAt(\xy, \x).value.linlin(0,1, -16, 16).round(0.5).midiratio;
	var stretchGrn = (q.mktl.elAt(\xy, \y).value.unibi.cubed*8).midiratio;
	var sy = (instrument: \sampGrain2, buf: buf, amp: 1/2, rate: rate, stretchGrn: stretchGrn, sustain: 999 /*, out: Ndef('sampleThru').bus */).play;
	 sy.map(\amp, Ndef(\ampBus)); // dont work!
	q.longones.list.add(sy);
	sy
};

q.longones.endAll = {|ev|
	q.longones.list.do{|sy| sy.release(2) };
	q.longones.list.clear;
};

);
/*
q.longones.trigNew(100 + 10.rand);
q.longones.endAll.value;
q.longones.list
*/