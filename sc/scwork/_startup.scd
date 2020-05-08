//autostart in     ~/.config/lxsession/LXDE-pi/autostart
{
	q = q ? ();

	// NetAddr.localAddr
	//////////////*********************************************///////////////
	//////////////*********************************************///////////////
	//////////////*********************************************///////////////
	// tweak vars //
	q.baseSamplePath = "/media/patch/SOMBAT_DATA";
	q.baseSamplePath = if(File.exists("/mnt/sombat2020"))
		{"/mnt/sombat2020"}
		{
			thisProcess.nowExecutingPath.dirname.dirname +/+ "defaultSounds" // this default can actually be stored on distro!
		};

		(
			// deploy
			q.verbose = false;
			q.hasGui = false;
		);

		(
			// devel
			q.verbose = true;
			q.hasGui = true;
		);
		s.latency_( nil );

		"*** my username is: ".post;
		q.myname = unixCmdGetStdOut("whoami").drop(-1).postln;

		// e.o tweak vars //
		//////////////*********************************************///////////////
		//////////////*********************************************///////////////
		//////////////*********************************************///////////////



		"*** hh autostart script running".postln;
		q.rebootJack = {
			{
				"*** killing jackd".postln;
				"killall jackd".unixCmd;
				2.wait;
				"*** starting jackd".postln;
				"jackd -P75 -p32 -t2000 -dalsa -dhw:0 -p64 -n2 -s -r48000 -P &".unixCmd;
				2.wait;
				"end".postcln
			}.fork
		};
		/*
		q.rebootJack.value;
		*/
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
	