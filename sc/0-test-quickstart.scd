// 5. load the 3 first synth sounds
Server.killAll;
s.waitForBoot{ 	"1-SomBat2-synthSounds.scd".loadRelative;  };	NdefMixer(s);

// 6. load the Modality Kram
"2-osc-mapping-modality.scd".loadRelative;

// adc network iphone addr
q.mktl.device.updateSrcDstAddr("192.168.178.55");

