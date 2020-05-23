/*
The following code will generate a sound file then use the sox command-line tool to create a spectrogram of that sound file.

#sox, #oneclick, #runtime, #s.sync, #spectrogram
(c) scott petersen 2020
*/

s.waitForBoot {

	var runtime = 3.5;
	var title = "algos" ++ "time".unixCmd.asString;
	var path = "".resolveRelative ++ title ++ ".wav";

	r = Recorder.new(s);
	r.recHeaderFormat = "WAV";
	r.recSampleFormat = "int24";
	r.prepareForRecord(path, 1);

	s.sync;

	r.record(duration: runtime);

	Pbind(\instrument, \default, \degree, Pseq([4,2,0], 1), \dur, 1, \amp, 1).play(); // example code

	runtime.wait;

	"Creating Spectrogram:".postln;

	("sox" + path.escapeChar($ ) + "-n spectrogram -x 1024 -z 90 -l -s -w hamming -o" + path.escapeChar($ ) ++ ".png").unixCmd { |res, pid| [\done, res, pid].postln };

	0.exit; // frees sclang: only use if running code from the CLI using sclang

}
