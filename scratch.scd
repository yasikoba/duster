s.makeGui; // L, F
s.scope;

(
s = Server.local;
Server.default = s;
s.boot;
)
s.freeAll

{SinOsc.ar(440)}.play;

(
SynthDef('duster', {
	arg pan = 0, density = 1;
	var freqs, out;
	freqs = Control.names([\freqs]).kr([110, 220, 440, 880]);
	out = DynKlank.ar(`[freqs, nil, [1, 1, 1, 1]], Dust2.ar(density, 0.3));
	Out.ar(pan, Limiter.ar(out, 0.99));
}).add;
)

l = Synth('duster', ["pan", 0]);
r = Synth('duster', ["pan", 1]);

~array = [110, 220, 440, 880, 1320, 1760, 2200, 2640, 3080];
~array = ~array.rotate(1);
~array = ~array.scramble;

~freqs_l = ~array.keep(4);
~freqs_r = ~freqs_l * 1.01;
// ~freqs_r = ~freqs_l * 1.02;
~freqs_r = ~freqs_l
l.setn(\freqs, ~freqs_l);
r.setn(\freqs, ~freqs_r);
~freqs_l.postln

~freqs_r = ~array.do{arg i; (i+1); };

l.setn(\freqs, ~freqs_l);
r.setn(\freqs, ~freqs_r);

l.free;
r.free;

// 3 3000000 5 500000 10 1000000
// 3 4 5 の群
// 5000000 7000000 10000000 の群
// 交互に
l.set(\density, 7000);
r.set(\density, 7000000);
l.set(\density, 5000000);
r.set(\density, 5000000);
l.set(\density, 3000000);
r.set(\density, 3000000);
l.set(\density, 3);
r.set(\density, 3);
l.set(\density, 5);
r.setn(\density, 5);
l.setn(\density, 7);
r.setn(\density, 7);

(
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

t.start;
t.pause;
t.resume;
t.reset;
t.stop;


{ DynKlank.ar(`[[800, 1071, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(2, 0, 0.1)) }.play;

{ DynKlank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }.play;

{ DynKlank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007)) }.play;

{ DynKlank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007,0.007])) }.play;



// create multichannel controls directly with literal arrays:
(
SynthDef('help-dynKlank', {| 
	freqs (#[100, 200, 300, 400]), 
	amps (#[1, 0.3, 0.2, 0.05]), 
	rings (#[1, 1, 1, 2])|

	Out.ar(0, DynKlank.ar(`[freqs, amps, rings], WhiteNoise.ar * 0.001))
}).add
)

a = Synth('help-dynKlank');

a.setn(\freqs, Array.rand(4, 500, 2000));
a.setn(\amps, Array.exprand(4, 0.01, 1));

{ Out.kr(102, MouseX.kr(1, 2) * Array.rand(4, 500, 2000)) }.play;
a.mapn(\freqs, 102, 4);
