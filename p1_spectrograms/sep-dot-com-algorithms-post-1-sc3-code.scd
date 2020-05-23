s.waitForBoot {

	var runtime = 4.0; // the total length of the recording: required to stop recording and free sclang
	var title = "algos"; // alternate title for testing CLI/sclang
	var time = "time".unixCmd.asString; // a unique (ish) number to keep overwrites from happening.

	r = Recorder.new(s);
	r.recHeaderFormat = "WAV";
	r.recSampleFormat = "int24";
	r.prepareForRecord("".resolveRelative ++ title ++ time ++ ".wav", 1);

	s.sync;

	r.record(duration: runtime);

	Pbind(\instrument, \default, \degree, Pseq([4,2,0], 1), \dur, 1, \amp, 1).play(); // example code

	runtime.wait; // wait until the code has executed

	"end".postln;
	0.exit; // frees sclang: only use if running code from the CLI using sclang

}
