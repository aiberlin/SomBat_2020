if(q.hasGui){
	NdefMixer(s);
//	s.scope;
};


// I/F /////////////////////////////////////////////////
// joystick; o be set by OSCHandlers via Modality
Ndef(\joystick, {|x=0.5, y=0.5|
	// do autocal here...
	x = (x).clip(0,1); // x
	y = (y).clip(0,1); // x
	[x, y]
});
Ndef(\joystick).addSpec(\x, \unipolar);
Ndef(\joystick).addSpec(\y, \unipolar);

Ndef(\ons, { |trig1, trig2, trig3| [trig1, trig2, trig3].lag(0.05) } );
Ndef(\ons).addSpec(\trig1, [0,1,0,1]);
Ndef(\ons).addSpec(\trig2, [0,1,0,1]);
Ndef(\ons).addSpec(\trig3, [0,1,0,1]);

Ndef(\ampBus, { |amp=0.5, lag=0.15| amp.lag(lag) } );
Ndef(\ampBus).addSpec(\amp, \unipolar);

