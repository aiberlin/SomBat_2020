(
Tdef(\setJoy, {|ev|
	loop{

		Ndef(\joystick).set(
			\x, q.mktl.elAt(\xy, \x).value,
			\y, q.mktl.elAt(\xy, \y).value
		);

		(1/40).wait;
	}
});
);

Tdef(\setJoy).play;