//autostart in     ~/.config/lxsession/LXDE-pi/autostart
{
	q = q ? ();
	(
		// devel
		q.verbose = true;
		q.hasGui = true;
	);
	(
		// deploy
		q.verbose = false;
		q.hasGui = false;
	);



	"*** hh autostart script running".postln;
	//	"*** killing jackd".postln;
	//	"killall jackd".unixCmd;
	//	1.wait;
	//	"*** starting jackd".postln;
	//	"jackd -P75 -p32 -t2000 -dalsa -dhw:0 -p64 -n2 -s -r48000 -P &".unixCmd;
	1.wait;
	"*** s.bootin'".postln;
	s.waitForBoot{
		var filesToLoad = ( thisProcess.nowExecutingPath.dirname +/+ "/autoload/*.scd").pathMatch.sort;

		"*** s.booted".postln;
		filesToLoad.do{|p, i|
			if(q.verbose) { "loading autostart file %\n".postf(p.basename) };
			p.load;
			[2.5, 0.5].clipAt(i).wait;
		}
	}
}.fork;


/*
curl -sS https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/i2samp.sh | bash

SC_AudioDriver: sample rate = 48000.000000, driver's block size = 64
periods: 2
JackDriver: max output latency 2.7 ms
*/
