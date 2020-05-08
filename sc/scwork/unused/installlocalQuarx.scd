// install local Quarx!

if ((Quarks.installed.any { |quark| quark.name == "localQuarks" })) {
	// // if OK, load network setup file:
	// (q.hyperfolder +/+ "00_loadMe.scd").loadPaths;
	"OK".postln
} {
	// if missing, add local folder, and do reboot by hand by hand
	Quarks.install(q.hyperfolder +/+ "localQuarks");
	LanguageConfig.store;
	// thisProcess.recompile;
};
