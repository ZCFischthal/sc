/*
Angelica and I played it and encountered following issues:
Manager continues to buy even when turned off
Factory speed increases exponentially, which is fine except that the counter up noise is called too often — need to have it only click at the thousands/hundreds once you  reach a certain speed
Need to round factory cost and upgrade cost to integer so they don't make counter weird float
*/

(
//VARIABLES
var counter = 0;
var factorySpeed = 4;
var factories = 0;
var factoryCost = 20;
var upgrades = 0;
var upgradeCost = 40;
var achievement = 0;
var curAchievement = 0;
var managerCost = 90;
var managers = 0;

var myManagers = List.new();

//FUNCTIONS
~counterUpdate = {
	counter.postln;
	x = Synth("doubleBass");
	c.string = "🐌: " + counter;
	~nextAchievement.value;
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
	"autoSnails".postln;
	factorySpeed.postln;
	~clock.value;
};

~clock = {AppClock.sched(factorySpeed,
		{ |time|
			//["AppClock has been playing for ", time].postln;
			counter = counter + factories;
			~counterUpdate.value;
			~clock.value;
	    });
	};

~buyAutoSnails = {
	if (counter > factoryCost, {
		counter = counter - factoryCost;
		~counterUpdate.value;
		~buyColor.value;
		factories = factories + 1;
		factoryCost = factoryCost + (factoryCost/2);
		d.string = "Buy Factory for " + factoryCost + "🐌: (" + factories + ")";
		if (factories == 1, {~autoSnails.value; "called AutoSnails".postln; counter = counter + 1; ~audioLayers.value;});
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

~buyManager = {
	if (counter > managerCost, {
		if(managers < 1, {~managerDuty.value;});
		managers  = managers + 1;
		g.string = "Buy Manager for " + managerCost + "🐌: (" + managers + ")";
		counter = counter - managerCost;
		~counterUpdate.value;
		myManagers = myManagers.add(~newButton.value);
		managers.postln;
	}, {e.string= "Not enough 🐌"; ~errorMessage.value;});
};

~managerDuty = {
	AppClock.sched(5.0,
		{|time|
			counter = counter - (managers * 0.5);
			if (managers > 0, {~counterUpdate.value;});
			if (counter > factoryCost, {~buyAutoSnails.value; "manager bought".postln;});
			~managerDuty.value;
	});

};

~newButton = {Button.new(w, Rect(0, 0)).string_("Manager" + managers).states_([
			["Manager Working", Color.black, Color.green],
			["Manager Off", Color.gray, Color.clear]
		]).action_({|me|
	me.value.postln;
	if (me.value == 0, {managers = managers + 1;}, {managers = managers - 1;});
	("managers: " + managers).postln;};);};

~errorMessage = {
	e.visible = true;
	AppClock.sched(2.0,
		{|time|
			e.visible = false;
	});
};

~nextAchievement = {
	switch (curAchievement,
		0, {if (counter > 5, {~audioLayers.value; curAchievement = curAchievement + 1; b.visible = true; a.visible = false;})},
		1, {if (counter > factoryCost, {~audioLayers.value; curAchievement = curAchievement + 1; d.visible = true;})},
		2, {if (counter > upgradeCost, {~audioLayers.value; curAchievement = curAchievement + 1; f.visible = true;})},
		3, {if (counter > managerCost, {~audioLayers.value; curAchievement = curAchievement + 1; g.visible = true;})}
	);
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
	//~buyColor.value;
	achievement = achievement + 1;
};

~buyColor = {
	w.background = Color.new(0.5, 0.65, 0.5);
	AppClock.sched(1,
		{|time|
			w.background = ~ogColor;
	});
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
	\degree, Pseq([Pseq([Pseq([0, -1, -2, -3], 3), -1, 0, 1, -3], 2), [-2, 0, 2], [-3, 0, 2], [-3.9, 0, 2], [-5, 0, 2]], inf),
    \dur, 2,
	\instrument, \cs80leadMH;
).play;
);

(
~harmony = Pbind(
	\degree, Pseq([Pseq([Pseq([Rest(1), 4, 9, 4], 4), Pseq([Rest(1), 3.9, 8, 3.9], 4), Pseq([Rest(1), 4, 9, 4], 4), Rest(1), 4, 8, 4, Rest(1), 4, 9, 4, Pseq([Rest(1), 4, 10, 4], 2)], 2), 9, 3.9, 4, 5, 6, 2, 3.9, 4, 5, 2, 3.9, 4, 3.9, 4.9, 6, 10.9], inf),
	\dur, 0.5,
	\instrument, \cs80leadMH;
).play;
);

(
~bassline2 = Pbind(
	\degree, Pseq([Pseq([Pseq([0, -1, -2, -3], 3), -1, 0, 1, -3], 2), [-2, 0, 2], [-3, 0, 2], [-3.9, 0, 2], [-5, 0, 2]], inf),
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
a = Button.new().font_(Font(size:15)).action_(~counterOne).states_([["Buy 🐌", Color.black, Color.new(1, 0.87, 1)]]);
b = Button.new().font_(Font(size:15)).action_(~counterTwo).states_([["Buy 🐌🐌", Color.black, Color.new(1, 0.87, 1)]]);
d = Button.new().states_([["Buy Factory for " + factoryCost + "🐌: (" + factories + ")", Color.new(1, 0.87, 1), Color.new(0.5, 0.65, 0.5)]]).font_(Font(size:15)).action_(~buyAutoSnails);
f = Button.new().states_([["Upgrade Factory for " + upgradeCost + "🐌: (" + upgrades + ")", Color.new(1, 0.87, 1), Color.new(0.5, 0.65, 0.5)]]).font_(Font(size:15)).action_(~upgradeFactory);
g = Button.new().states_([["Buy Manager for " + managerCost + "🐌: (" + managers + ")", Color.new(1, 0.87, 1), Color.new(0.5, 0.35, 0.5)]]).font_(Font(size:15)).action_(~buyManager);

d.visible = false;
b.visible = false;
f.visible = false;
g.visible = false;

d.mouseEnterAction_({d.string_("Factory makes more 🐌 every" + factorySpeed + "seconds");});
d.mouseLeaveAction_({d.string_("Buy Factory for " + factoryCost + "🐌: (" + factories + ")");});
f.mouseEnterAction_({f.string_("Factory now makes 🐌 every" + (factorySpeed/2) + "seconds");});
f.mouseLeaveAction_({f.string_("Upgrade Factory for " + upgradeCost + "🐌: (" + upgrades + ")");});
g.mouseEnterAction_({g.string_("Manager buys factories if affordable. Salary is 0.5 🐌 per 5  seconds");});
g.mouseLeaveAction_({g.string_("Buy Manager for " + managerCost + "🐌: (" + managers + ")");});

c = StaticText.new().string_("🐌: " + counter).font_(Font(size:50)).stringColor_(Color.new(1, 0.87, 1));
e = StaticText.new().string_("").font_(Font(size:30)).stringColor_(Color.red);


~ogColor = Color.new(0.5, 0.5, 0.5);

w = Window.new("🐌 Esther's Escargot 🐌").background_(~ogColor).layout_(
    VLayout(
		x = HLayout( c, e),
		g,
		f,
		d,
		b,
		a
    )
).front;

)