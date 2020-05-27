//autostart in     ~/.config/lxsession/LXDE-pi/autostart

// Ndef(' formanta', {Formant.ar([11,11.0], [200, 2333], 100) } ).play;
{
	var l = Line.kr(1,0,10,doneAction:2);
	Formant.ar([15,15.1] *(l+1).pow(1.7), [200, 2333]*0.5*(l+1), 100) * l.squared
}.play;

(
Ndef(' formanta2', {
	var ffr = LFTri.kr(1/100, Rand(0.0, 1)).exprange(180, 3500) + [1,0];
	var bw = 	(ffr * LFTri.kr(1/16, Rand(0.0, 1)).exprange(0.5, 10));
	HPF.ar(
		Formant.ar(
			LFTri.kr(1/200	, Rand(0.0, 1)).exprange(1/3, 100) * [1,1.01],
			ffr,
			bw,
			0.75
		),
		30
	)
} ).play;
);

Ndef(' formanta2').fadeTime = 8;

Tdef(\texture, {
	loop{
		rrand(20, 120).wait;
		"** re-seeding texture **'".postln;
		Ndef(' formanta2').send;
	}
}).play;

