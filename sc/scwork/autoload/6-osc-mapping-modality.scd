(
q = q ? ();
q.osc = q.osc ? ();

(
q.desc = MKtlDesc.fromPath("../SomBat-touchosc/touchosc-SomBat.desc.scd".resolveRelative);

q.mktl.free;
q.mktl = MKtl(\sombat, q.desc);
/*
if(q.hasGui){
	q.mkgui = q.mktl.gui;

	// hack to show xygui
	q.sticky = StickView(q.mkgui.parent, Rect(5, 90, 290, 290));
	q.sticky.uview.background = Color.grey(0.5, 0.5);
	// and cross-connect: sticky triggers action
	q.sticky.action_ { |stik| // no work...but OK.
		// stik.value.keep(2).postln;
		q.mktl.elAt(\xy).deviceValueAction_(stik.value.keep(2).biuni);
	};
	// input from OSC sets sticky, no action
	q.mktl.collAt(\xy).groupAction = { |xygroup|
		// tell the elements to do their actions
		xygroup.elements.do { |el| el.doAction };
		// show incoming values on sticky:
		defer { try { q.sticky.value = xygroup.value.unibi } };
	};

	Ndef(\joystick).gui;
};
*/
);

// trace to look what address the touchOSC app sends from:
//OSCFunc.trace(true);
// and turn off tracing.
//OSCFunc.trace(false);
// now, thrace the real thing:
/*
q.mktl.trace;
q.mktl.elementGroup;
q.mktl.postElements;

address: a NetAddr(127.0.0.1, 33889)

*/
// set the address to the one you see in the trace:

if (q.myname == "adc") {
	q.mktl.device.updateSrcDstAddr("127.0.0.1", 9000);
} {
	q.mktl.device.updateSrcDstAddr("127.0.0.1", 52560);
}
);

// python keeps changing sending port nr; so we catch it here:

[
	'/1/xy1',
	'/1/fader1',
	'/1/toggleM',
	'/1/switch1',
	'/1/switch1',
	'/1/trig1',
	'/1/trig2',
	'/1/trig3'
].do{ |tag|

	OSCFunc({ arg x,msg, ad;
	//	 ad.postln;
		 q.mktl.device.updateSrcDstAddr(ad.hostname , ad.port);
	}, tag.asString).oneShot;
};

// ***********************************************************************
// ***********************************************************************
// ***********************************************************************
// set actions

// ***********************************************************************
// ***********************************************************************
(
/// basic continuous ctl > right to Server

q.mktl.elAt(\fader).action = {arg el; Ndef(\ampBus).set(\amp, \amp.asSpec.map(el.value).postln) };
q.mktl.elAt(\xy, \x).action = {arg el; Ndef(\joystick).set(\x, (el.value)) };
q.mktl.elAt(\xy, \y).action = {arg el; Ndef(\joystick).set(\y, (1-el.value)) };
);

