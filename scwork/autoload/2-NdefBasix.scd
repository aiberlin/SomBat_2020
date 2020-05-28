if(q.hasGui){
	NdefMixer(s);
//	s.scope;
};


// I/F /////////////////////////////////////////////////
// joystick; o be set by OSCHandlers via Modality
Ndef(\joystick, {|x=0.5, y=0.5|
	// dont autocal here... much better at source!
	x = x.clip(0,1); // x
	y = y.clip(0,1); // x
	[x, y].lag2(1/25)
});
Ndef(\joystick).addSpec(\x, \unipolar);
Ndef(\joystick).addSpec(\y, \unipolar);


// unused....
Ndef(\ons, { |trig1, trig2, trig3| [trig1, trig2, trig3].lag(0.05) } );
Ndef(\ons).addSpec(\trig1, [0,1,0,1]);
Ndef(\ons).addSpec(\trig2, [0,1,0,1]);
Ndef(\ons).addSpec(\trig3, [0,1,0,1]);

// will become modBus!
Ndef(\ampBus, { |amp=0.5, lag=0.15| amp.lag(lag) } );
Ndef(\ampBus).addSpec(\amp, \unipolar);

