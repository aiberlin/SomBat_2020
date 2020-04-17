(
MFdef(\trigs, [
	\test,  { arg el, i; ["test mode", i, el.value].postcln; },
	\ede, { arg el, i; \ede.postcln },
	\ada, { arg el, i; "\adaadaada!".postln; },
	\synth, { arg el, i; \synth.postcln },
	\sampl, { arg el, i; "\sampl, noch nix".postln; },
]);
// like this by hand:
// MFdef(\trigs).modes.put(\a_only, (on: \set_a, off: \abc));
// MFdef(\trigs).modes.put(\b_only, (on: \set_b, off: \abc));
// MFdef(\trigs).modes.put(\c_only, (on: \set_c, off: \abc));

/*
MFdef(\trigs).makeExclusiveModes(\synth, [\synth]);
MFdef(\trigs).makeExclusiveModes(\test, [\test]);
MFdef(\trigs).makeExclusiveModes(\sampl, [\sampl]);
*/
MFdef(\trigs).modes.put(\ada, (off: \all, on: \ada));
MFdef(\trigs).modes.put(\test, (off: \all, on: \test));
MFdef(\trigs).modes.put(\sampl, (off: \all, on: \sampl));
MFdef(\trigs).modes.put(\synth, (off: \all, on: \synth));


MFdef(\trigs).mode_(\sampl);
MFdef(\trigs).mode_(\all);
MFdef(\trigs).mode_(\ada);
MFdef(\trigs).mode_(\test);
MFdef(\trigs).mode_(\synth);
)
MFdef(\trigs).value(11,222);

// now, I change the function, and the mode does not update the func...

/// this OK,
MFdef(\trigs).add(\ada,  { arg el, i; "Alter ich sach ADA!".postcs });

// but going up[ to line 1-9 not OK!
/// also, wenn code korrekt geschrieben, gehts auch gut!


//********

(
m = MFunc([
	\ada, {|t, i| [t, i, "ada"].postln },
    \bob, { "bob".postln },
    \dada, { "dada".postln },
    \ede, { "ede".postln },
])
);
)

// its internals
m.funcDict;                   // the repertoire
m.orderedNames;               // the order of evaluation of all funcs
m.activeNames.postcs;        // currently active names
m.activeFuncs.postcs;"";    // currently active funcs
m.modes;                    // modes to select from - see below

// evaluates all activeFuncs,
// returns a list of return values collected from each active function.
m.value;
m.disable(\ada);
m.value;
m.enable(\ada);
m.value;
// replace a func so that it fails
m.add(\bob, { \fail.becauseOfError });
m.value(3.rand, "\cijkoh".scramble);

// exclude all others, only keep \cicely
m.modes.put(\adaOnly, (on: [\ada], off: \all));
m.mode_(\adaOnly);
m.activeNames;
m.value(111,22, 3);

// define a set of mutually exclusive functions
m.modeLists.put(\triplet, [\ada, \bob, \dada]);
// and exclusive modes
m.modes.put(\ada3, (on: \ada, off: \triplet));
m.modes.put(\bob3, (on: \bob, off: \triplet));
m.modes.put(\dada3, (on: \dada, off: \triplet));
m.modeLists.put(\triplet, [\ada, \bob, \dada]);

m.makeExclusiveModes(
    \triplet, // name of exclusive List
    [\ada, \bob, \dada],  // names of the funcs
    [\ada3, \bob3, \dada3]); // names of the modes if different from the funcs

// see which funcs are on in which mode

m.mode_(\all).activeNames;
m.mode_(\ada3).activeNames;
m.mode_(\bob3).activeNames;
m.mode_(\dada3).activeNames;
