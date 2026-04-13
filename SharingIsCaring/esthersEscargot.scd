(
//VARIABLES
var counter = 0;
var factorySpeed = 4;
var factories = 0;
var factoryCost = 20;
var upgrades = 0;
var upgradeCost = 40;
var autoSnailsBegun = false;
var achievement = 0;

//FUNCTIONS
~counterUpdate = {
	counter.postln;
	x = Synth("doubleBass");
	c.string = "🐌: " + counter;
	if (counter > 5, {if (achievement < 1, {b.visible = true; a.visible = false; ~audioLayers.value;});});
	if (counter > factoryCost, {if (achievement < 2, {d.visible = true; ~audioLayers.value;});});
	if (counter > upgradeCost, {if (achievement < 3, {f.visible = true; ~audioLayers.value;});});
};

~counterOne = {
	counter = counter + 1;
	~counterUpdate.value;
};

~counterTwo = {
	counter = counter + 2;
	~counterUpdate.value;
};

~autoSnails = {
	~clock.value;
	~clock = {AppClock.sched(factorySpeed,
		{ |time|
			["AppClock has been playing for ", time].postln;
			counter = counter + factories;
			~counterUpdate.value;
			~clock.value;
	    });
	};
};

~buyAutoSnails = {
	if (counter > factoryCost, {
		counter = counter - factoryCost;
		~counterUpdate.value;
		factories = factories + 1;
		factoryCost = factoryCost + (factoryCost/2);
		d.string = "Buy Factory for " + factoryCost + "🐌: (" + factories + ")";
		if (autoSnailsBegun ==false, {~autoSnails.value; autoSnailsBegun = true; counter = counter + 1;});
	}, {e.string = "Not enough 🐌"; ~errorMessage.value;});
};

~upgradeFactory = {
	if (counter > upgradeCost, {
		counter = counter - upgradeCost;
		~counterUpdate.value;
		factorySpeed = factorySpeed / 2;
		upgrades = upgrades + 1;
		upgradeCost = upgradeCost + (upgradeCost/2);
		f.string = "Upgrade Factory for " + upgradeCost + "🐌: (" + upgrades + ")";
	}, {e.string = "Not enough 🐌"; ~errorMessage.value;});
};

~errorMessage = {
	e.visible = true;
	AppClock.sched(2.0,
		{|time|
			e.visible = false;
	});
};

~audioLayers = {
	achievement.postln;
	switch(achievement,
		0, {~harmony.unmute},
		1, {~bassline2.unmute},
		2, {~kick.unmute},
		3, {~snare.unmute},
		4, {~hihat.unmute}
	);
	achievement = achievement + 1;
};

//INSTRUMENTS
(SynthDef("doubleBass", {
	arg
	// Standard Values
	out = 0, pan = 0, amp = 1.0, freq = 440, att = 0.01, rel = 1.0 , crv = -30, vel = 1.0,
	// Other Controls
	freqDev = 2, op1mul = 0.1, op2mul = 0.1, op3mul = 0.1, sprd = 0.5, subAmp = 0.1;

	var env, op1, op2, op3, op4, snd, sub;

	// Percussive Envelope
	env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		curve: crv
	).ar(doneAction: 2);

	// Overtones
	op1 = SinOsc.ar(
		freq: freq * 4,
		mul: vel / 2 + op1mul);

	op2 = SinOsc.ar(
		freq: freq * 3,
		phase: op1,
		mul: vel / 2 + op2mul);

	op3 = SinOsc.ar(
		freq: freq * 2,
		phase: op2,
		mul: vel / 2 + op3mul);

	// Fundamental Frequency
	op4 = SinOsc.ar(
		freq: freq + NRand(-1 * freqDev, freqDev, 3),
		phase: op3,
		mul: vel);

	// Delay Line with Multi-Channel Expansion
	snd = {
		DelayN.ar(
			in: op4,
			maxdelaytime: 0.06,
			delaytime: Rand(0.03, 0.06)
		)} !8;

	// High Pass Filter
	snd = LeakDC.ar(snd);

	// Stereo Spread
	snd = Splay.ar(
		inArray: snd,
		spread: sprd,
		level: 0.6,
		center: pan);

	// Add a sub
	sub = SinOsc.ar(
		freq: freq/2,
		mul: env * subAmp);
	sub = Pan2.ar(sub, pan);
	snd = snd + sub;

	//Ouput Stuff
	snd = snd * env;
	snd = snd * amp;
	snd = Limiter.ar(snd);
	Out.ar(out, snd);
},
metadata: (
	credit: "Matias Monteagudo",
	category: \bass,
	tags: [\pitched, \bass]
)
).add;);

(
SynthDef(\FMRhodes1, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1, lfoSpeed = 4.8, inputLevel = 0.2,
    // all of these range from 0 to 1
    modIndex = 0.2, mix = 0.2, lfoDepth = 0.1;

    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * 30) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
  	snd = snd * (SinOsc.ar(lfoSpeed).range((1 - lfoDepth), 1));

    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
},
metadata: (
	credit: "Nathan Ho",
	category: \keyboards,
	tags: [\pitched, \piano, \fm]
)
).add;
);

