OSCFunc.trace(true, true);
OSCFunc.trace(false);
NetAddr.localAddr.port;

(
Tdef(\testt, {|ev|

	loop{
		q.mktl.elementsDict.keys.asArray.sort
		.do{|elkey|
			var val = 	(q.mktl.elAt(elkey).value);
			"%: \t%.\t".postf(elkey, val);
		};
		"joy: ".post; (q.mktl.elAt(\xy).value).round(0.0001).post;
		"  trig: ".post; (q.mktl.elAt(\trig).value).postln;
		(q.mktl.elAt(\toggleM).value);

		"\n\n".post;
		//			(q.mktl.elAt(\xy, \y).value);
		1.0.wait;
	}
});
);


Tdef(\testt).stop;
// Tdef(\testt).play;

/*
// Modality:
accel_x: 	nil.	accel_y: 	nil.	accel_z: 	nil.
fader: 	0.0.
switch1: 	0.0.	switch2: 	0.0.
toggle: 	0.0.
trig_1: 	nil.	trig_2: 	nil.	trig_3: nil.
xy_x: 	nil.	xy_y: 	nil.

*/

// OSC from Py:
[
	"1/trig1",
	"1/trig2",
	"1/trig3",
	"1/switch1", // das kommt nicht!
	"1/switch2",
	"1/toggleM"
];
// so, lets rewrite everything in 6 to
MFdef;