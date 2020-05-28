/****************************
// MKtl support for touchOSC
// for the single page layout "SomBat2" by AirborneInstruments

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

OSCdef('/1/fader5', { |msg| msg.postln });

////// the protocol for scene 1 is
// // a horiz. crossfader
// '/1/fader5'
// // four vertical faders
// '/1/fader1' .. 4
// // 4 toggle buttons
// '/1/toggle1' .. 4

// maybe turn off debug info,
OSCMKtlDevice.verbose = false;
// maybe clear MKtls first
MKtl.all.do(_.free).clear;
// make our tosc
t = MKtl(\sombat, "touchOSC-SomBat");
t.gui;
// trace to look what address the touchOSC app sends from:
OSCFunc.trace(true);
// and turn off tracing.
OSCFunc.trace(false);

// set the address to the one you see in the trace:
t.device.updateSrcAddr("192.168.178.55", 9000);

NetAddr.langPort;

// now trace the MKtl itself
t.trace;
t.device;
// and give it an action for all its elements
t.elAt.action = { |el|
	"tOsc %: %\n".postf(el.name, el.value.round(0.001))
};

t.gui;

// or if you test by simulation from SC:
n = NetAddr("192.168.178.51", 57120);
MKtl(\sombat).device.updateSrcAddr("192.168.178.51", 57120);


Tdef(\toscTest, {
	inf.do {
		n.sendMsg('/accxyz', 1.0.rand2, 1.0.rand2, 1.0.rand2);
		if (0.1.coin) { n.sendMsg('/xfader'.postln, 1.0.rand); };
		if (0.1.coin) { n.sendMsg("/1/fader4".postln, 1.0.rand); };
		0.1.wait;
	};
}).play;

*******************************/
(
(
deviceName: "touchOSC-SomBat",
protocol: \osc,
deviceType: \phoneApp,
elementTypes: [\accelerometer, \fader, \button],
status: (
	linux: "tested on Raspi",
	osx: "tested and working. 2020-04-14, HH.",
	win: "unknown"
),

idInfo: "touchOSC-SomBat",
netAddrInfo: (srcPort: 9000, recvPort: 57120, ipAddress: "127.0.0.1"),

deviceInfo: (
	longName: "touchOSC - SomBat Layput (Single page)"
),

// seem to be the max accel values on iphone, usually not used on SomBat, but optionally supported
specs: (accx: [-3.0, 3.0, \lin]),

collectives: (
	accel: (
		oscPath: '/accxyz',
		elements: [ [\accel, \x], [\accel, \y], [\accel, \z]],
		ioType: \in
	),
	xy: (
		oscPath: '/1/xy1',
		elements: [ [\xy, \x], [\xy, \y] ],
		ioType: \inout
	)
),
elementsDesc: (
	elements: [
		(
			key: \fader,
			oscPath: '/1/fader1', elementType: 'slider', spec: \unipolar, ioType: \inout,
			style: (row: 0, column: 0, width: 5, height: 1)
		),
		(
			// this sends 2 data scalars at once -- how to disentangle them ?
			// -> make it a collective, like acceleroms
			key: \xy,
			shared: (elementType: 'joyAxis', ioType: \collectiveInOut, \spec: \unipolar),
			elements: [
				(key: \x, style: (column: 0,    width: 2.5, height: 5)),
				(key: \y, style: (column: 2.5, width: 2.5, height: 5)),
			]
		),
		(  // 1 momentary button, top row L
			key: 'switch1',
			oscPath: '/1/switch1', elementType: \button, spec: \but, ioType: \inout,
			style: (row: 6, column: 0, width: 1.67, height: 1)
		),
		(  // 1 toggle button, top row
			key: \toggle,
			oscPath: '/1/toggleM', elementType: \button, spec: \but, ioType: \inout,
			style: (row: 6, column: 1.67, width: 1.67, height: 1)
		),
		(  // 1 momentary button, top row L. logically belongs i a group wiht \switch1, but thi aligns the GUI better.
			key: 'switch2',
			oscPath: '/1/switch2', elementType: \button, spec: \but, ioType: \inout,
			style: (row: 6, column: 3.33, width: 1.67, height: 1)
		),
		(  // 3 momentary trig buttons, bottom row
			key: \trig,
			shared: (elementType: \button, spec: \but, ioType: \inout),
			elements: (1..3).collect { |num, i|
				(
					oscPath: "/1/trig%".format(num).asSymbol,
					style: (row: 7, column: i * 1.67, width: 1.67, height: 1)
				)
			}
		),
		(
			key: \accel,
			shared: (elementType: 'accelAxis', ioType: \collectiveIn, \spec: 'accx'),
			elements: [
				(key: \x, style: (column: 0,    width: 1.67, height: 2)),
				(key: \y, style: (column: 1.67, width: 1.67, height: 2)),
				(key: \z, style: (column: 3.33, width: 1.67, height: 2))
			]
		)
	]
)
);
)
