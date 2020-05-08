// synthe sounds /////////////////////////////////////////////////
// all sounds = mono dup'd to Stereo!
(
Spec.add(\gateSomBat, \unipolar);

Ndef(\sombat_blip, { |gateSomBat=0, freqMin=1.5, freqMax=2500|
	var snd;
	var bw   = Ndef(\joystick).kr(1, 0).linexp(0,1, 200, 20000);
	var freq = Ndef(\joystick).kr(1, 1).linexp(0,1, freqMin, freqMax);
	var numharm = bw / freq;
	// snd = Blip.ar(freq * [1, 1.01, 0.99, 1.002], numharm).sum;
	// snd = Blip.ar(freq, numharm);
	snd = Blip.ar(freq, numharm, 2).distort;
	snd
	* Ndef(\ampBus).kr(1)
	//	* Ndef(\ons).kr(1, 0)
	* gateSomBat
	! 2 ;
});



Ndef(\sombat_sine, {|gateSomBat=0|
	var dur  = Ndef(\joystick).kr(1,0).linexp(0,1, 0.01, 10);
	var symm = Ndef(\joystick).kr(1,1);
	var gateInt = gateSomBat; // Ndef(\ons).kr(1, 2);
	var freq = EnvGen.ar(Env.perc(1-symm, symm, 1, 0), gateInt, timeScale: dur).linexp(0,1, 20, 10000);
	var snd = HPF.ar(SinOsc.ar(freq), 40, (freq > 30).lag(0.01));
	snd
	* Ndef(\ampBus).kr(1)
	! 2;
});


Ndef(\sombat_vox, {|gateSomBat=0, freqMin=3, freqMax=2500|
	var blend = Ndef(\joystick).kr(1,0).lag(0.1);
	var modV = LFNoise1.kr([0.3, 2]).range(1, -2.midiratio).product;
	var freQ = Ndef(\joystick).kr(1,1).pow(1.2).linexp(0,1,  freqMin, freqMax)
	.cpsmidi.round(5).lag(0.1, 1.5).midicps
	; //* LFNoise1.kr([0.08, 1]).range(1, 0.3.midiratio).product;
	var voxes = [
		Formants.ar(freQ, Vowel(\i, \bass) * modV) * 1.5,
		Formants.ar(freQ, Vowel(\a, \soprano) * modV),
		Formants.ar(freQ, Vowel(\e, \bass) * modV),
		Formants.ar(freQ, Vowel(\u, \soprano) * modV),
		Formants.ar(freQ, Vowel(\a, \bass)*2.25) * 2
	];
	var outsig = SelectXFocus.ar(blend * (voxes.size-1), voxes, 0.5);

	Limiter.ar(
		LeakDC.ar(outsig)
		// Ndef(\ons).kr(1, 1)
		* gateSomBat
		* AmpComp.kr(freQ*2).madd(0.5).clip(0, 1).pow(0.3),
		0.98
	)
	* Ndef(\ampBus).kr(1)
	! 2
});


Ndef(\sombat_noyz, {|gateSomBat=0|
	var blend = Ndef(\joystick).kr(1,0).lag(0.1);
	var filtIn  = Ndef(\joystick).kr(1,1);
	var gateInt = gateSomBat;
	var nz = WhiteNoise.ar;
	var flt = filtIn.linexp(0, 1,  130,  14000);
	var voxes = [
		RLPF.ar( nz, flt ),
		nz,
		RHPF.ar( nz, flt );
	];
	var snd = SelectXFocus.ar(blend * (voxes.size - 0.5 ), voxes, 1.001);

	Limiter.ar(snd*2.5)
	* Ndef(\ampBus).kr(1)
	* gateSomBat
	! 2;
});



Ndef(\sombat_noyzLP, {|gateSomBat=0|
	var rq = Ndef(\joystick).kr(1,0).lag(0.1).linexp(0, 0.8, 2, 0.05);
	var filtIn  = Ndef(\joystick).kr(1,1);
	var gateInt = gateSomBat;
	var nz = WhiteNoise.ar;
	var flt = filtIn.linexp(0, 1,  130,  15000);
	var fltSig = RLPF.ar( nz, flt , rq );

	Limiter.ar(fltSig*1.5, 0.95)
	* Ndef(\ampBus).kr(1)
	* gateSomBat
	! 2;
});


Ndef(\sombat_noyzHP, {|gateSomBat=0|
	var rq = Ndef(\joystick).kr(1,0).lag(0.1).linexp(0, 0.8, 2, 0.05);
	var filtIn  = Ndef(\joystick).kr(1,1);
	var gateInt = gateSomBat;
	var nz = WhiteNoise.ar;
	var flt = filtIn.linexp(0, 1,  130,  15000);
	var fltSig = RHPF.ar( nz, flt , rq );

	Limiter.ar(fltSig*1.5, 0.95)
	* Ndef(\ampBus).kr(1)
	* gateSomBat
	! 2;
});



Ndef(\sombat_imp, {|gateSomBat=0|
	var speed = Ndef(\joystick).kr(1,0).lag(0.1).lincurve(0, 1, 1/5, 20, 4);
	var width  = Ndef(\joystick).kr(1,1).pow(4);
	var gateInt = gateSomBat;
	var nz = WhiteNoise.ar;
	var pulse = LFPulse.ar(speed, 0, width).lag(1/5000);
	var sig = nz * pulse;


	Limiter.ar(sig * 1.5, 0.95)
	* Ndef(\ampBus).kr(1)
	* gateSomBat
	! 2;
});


(
Ndef('sombat_formanta', { |gateSomBat=0|
	var mainFr = Ndef(\joystick).kr(1,1).lag(0.2, 2).linexp(0,1, 1/3, 200) * [1, Rand(1/1.02, 1.02)];
	var ffr = Ndef(\joystick).kr(1,0).lag(0.1).linexp(0,1, 180, s.sampleRate/2/3);
	var bw =
		LFTri.kr(Rand(1/20, 1/60), Rand(0.0, 4) + [0, Rand(-1, 1)])
		.range(ffr / 100, ffr*3);
	var sig = HPF.ar(
		Formant.ar(
			mainFr,
			[ffr, DelayN.kr(ffr.lag3(4), 5, 5)],
			bw.round,
			0.75
		),
		30//, [-1,1]
	);
	Limiter.ar(sig.sum)
	* Ndef(\ampBus).kr(1)
	* gateSomBat
	! 2

});
);


);
