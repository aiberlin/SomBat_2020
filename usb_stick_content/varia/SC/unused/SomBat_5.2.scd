 "/*********************
SomBat 1 BELA code.
Has AnalogIn Ugens we don't habve for ver.2 on RPI!
ver 4: as demoe'd in Radiçe
ver 5: all 3 active; trigger each one on a separate key
ver 5.2: onboard tweaks

*/".postln;

s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;

s.options.sampleRate = 88200;
s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;
s.options.postln;

s.waitForBoot({
	"\n\n\n//////////////////////////////////////////////// starting SomBat 5.2 \n".postf;
	(
		Tdef(\grpz, {
			5.do { |i|
				var wo = i;
				var range = rrand(0.05, 0.2);
				var hoch = rrand(600, 1000);
				20.do{ |j|
					(
						amp: 0.4,
						\dur: 0.025,
						freq: ( (j+1*range) * 10 *  hoch).round
					).play;
					0.1.wait;
				};
				1.wait;
			}
		}).play;
	);

	// I/F ////////////////////////////////////////////////
	// joystick; hand calibrated.
	Ndef(\controls, {|a, b|
		var in = AnalogIn.kr( [0, 1] );
		in[0] = (in[0] - 0.112 * 0.60.reciprocal).clip(0,1); // x
		in[1] = 1 - (in[1] - 0.112 * 0.55.reciprocal).clip(0,1); // y
		in
	});
	Ndef(\ons, { (1-DigitalIn.kr( [6,7,10] ).lag(0.05) ) } );

	/*	Ndef(\on, { (1-DigitalIn.kr( 7 ).lag(0.05) ) } );
	Ndef(\upDown, {
	var ons = ((DigitalIn.kr( [6, 10] ).lag(0.05)) < 0.1);
	SendReply.kr(ons[0], '/but1', 1, 1111);
	SendReply.kr(ons[1], '/but2', 1, 2222);
	ons
	} );
	*/




	// sounds /////////////////////////////////////////////////


	Ndef(\sombat_blip, {
		var freq = Ndef(\controls).kr(1,1).linexp(0,1, 2, 3000);
		var bw = Ndef(\controls).kr(1,0).linexp(0,1, 200, 20000);
		var numharm = bw / freq;
		var snd = Blip.ar(freq, numharm);
		snd ! 2 *
		Ndef(\ons).kr(1, 0);
	});

	Ndef(\vox, {
		var blend = Ndef(\controls).kr(1,0).lag(0.2);
		var modV = LFNoise1.kr([0.3, 2]).range(1, -2.midiratio).product;
		var freQ = Ndef(\controls).kr(1,1).pow(1.2).linexp(0,1,  6, 3000).cpsmidi.round(5).lag(0.2, 2).midicps
		* LFNoise1.kr([0.8, 6]).range(1, 0.3.midiratio).product;
		var voxes = [
			Formants.ar(freQ, Vowel(\i, \bass) * modV) * 1.5,
			Formants.ar(freQ, Vowel(\a, \soprano) * modV),
			Formants.ar(freQ, Vowel(\e, \bass) * modV),
			Formants.ar(freQ, Vowel(\u, \soprano) * modV),
			Formants.ar(freQ, Vowel(\a, \bass)*2.25) * 2
		];
		var outsig = SelectXFocus.ar(blend * voxes.size, voxes, 0.5).tanh;
		LeakDC.ar(outsig)  *
		Ndef(\ons).kr(1, 1)
		! 2
	});



	Ndef(\sombat_sine, {
		var dur = Ndef(\controls).kr(1,0).linexp(0,1, 0.01, 10);
		var symm = Ndef(\controls).kr(1,1);
		var gate = Ndef(\ons).kr(1, 2);
		var freq = EnvGen.ar(Env.perc(1-symm, symm, 1, 0), gate, timeScale: dur).linexp(0,1, 20, 10000);
		var snd = HPF.ar(SinOsc.ar(freq), 40, (freq > 30).lag(0.01));
		snd ! 2 * gate;
	});


	/*	Ndef(\sombat_dirac, {
	var dur = Ndef(\controls).kr(1,0).linexp(0,1, 0.01, 10);
	var symm = Ndef(\controls).kr(1,1);
	var gate = Ndef(\ons).kr(1, 1);
	var freq = EnvGen.ar(Env.perc(1-symm, symm, 1, 0), gate, timeScale: dur).linexp(0,1, 1/20, 8000);
	var snd = Trig.ar(
	Impulse.ar(freq),
	freq.reciprocal * LFNoise1.kr(0.1).range(0.25, 0.75)
	);
	snd ! 2
	* gate;
	});*/


	// client side: ////////////////////////////////////////////////
	~snds = [\sombat_blip, \vox, \sombat_sine];
	~index = 0;
/*
	~switchFunc = { |inc=1| var curPx;
		~index = ~index + inc;
		(~snds.size - 1).do{|j| Ndef(~snds.wrapAt(~index + j)).pause };
		curPx = ~snds.wrapAt(~index);
		postf("activating Ndef %", curPx);
		Ndef(curPx).resume;
	};

	OSCdef(\but1, { |msg| msg.postln; ~switchFunc.(1)  }, '/but1').permanent_(true);
	OSCdef(\but2, { |msg| msg.postln; ~switchFunc.(-1) }, '/but2').permanent_(true);
*/
	// init
	{
		~snds.do{ |snd| Ndef(snd).play };
		//		Ndef(\sombat_blip).resume;
	}.defer(0.5)


});