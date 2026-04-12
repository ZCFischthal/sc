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