(
SynthDef("cs80leadMH", {
	arg
	//Standard Values
	freq = 440, amp = 0.5, gate = 1.0, pan = 0, out = 0,
	//Amplitude Controls
	att = 0.75, dec = 0.5, sus = 0.8, rel = 1.0,
	//Filter Controls
	fatt = 0.75, fdec = 0.5, fsus = 0.8, frel = 1.0, cutoff = 200,
	//Pitch Controls
	dtune = 0.002, vibspeed = 4, vibdepth = 0.015, ratio = 0.8, glide = 0.15;

	var env, fenv, vib, ffreq, snd;


	//Envelopes for amplitude and frequency:
	env = Env.adsr(att, dec, sus, rel).kr(gate: gate, doneAction: 2);
	fenv = Env.adsr(fatt, fdec, fsus, frel, curve:2).kr(gate: gate);

	//Giving the input freq vibrato:
	vib = SinOsc.kr(vibspeed).range(1 / (1 + vibdepth), (1 + vibdepth));
	freq = Line.kr(start: freq * ratio, end: freq, dur: glide);
	freq = freq * vib;

	//See beatings.scd for help with dtune
	snd = Saw.ar([freq, freq * (1 + dtune)], mul: env * amp);
	snd = Mix.ar(snd);

	//Sending it through an LPF: (Keep ffreq below nyquist!!)
	ffreq = max(fenv * freq * 12, cutoff) + 100;
	snd = LPF.ar(snd, ffreq);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Mike Hairston",
	category: \keyboards,
	tags: [\lead, \modulation, \analog, \cs80, \vangelis, \bladerunner]
	)
).add;
);

(
SynthDef("kick808", {arg out = 0, freq1 = 240, freq2 = 60, amp = 1, ringTime = 10, att = 0.001, rel = 1, dist = 0.5, pan = 0;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, 0.1),
		decaytime: ringTime);
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "unknown",
	category: \drums,
	tags: [\percussion, \kick, \808]
)
).add;
);


(
SynthDef("hihatElectro", {
    arg out = 0, pan = 0, amp = 0.3, att = 0.001, rel = 0.3, curve = -8, filterFreq = 4010, rq = 0.56;

    var env, snd;

    // noise -> resonance -> exponential dec envelope
    env = Env.perc(attackTime: att, releaseTime: rel, curve: curve).kr(doneAction: 2);

	snd = ClipNoise.ar(amp);
	snd = BPF.ar(
		in: snd,
		freq: [1, 1.035] * filterFreq,
		rq: [0.27, 1] * rq,
		mul: [1.0, 0.6]
	);
	snd = Mix(snd) * env;

    Out.ar(out, Pan2.ar(snd, pan));

	},
metadata: (
	credit: "By Nathan Ho aka Snappizz",
	category: \drums,
	tags: [\clap, \percussion, \hihat]
	)
).add;
);

(
SynthDef("snareElectro", {
    arg
	//Standard Values
	out = 0, pan = 0, amp = 0.4, att = 0.001, rel = 0.15, curve = -4,
	//Other Controls, blend ranges from 0 to 1
	popfreq = 160, sweep = 0.01, noisefreq = 810, rq = 1.6, blend = 0.41;

    var pop, popEnv, popSweep, noise, noiseEnv, snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popSweep = Env.new(levels: [20.4, 2.6, 1] * popfreq, times: [sweep / 2, sweep], curve: \exp).ar;

    popEnv = Env.perc(attackTime: att, releaseTime: 0.73 * rel, level: blend, curve: curve).kr;

	pop = SinOsc.ar(freq: popSweep, mul: popEnv);

    // bandpass-filtered white noise
    noiseEnv = Env.perc(attackTime: att, releaseTime: rel, level: 1 - blend, curve: curve).kr(doneAction: 2);

	noise = BPF.ar(in: WhiteNoise.ar, freq: noisefreq, rq: rq, mul: noiseEnv);

    snd = Mix.ar(pop + noise) * amp;

    Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Nathan Ho aka Snappizz",
	category: \organ,
	tags: [\pitched]
	)
).add;
);

//AUDIO
(
~bassline = Pbind(
	\degree, Pseq([0, -1, -2, -3], inf),
    \dur, 2,
	\instrument, \cs80leadMH;
).play;
);

(
~harmony = Pbind(
	\degree, Pseq([Rest(1), 4, 9, 4], inf),
    \dur, 0.5,
	\instrument, \cs80leadMH;
).play;
);

(
~bassline2 = Pbind(
	\degree, Pseq([-7, -8, -9, -10], inf),
    \dur, 2,
	\instrument, \cs80leadMH;
).play;
);

(
~kick = Pbind(
    \dur, 2,
	\instrument, \kick808;
).play;
);

(
~hihat = Pbind(
	\degree, Pseq([Rest(), Rest(), 0, Rest(), Rest(), Rest(), 0, 0], inf),
	\dur, 0.125,
	\instrument, \hihatElectro;
).play;
);

(
~snare = Pbind(
	\degree, Pseq([Rest(), Rest(), 0, Rest()], inf),
	\dur, 0.25,
	\instrument, \snareElectro;
).play;
);
~snare.mute;
~kick.mute;
~hihat.mute;
~harmony.mute;
~bassline2.mute;


//GUI
a = Button.new().string_("Buy 🐌").action_(~counterOne);
b = Button.new().string_("Buy 🐌🐌").action_(~counterTwo);
d = Button.new().string_("Buy Factory for " + factoryCost + "🐌: (" + factories + ")").action_(~buyAutoSnails);
f = Button.new().string_("Upgrade Factory for " + upgradeCost + "🐌: (" + upgrades + ")").action_(~upgradeFactory);

d.visible = false;
b.visible = false;
f.visible = false;

c = StaticText.new().string_("🐌: " + counter);
e = StaticText.new().string_("");

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.new(0.3, 0.2, 1, 0.3)).layout_(
    VLayout(
		HLayout( c, e),
		f,
		d,
		b,
		a
    )
).front;
)