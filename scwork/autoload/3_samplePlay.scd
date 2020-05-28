if(
	q.bufDict .notNil){

	Ndef(' sample', { |buf=10, rate=1, amp=1, loop=0|
		PlayBuf.ar(1, buf, rate, loop).madd(amp).dup;
	} ).play;

	/*
	Ndef(' sample').set(\buf, q.bufDict.short.choose.bufnum.postln).send;
	Ndef(' sample').set(\rate, exprand(1/3, 3) * [1,1,1].choose).send;
	*/

}{

	{	Saw.ar( XLine.kr(5000, 150, 2, 1,0,2))
		* Blip.ar(8, 8, 15).clip(0, 1) ! 2
	}.play

}