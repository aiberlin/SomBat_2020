MKtl
MKtl.update
MKtlDesc("thrustmaster-run-n-drive").openFile;
MKtlDesc.writeCache; // !!!   UPD ATE !!!


MKtlElement.types.printAll;\;


//// ToDo:
- how to fix joystick? has 1 OSC msg w 2 scalars. And which GUI?

- clean up GUI. align VERTICALLY, not Horiz how? rest is OK.
[\button, \key, \switch, \pad]; // check if the 5 momentaries shd be called any of these, rather than "\button".



/////// TEST::
// TouchOSCthe: single page layout "SomBat2" by AirborneInstruments

// INSTRUCTIONS to test:
// * have touchosc and laptop with SC be in the same network

/////// in the touchOSC app,
// * set OSC host ip to the laptops IP, as seen in network settings,
//    e.g. 192.168.178.51
// or find them in unixCmd("ifconfig")
// * switch Layout to 'Simple',
// * in options,
// * turn accelerometer on, and touch and ping off

/////// in SC:
// * check if anything is coming, and note the sending address
OSCFunc.trace(true);
OSCFunc.trace(false);
// * if nothing, check that touchosc sends to proper port:
NetAddr.langPort;

t = MKtl(\sombat, "touchOSC-SomBat");
t.gui;
// trace to look what address the touchOSC app sends from:
OSCFunc.trace(true);
// and turn off tracing.
OSCFunc.trace(false);
// now, thrace the real thing:
t.trace;

// set the address to the one you see in the trace:
t.device.updateSrcAddr("192.168.178.181", 9000);

/// 1st usage:
k.elementGroup;
k.postElements;


// set actions to the first three sliders
(
t.elAt(\fader).action = {arg el; Ndef(\ampBus).set(\amp, \amp.asSpec.map(el.value)) };
t.elAt(\xy).action = {arg el; Ndef(\joystick).set(\x, (el.value)) };

)