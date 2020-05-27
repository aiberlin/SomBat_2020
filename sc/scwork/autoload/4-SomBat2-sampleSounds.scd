
// sample sounds /////////////////////////////////////////////////
// all sounds = mono dup'd to Stereo!
(

// gather BufNums for correct Specs
q.bufNums = ();
q.bufNums.short = ( q.bufDict.short.collect(_.bufnum)  ).sort;
q.bufNums.long = ( q.bufDict.long.collect(_.bufnum)  ).sort;
q.bufNums.all = ( q.bufNums.short ++ q.bufNums.long ).sort;

Spec.add(\buf, [q.bufNums.all.first, q.bufNums.all.last, 0, 1]);
// Spec.add(\gateSomBat, \unipolar);


Ndef('sampleJoy', { |buf=0, gateSomBat=0, loop=0|
	var rate   = Ndef(\joystick).kr(1, 0).linexp(0,1, 1/3, 3);       // X
	var amp = Ndef(\joystick).kr(1, 1).squared; // Y

	PlayBuf.ar(1, buf, rate, 1, 0, loop).madd(amp * gateSomBat * Ndef(\ampBus).kr(1) ).dup;
} );



Ndef('sampleJoyLoop', { |buf=0, gateSomBat=0|
	var rate   = Ndef(\joystick).kr(1, 0).linexp(0,1, 1/3, 3);       // X
	var loopSpeed = Ndef(\joystick).kr(1, 1).linexp(0,1, 0.3, 3);    // Y
	var imp = Impulse.kr(loopSpeed);

	PlayBuf.ar(1, buf, rate, imp, 0, 0).madd(gateSomBat * Ndef(\ampBus).kr(1) ).dup;
} );



Ndef('sampleJoyLoop2', { |buf=0, gateSomBat=0|
	var rate   = Ndef(\joystick).kr(1, 0).linexp(0,1, 1/3, 3);       // X
	var dur = BufDur.kr(buf) / rate;
	var loopSpeed = Ndef(\joystick).kr(1, 1).linexp(0,1, 1/8, 4);    // Y
	var imp = Impulse.kr((loopSpeed / dur));

	var snd = PlayBuf.ar(1, buf, rate, imp, 0, 0);
	snd = LeakDC.ar(snd);
	snd.madd(gateSomBat * Ndef(\ampBus).kr(1) ).dup;
} );

Ndef('sampleJoyLoopCut', { |buf=0, gateSomBat=0|
	var cutFrames  = Ndef(\joystick).kr(1, 0) * BufFrames.kr(buf);       // X
	var dur = BufDur.kr(buf);
	var loopSpeed = Ndef(\joystick).kr(1, 1).linexp(0,1, 1/8, 4);    // Y
	var imp = Impulse.kr((loopSpeed / dur));

	var snd = PlayBuf.ar(1, buf, 1, imp, cutFrames, 0);
	snd = LeakDC.ar(snd);
	snd.madd(gateSomBat * Ndef(\ampBus).kr(1) ).dup;
} );




)