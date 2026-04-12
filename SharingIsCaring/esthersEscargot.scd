(
//VARIABLES
var counter = 0;
var factorySpeed = 4;
var factories = 0;
var factoryCost = 20;
var upgrades = 0;
var upgradeCost = 40;
var autoSnailsBegun = false;

//FUNCTIONS
~counterUpdate = {
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter > 5, {b.visible = true; a.visible = false;});
	if (counter > factoryCost, {d.visible = true;});
	if (counter > upgradeCost, {f.visible = true;});
	x = Synth("doubleBass");
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
		if (autoSnailsBegun ==false, {~autoSnails.value; autoSnailsBegun = true;});
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

//AUDIO
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

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c, e),
		f,
		d,
		b,
		a
    )
).front;
)