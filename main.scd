(

SynthDef('duster', {
	arg pan = 0, density = 1;
	var freqs, out;
	freqs = Control.names([\freqs]).kr([110, 220, 440, 880]);
	out = DynKlank.ar(`[freqs, nil, [1, 1, 1, 1]], Dust2.ar(density, 0.3));
	Out.ar(pan, Limiter.ar(out, 0.99));
}).add;

l = Synth('duster', ["pan", 0]);
r = Synth('duster', ["pan", 1]);

~array = [110, 220, 440, 880, 1320, 1760, 2200, 2640, 3080];
~densities = [3, 3000000, 5, 5000000, 7, 7000000];

t = Task({
	var freqs_l, freqs_r, den_l, den_r;
	10.wait;
	10.do({|i|
		("loop"+(i+1)).postln;
		freqs_l = ~array.keep(4);
		freqs_r = freqs_l * 1.01;
		den_l = ~densities.at(0);
		den_r = den_l * 1.01;

		l.setn(\freqs, freqs_l);
		freqs_l.postln;
		5.wait;

		r.setn(\freqs, freqs_r);
		freqs_r.postln;
		5.wait;

		l.set(\density, den_l);
		den_l.postln;
		5.wait;

		r.set(\density, den_r);
		den_r.postln;
		5.wait;

		~array = ~array.rotate(1);
		~densities = ~densities.rotate(-1);
	});
	10.wait;
	l.setn(\density, 1);
	10.wait;
	r.setn(\density, 1);
	10.wait;
	l.free;
	r.free;
	"end".postln;
});
t.start;
)
