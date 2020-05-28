//autostart for x sesion in     ~/.config/lxsession/LXDE-pi/autostart
//

{
	q = q ? ();

	// NetAddr.localAddr
	//////////////*********************************************///////////////
	//////////////*********************************************///////////////
	//////////////*********************************************///////////////
	// tweak vars //
	q.baseSamplePath = if(File.exists("/mnt/sombat2020/short"))
	{"/mnt/sombat2020"} {
		if(File.exists("/media/patch/SOMBAT_DATA/short")){"/media/patch/SOMBAT_DATA"}{
			thisProcess.nowExecutingPath.dirname +/+ "defaultSounds" // this default can be stored in the distro
		}
	};

	// q.baseSamplePath.postln;

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

	s.latency_( nil );

	q.myname = unixCmdGetStdOut("whoami").drop(-1);
	if(q.verbose){"*** my username is: %\n\n".postf(q.myname)};

	// e.o tweak vars //
	//////////////*********************************************///////////////
	//////////////*********************************************///////////////
	//////////////*********************************************///////////////



	"*** hh autostart script running.".postln;


	q.rebootPy = {
		// better do this outside in shell script
		if(q.verbose){	"\n*** killing all Pythons".postln };
		unixCmd ("sudo killall python3");
		1.wait;
		if(q.verbose){	"\n*** booting all Pythons".postln };
		unixCmd("sudo python3 ~/Python/rgb_led_6.py".postln );
		0.1.wait;
		unixCmd("sudo python3 ~/Python/mcp3008_9.py --port %".format(NetAddr.localAddr.port).postln );
	};

	//	q.rebootPy.value;


	q.rebootJack = {
		//		{

		Server.killAll;
		"*** killing jackd".postln;
		"killall jackd".unixCmd;
		1.wait;
		"*** starting jackd".postln;
		"sudo jackd -P75 -p32 -t2000 -dalsa -dhw:0 -p64 -n2 -s -r48000 -P &".unixCmd;
		1.wait;
		"end jkackstart".postcln
		//		}.forkIfNeeded;
	};

	//	q.rebootJack.value;

	1.wait;
	"*** s.bootin'".postln;
	s.waitForBoot{
		var filesToLoad = ( thisProcess.nowExecutingPath.dirname +/+ "/autoload/*.scd").pathMatch.sort;

		"*** s.booted!!".postln;
		filesToLoad.do{|p, i|
			"*** loading autostart file %\n".postf(p.basename);
			p.load;
			[0.5, 2.5, 0.5].clipAt(i).wait;
		}
	}
}.fork;


/*
curl -sS https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/i2samp.sh | bash

SC_AudioDriver: sample rate = 48000.000000, driver's block size = 64
periods: 2
JackDriver: max output latency 2.7 ms

NdefMixer.new(s);

*/