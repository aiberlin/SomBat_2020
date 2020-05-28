q.led = ();

if(q.hasGui){
	// q.led.win = Window.new.front;
	// q.led.uv = UserView(q.led.win, Rect(0, 0, 400, 400));
	q.led.uv = Window.new.front;
};

Tdef(\led).set(\dt, 1/50);
Tdef(\led).set(\dt, 1/(100/3));
Tdef(\led).set(\num, 9);
Tdef(\led).addSpec(\num, [2, 20, 0, 1] );
Tdef(\led).addSpec(\state, [0, Tdef(\led).get(\num), 0, 1] );
Tdef(\led).set(\state, 0);
Tdef(\led).set(\colOffs, 0);
Tdef(\led).set(\bright, 1);
Tdef(\led).set(\red, 1);
Tdef(\led).set(\green, 1);
Tdef(\led).set(\blue, 1);
Tdef(\led).addSpec(\bright, [0, 1] );
Tdef(\led).addSpec(\blue, [0, 1] );
Tdef(\led).addSpec(\green, [0, 1] );
Tdef(\led).addSpec(\red, [0, 1] );

/*
(
Tdef(\led, {|ev|
var colsF = {
ev.num.collect{|i|
Color.hsv(i/ev.num + ev.colOffs, 1,1,1);
};
};
var cols = colsF.();
loop{
var col = cols @@ ev.state.asInteger;
defer{ q.led.uv.background_(col) };
ev.dt.wait;
}
});
);




(
Tdef(\led, {|ev|
var colsF = {
ev.num.collect{|i|
Color.hsv(i/ev.num + ev.colOffs, 1,1,1);
};
};
var col, cols = colsF.();
loop{
col = cols @@ ev.state.asInteger;
defer{ q.led.uv.background_(col) };
2.wait;
col = cols @@ (ev.state.asInteger + 1);
defer{ q.led.uv.background_(col) };
0.5.wait;
col = cols @@ (ev.state.asInteger + 2);
defer{ q.led.uv.background_(col) };
0.5.wait;

// ev.dt.wait;
}
});
);
*/

// now, sample dis slowly....trapeziod wave
Ndef(\ledKrSynth, {	LFTri.kr(1/8).range(-2.5, 2).clip(0, 2).round.lag3(0.8);  });

Ndef(\ledKrSamp, {	LFPulse.kr(1/2, 0, 0.03, 3).lag3(0.2);  });// lighten additive

Ndef(\ledKrSamp, {	LFPulse.kr(1/2, 0, 0.06).neg.lag3(0.2);  });// darken additive

if(q.hasGui){
	Tdef(\led).gui;
	Ndef(\ledKrSynth).scope;
};


Tdef(\led).play;


(
Tdef(\led, {|ev|
	var huesF = { ev.num.asInteger.collect{|i| i/ev.num.asInteger + ev.colOffs } };
	var oldCol = Color.black;
	var cIndex, col, hues = huesF.();
	loop{
		var strobe = Ndef(\ledKrSamp).bus.getSynchronous.round(1/360);
		cIndex = Ndef(\ledKrSynth).bus.getSynchronous.round(1/360) / ev.num;
		col = Color.hsv(hues @@ ev.state + cIndex % 1, 1,1,1);
		//		col = Color.fromArray( (col.asArray.keep(3) * strobe).clip(0,1) );//to black
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
// change from synth to sampl: add strobe AND change nr of hues / state!


(
MFdef(\led, [
	\test,  { arg col;  col.postln },
]);

if(q.hasGui){
	MFdef(\led).add(\gui, { arg col, i; defer{ q.led.uv.background_(col) }; });
};

MFdef(\led).add(\pythonOSC, { arg col;
	NetAddr("127.0.0.1", 9999).sendMsg(\rgb_led, *col.asArray.keep(3) );
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