// ***********************************************************************
// ***********************************************************************
// client side Button handling, modes!
// q.mktl.elAt(\toggle).value;
(
// ***********************************************************************
// 1. toggle for modes
q.osc.mode = \synthe;
// something modl here ... schlau MFdef...
q.mktl.elAt(\toggle).action = {arg el;
	if(el.value < 1)
	{
		q.osc.mode = \synthe;
		MFdef(\trigs).mode_(\synthe);
		// MFdef(\led).mode_(\synthe);
		MFdef(\ledToggler).value(q.osc.mode);
	}
	{
		q.osc.mode = \sample;
		MFdef(\trigs).mode_(\sample);
		// MFdef(\led).mode_(\sample);
		MFdef(\ledToggler).value(q.osc.mode);
	};
	if(q.verbose){ "q.osc.mode = ".post; q.osc.mode.postln }
};


// q.mktl.elAt(\toggle).value; // trigger to the current button state on startup!

// ***********************************************************************
// 2. switches to navigate samples. Do also RGB LED !
// just set indices for the 2 modes...
q.mktl.elAt(\switch1).action = { arg el;
	if(el.isOn){
		var indx = q.osc.indices[q.osc.mode];
		indx = indx - 1;
		q.osc.indices.put(q.osc.mode, indx);
		if(q.verbose){
			"Switching << LEFT = UP".postln;
			"q.osc.indices[%] = % \n".postf(q.osc.mode, indx);
		};
		if(q.mktl.elAt(\switch2).isOn){ // double click
			q.longones.endAll.value;
			Ndef.all.localhost.do(_.stop);
		};
	}
};
q.mktl.elAt(\switch2).action = { arg el;
	if(el.isOn){
		var indx = q.osc.indices[q.osc.mode];
		indx = indx + 1;
		q.osc.indices.put(q.osc.mode, indx);
		if(q.verbose){
			"Switching >> RIGHT = LO".postln;
			"q.osc.indices[%] = % \n".postf(q.osc.mode, indx);
		};
		if(q.mktl.elAt(\switch1).isOn){ // double click
			q.longones.endAll.value;
			Ndef.all.localhost.do(_.stop);
		};
	}
};




// ***********************************************************************
// 3. triggers to start sounds

// lists of Ndefs to switch thru....
q.osc.ndefs = ();

q.osc.ndefs.synthe = [Ndef('sombat_blip'), Ndef('sombat_sine'), Ndef('sombat_vox'), Ndef(\sombat_noyz), Ndef(\sombat_noyzLP), Ndef('sombat_formanta'), Ndef(\sombat_noyzHP), Ndef(\sombat_imp)];

q.osc.ndefs.sample = [ Ndef('sampleJoyLoopCut'), Ndef('sampleDummy'), Ndef('sampleJoyLoop2') ]; // just keep 3 sample Ndefs


// q.osc.ndefs.synthe.do(_.play); // maybe better use .play/stop in the trig action rather than the gate ??? YES!!!
// q.osc.ndefs.sample.do(_.play); // maybe better use .play/stop in the trig action rather than the gate ??? YES!!!
q.osc.ndefs.synthe.do(_.set(\gateSomBat, 1) );
q.osc.ndefs.synthe.do(_.stop );
q.osc.ndefs.sample.do(_.set(\gateSomBat, 1) );
q.osc.ndefs.sample.do(_.stop );

// indices are switched by the up and down switches (top row left&right) to access more than 3 possible sounds.
q.osc.indices = ();
q.osc.indices.synthe = 0;
q.osc.indices.sample = 0;




// q.mktl.elAt(\trig).do { |trigbut, i|
// 	trigbut.action = {arg el;
// 		if (el.isOn) {
// 			"// trigbut % ON! (ToDo)\n".postf(trigbut.key);
// 		} {
// 			"// trigbut % off (ToDo)\n".postf(trigbut.key);
// 		}
// 	}
// };

q.mktl.elAt(\trig).do{ |el, i|
	el.action = { MFdef(\trigs).value(el, i) }
}; // generalize!

(
MFdef(\trigs, [
	\test,  { arg el, i; ["test mode", i, el.value].postcln; },
]);
);
MFdef(\trigs).add(\synthe, { arg el, i;
	var maSynth = q.osc.ndefs.synthe.wrapAt( i + q.osc.indices[q.osc.mode] );
	if(q.verbose){
		">>> turnOnOff ** % ** to %\n".postf(maSynth.key, el.value);
	};
	// maSynth.set('gateSomBat', el.value);
	if(el.isOn){ maSynth.send.play; }{ maSynth.stop; };  // modern style
});

MFdef(\trigs).add(\sample, { arg el, i;
	var maSynth = q.osc.ndefs.sample.wrapAt( i ); // just keep 3 sample Ndefs
	var bufIndex = q.osc.indices[q.osc.mode];
	var buf = if(i==1){
		q.bufNums.long.wrapAt(bufIndex)
	}{
		q.bufNums.short.wrapAt((i div: 2) + bufIndex)
	};

	if(q.verbose){
		"> OnOff BufNum % ** % ** to %\n".postf(buf, maSynth.key, el.value.asInteger);
	};
	// maSynth.set('gateSomBat', el.value, 'buf', buf).send;
	if(el.isOn){
		if(i==1){
			q.longones.trigNew(buf);
		};
		maSynth.set('buf', buf).send.play;

	}{ maSynth.stop; };  // modern style
});



// MFdef(\trigs).add(\reset, { arg el, i; { q.mktl.elAt(\trigs)[i].valueAction_(0) }.defer(01.5) });
MFdef(\trigs).add(\reset, { arg el, i; nil });

MFdef(\trigs).modes.put(\test, (off: \all, on: \test));
MFdef(\trigs).modes.put(\sample, (off: \all, on: [\sample, \reset]));
MFdef(\trigs).modes.put(\synthe, (off: \all, on: [\synthe, \reset]));


MFdef(\trigs).mode_(\all);
MFdef(\trigs).mode_(\test);
MFdef(\trigs).mode_(\sample);
MFdef(\trigs).mode_(\synthe);
);
/*// tests
MFdef(\trigs).mode;
MFdef(\trigs).modes;
MFdef(\trigs).orderedNames;

MFdef(\trigs).activeNames.postcs;"";
MFdef(\trigs).activeFuncs.postcs;"";

q.mktl.elAt(\trigs)[0].valueAction_(1);
q.mktl.elAt(\trigs)[0].valueAction_(0);

MFdef(\trigs).value(1, 1);
MFdef(\trigs).value(1, 0);
q.mktl.elAt(\trigs)[1].valueAction_(1);
q.mktl.elAt(\trigs)[1].valueAction_(0);

q.mktl.elAt(\trigs)[2].valueAction_(1);
q.mktl.elAt(\trigs)[2].valueAction_(0);
*/