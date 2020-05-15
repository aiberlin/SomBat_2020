q.led = ();
q.led.addr = NetAddr("127.0.0.1", 9999); // Python...

if(q.hasGui){
	// q.led.win = Window.new.front;
	// q.led.uv = UserView(q.led.win, Rect(0, 0, 400, 400));
	q.led.uv = Window.new.front;
};

Tdef(\led).set(\dt, 1/50);
Tdef(\led).set(\dt, 1/(100/3));
Tdef(\led).set(\num, 8);
Tdef(\led).addSpec(\num, [2, 100, 4, 1] );
Tdef(\led).addSpec(\state, [0, Tdef(\led).get(\num), 0, 1] );
Tdef(\led).set(\state, 0);
Tdef(\led).set(\colOffs, 0);
Tdef(\led).set(\bright, 1);
Tdef(\led).set(\red, 1);
Tdef(\led).set(\green, 1);
Tdef(\led).set(\blue, 1);
Tdef(\led).addSpec(\bright, [0, 1, -2] );
Tdef(\led).addSpec(\blue, [0, 1] );
Tdef(\led).addSpec(\green, [0, 1] );
Tdef(\led).addSpec(\red, [0, 1] );


// now, sample dis slowly....trapeziod wave
Ndef(\ledKrFade, {	LFTri.kr(1/8).range(-2.5, 2).clip(0, 2).round.lag3(0.8);  });
// Ndef(\ledKrSamp, {	LFPulse.kr(1/2, 0, 0.03, 3).lag3(0.2);  });// lighten additive
Ndef(\ledKrSamp, {	LFPulse.kr(1/2, 0, 0.06).neg.lag3(0.2);  });// darken additive

if(q.hasGui){
	Tdef(\led).gui;
	Ndef(\ledKrFade).scope;
};



(
Tdef(\led, {|ev|
	var col, oldCol = Color.black;

	loop{
		var strobe = Ndef(\ledKrSamp).bus.getSynchronous.round(1/360);
		var cIndex = Ndef(\ledKrFade).bus.getSynchronous.round(1/360) / ev.num;
		var state = q.osc.indices[q.osc.mode];
		var hue = state % ev.num / ev.num;
		col = Color.hsv(hue + cIndex % 1, 1,1,1);
		col = col.asArray.keep(3);

		if(q.osc.mode == \sample){ col = col + strobe; };
		col = (
			col * ev.bright * [ev.red, ev.green, ev.blue] // ext mix
		).clip(0, 1);
		col = Color.fromArray(col);

		if(oldCol != col){ // save bandwidth
			MFdef(\led).value(col);
			//".".postc;
		};
		ev.dt.wait;
		oldCol = col
	}
});
);

Tdef(\led).play;

// change from synth to sampl: add strobe AND change nr of hues / state

(
MFdef(\ledToggler, [
	\test,  { arg col; col.postln },
]);

MFdef(\ledToggler).add(\run, { arg mode;
	var num = if(mode== \synthe){
		q.osc.ndefs.synthe.size;
	}{
		q.bufNums.short.size;
	};
	Tdef(\led).set(\num, num);
});

MFdef(\ledToggler).disable(\test);

);

(
MFdef(\led, [
	\test,  { arg col; col.postln },
]);

if(q.hasGui){
	MFdef(\led).add(\gui, { arg col, i; defer{ q.led.uv.background_(col) }; });
};

MFdef(\led).add(\pythonOSC, { arg col;
	q.led.addr.sendMsg(\rgb_led, *col.asArray.keep(3) );
});


MFdef(\led).modes.put(\test, (off: \all, on: \test));
MFdef(\led).modes.put(\gui, (off: \all, on: [\gui]));
MFdef(\led).modes.put(\pythonOSC, (off: \all, on: [\pythonOSC]));

MFdef(\led).mode_(\all);
MFdef(\led).mode_(\test);
MFdef(\led).mode_(\sample);
MFdef(\led).mode_(\synthe);

if(q.hasGui){
	MFdef(\led).mode_(\gui);
}{
	MFdef(\led).mode_(\pythonOSC);
};

);


//
