{
	var l = Line.kr(1, 0, 20, doneAction:2 );
	Formant.ar([10,15.1] * (1-l+1*2).pow(1.7), [2333, 200]*0.5*(1-l+1), 100).sum / 3 * l.squared ! 2
}.play;


// play samples for startup!

if(
	q.bufDict .notNil){

	Ndef(' sample', { |buf=10, rate=1, amp=1, loop=0|
		PlayBuf.ar(1, buf, rate, loop).madd(amp * Ndef(\ampBus).kr(1) ).dup;
	} ).play;

	/*
	Ndef(' sample').set(\rate, exprand(1/3, 3) * [1,1,1].choose).send;
	*/

	fork{
		1.wait;
		10.do{
			Ndef(' sample').set(
				\rate, exprand(1/3, 3) * [1,1,1].choose,
				\buf, q.bufDict.short.choose.bufnum
			).send;
			2.wait;
		};
		Ndef(' sample').clear;
	};
}{

	// fail sound
	{	Saw.ar( XLine.kr(5000, 150, 2, 1,0,2)).lag(1/2000)
		* Blip.ar(8, 8, 15).clip(0, 1) ! 2
	}.play;

}