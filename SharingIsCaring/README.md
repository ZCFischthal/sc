# 🐌 Esther's Escargot 🐌

## Instructions


## My <i>Process</i>
I've decided I'm making a game in supercollider
My hope is to make a top-down game 2d game where you play as a snail emoji
I think this will be 100% doable and not hard at all
I'm relying mostly on this:
https://docs.supercollider.online/Guides/GUI-Introduction.html

My other goal is to have the whole thing be wrapped so you just cmd-enter and play (maybe 2x if necessary)

I have made a window
```
(
w = Window.new("🐌 Sherry the Snail 🐌", Rect(400,400,400,400));
w.front;
)
```

slightly nicer window with snail
```
(
w = Window.new("🐌 Sherry the Snail 🐌", Rect(400,400,400,400)).background_(Color.white);
StaticText.new(w,Rect(0, 0, 400,400)).align_(\center).string_("🐌").resize_(5);
w.front;
)
```

Ok so in this, the slider moves the "c" composite view

```
w = Window.new("GUI Introduction", Rect(200,200,255,100));
b = Button.new(w,Rect(10,0,80,30)).states_([["Hide"],["Show"]]);
l = Slider.new(w,Rect(95,0,150,30));
c = CompositeView.new(w,Rect(20,35,100,60));
StaticText.new(c,Rect(0,0,80,30)).string_("Hello");
StaticText.new(c,Rect(20,30,80,30)).string_("World!");
b.action = { c.visible = b.value.asBoolean.not };
l.action = { c.bounds = Rect( l.value * 150 + 20, 35, 100, 100 ) };
w.front;
```

ok cool so, below lets you move snail emoji with slider:

```
(
w = Window.new("🐌 Sherry the Snail 🐌", Rect(400,400,400,400)).background_(Color.white);
l = Slider.new(w,Rect(95,0,150,30));
c = CompositeView.new(w,Rect(20,35,100,60));
StaticText.new(c,Rect(0,0,80,30)).string_("🐌");
l.action = { c.bounds = Rect( l.value * 150 + 20, 35, 100, 100 ) };
w.front;
)
```

now to move with wasd

https://docs.supercollider.online/Tutorials/GUI/create_window.html
This is the example they give for an action with a key press
Except it doesn't work????
```
(
var window = Window();
var fullScreenActive = false;

View.globalKeyDownAction = { |view, char, mod, unicode, keycode, key|

    switch(keycode)

    // if the keycode is 65307 (ESC): close the window
    { 65307 } { window.close; }

    // if the keycode is 102 (f): toggle full screen ON / OFF
    { 102 } {
        fullScreenActive = fullScreenActive.not;
        if(fullScreenActive)
        { window.fullScreen; }
        { window.endFullScreen; };
    };
};

window.front;
)
```

I rebooted the server and tried just copying and running the different bits of code on the page linked above
So far, the 1st key press thing they've got worked (shift + cmmd + . to close window)
```
(
var window = Window();
CmdPeriod.doOnce({ window.close; });
window.front;
)
```

but the thing I tried earlier still doesn't work argh

https://docs.supercollider.online/Classes/UserView.html
looking here now


This is fun
```
// drag some circles
(
var w, r, u;
var clicked, relativeWhere;
r = { Rect(300.rand, 300.rand, 110, 110) } ! 4;

w = Window.new.front;
u = UserView(w, Rect(0, 0, 400, 400));
u.drawFunc = {
    r.do { |x, i|
        Pen.addOval(x); // wie addRect
        Pen.color = Color.hsv(0.9 * (1/(i+1)), 0.6, 1);
        Pen.draw;
    };
};
u.mouseDownAction = { |v, x, y|
    r.do { |rect, i|
        if(rect.contains(Point(x, y))) {
            clicked = i;
            relativeWhere = Point(x, y) - rect.origin;
        };
    };
};

u.mouseMoveAction = { |v, x, y|
    var rect;
    if(clicked.notNil) {
        rect = r.at(clicked);
        r.put(clicked, rect.origin = Point(x, y) - relativeWhere);
        w.refresh;
    }
};

u.mouseUpAction = {
    clicked = nil;
}
)
```
I feel like the above could be a different kind of game
Maybe moving the balls changes the pitch they emit
And clicking on them turns them on/off


https://scsynth.org/t/is-it-possible-to-have-keyboard-keycode-catching-work-without-the-window-being-front/7085/2
```
(
View.globalKeyDownAction = {"Key was pressed.".postln;};
Window.new("Win 1").front;
Window.new("Win 2").front;
)
```
That works (pressing any key has "key was pressed" show up)
So I just need to figure out how to bind that to a specific key

Ok so I've changed my mind
Pressing keys is too hard
I'm going to make cookie clicker instead (only button pressing, should be easier)

So first things first is I want to make a counter that goes up when you press the button

```
(
var counter;
counter = 0;
w = Window.new("🐌 Sherry the Snail 🐌", Rect(400,400,400,400)).background_(Color.white);
StaticText.new(w,Rect(0, 0, 400,400)).align_(\center).string_(counter).resize_(5);
w.front;
)
```
Counter shows up

```
(
var counter;
counter = 0;
~counterUp = {
	counter = counter + 1;
	counter.postln;
};

w = Window.new("🐌 Sherry the Snail 🐌", Rect(400,400,400,400)).background_(Color.white);


StaticText.new(w,Rect(0, 0, 400,400)).align_(\center).string_(counter).resize_(5);

b = Button.new(w,Rect(10,10,180,30)).action_(~counterUp);
w.front;
)
```
Ok, so we can see with the postln (using as my debug lol) that the counter variable IS going up
But the static text isn't changing — we probably need to do something so that it will sort of respawn the text

https://docs.supercollider.online/Classes/StaticText.html
You just have to have the string separate from the rest

```
(
var counter;
counter = 0;
~counterUp = {
	counter = counter + 1;
	counter.postln;
	c.string = "Snails: " + counter;
};

w = Window.new("🐌 Sherry the Snail 🐌", Rect(400,400,400,400)).background_(Color.white);


c = StaticText.new(w,Rect(0, 0, 400,400)).align_(\center).string_("Snails: " + counter).resize_(5);

b = Button.new(w,Rect(10,10,180,30)).action_(~counterUp);
w.front;
)
```
SLAY this works beautifully
Already way more progress than trying to make a top down game lol
ok
so now we need a bunch more buttons
well actually 1st I want to organize a bit

```
(
var counter;
counter = 0;
~counterUp = {
	counter = counter + 1;
	counter.postln;
	c.string = "🐌: " + counter;
};

b = Button.new().action_(~counterUp);
c = StaticText.new().string_("🐌: " + counter);

w = Window.new("🐌 Sherry the Snail 🐌").layout_(
    VLayout(
		HLayout( b, c )
    )
).front;
)
```
Beautiful

ok next mission: how do we make a button that only appears when there are over a certain amount of snails
normal questions to ask
also love how there's 0 audio in my supercollider project yet lmaooo
let me actually check the requirements bc imagine the damage if i did a silent sc final it would be soooooo funny

the requirements:
"
- you must create a 3-5min supercollider work for your partner to perform.
  - no third-party extensions, but you may create your own extension to share directly with your partner (e.g. see Sun.sc in 09.guis&controllerism)
- you must perform a partner's work.  
- you will have time in class to collaborate with your partner (30min per class), but the goal is for you to have such good written documentation by the end of the semester that any SuperCollisionist could 
"

lol
lmao even

```
(
var counter = 0;
var add = 0;

~counterUp = {
	counter = counter + add;
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter == 0, b.visible = true);
};

a = Button.new().string_("Buy 🐌").action_(~counterUp);
b = Button.new().string_("Buy 🐌🐌").action_(~counterUp);
c = StaticText.new().string_("🐌: " + counter);

w = Window.new("🐌 Sherry the Snail 🐌").layout_(
    VLayout(
		HLayout( c ),
		HLayout(a, b)
    )
).front;
)
```
Tried a couple variations of this (~counterUp as the action for the buttons, add = 2 as the action)
But it's not really working
If I have b button action as add = 2, it just makes add = 2 from the start
idk why
and having a button action as add = 1 doesn't work either

```
(
f = { arg a;
  a.value + 3        // call "value" on a; polymorphism awaits!
};
)
f.value(3);          // a.value is 3, so this returns 3 + 3 = 6
g = { 3.0.rand };
f.value(g);          // here the arg is a Function. a.value evaluates 3.0.rand
f.value(g);          // try it again, different result
```
https://docs.supercollider.online/Tutorials/Getting-Started/04-Functions-and-Other-Functionality.html
I think we're getting somewhere

```
(
var counter = 0;
var add = 1;

~counterUp = {
	counter = counter + add;
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter == 5, {b.visible = true});
};
a = Button.new().string_("Buy 🐌").action_(~counterUp);
b = Button.new().string_("Buy 🐌🐌").action_(~counterUp);
b.visible = false;
c = StaticText.new().string_("🐌: " + counter);

w = Window.new("🐌 Sherry the Snail 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c ),
		HLayout(a, b)
    )
).front;
)

```
Ok, we didn't get anywhere with that but I did fix the b button so it'd only appear after 5 snails


```
(
var counter = 0;

~add = 1;

~counterUpdate = {
	var up = ~add.value;
	counter = counter + up;
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter == 5, {b.visible = true});
};
a = Button.new().string_("Buy 🐌").action_(~counterUpdate, ~add.value(1));
b = Button.new().string_("Buy 🐌🐌").action_(~counterUp, ~add.value(2));
b.visible = false;
c = StaticText.new().string_("🐌: " + counter);

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c ),
		HLayout(a, b)
    )
).front;
)
```
This is doing something different at least
a button counts up by 1 from 0, b button counts up by 1 from something else??
Ok it looks like b button remembers from the last time you opened it??? that's all i can think it could be
which is kinda crazy

ok its my fault for being stupid
I changed the name from counterUp to counterUpdate but didn't change the b button's action lmao
anyway it still doesn't work right as this:

```
(
var counter = 0;

~add = 1;

~counterUpdate = {
	var up = ~add.value;
	counter = counter + up;
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter == 5, {b.visible = true});
};
a = Button.new().string_("Buy 🐌").action_(~counterUpdate, ~add.value(1));
b = Button.new().string_("Buy 🐌🐌").action_(~counterUpdate, ~add.value(2));
b.visible = false;
c = StaticText.new().string_("🐌: " + counter);

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c ),
		HLayout(a, b)
    )
).front;
)
```

so I'm going to look for new solutions
ok, I'm looking to birb.scd for inspiration
going to see how they do this stuff
i dont know if this is going to help its a little above my paygrade
I really just need a way to call a function within another function
so I could just call "counterUpdate" whenever I call another function


```
(
var counter = 0;
var add = 0;

~counterUpdate = {
	counter = counter + add;
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter == 5, {b.visible = true});
};

~counterOne = {
	add = 1;
	~counterUpdate.value;
};

~counterTwo = {
	add = 2;
	~counterUpdate.value;
};

a = Button.new().string_("Buy 🐌").action_(~counterOne);
b = Button.new().string_("Buy 🐌🐌").action_(~counterTwo);
b.visible = false;
c = StaticText.new().string_("🐌: " + counter);

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c ),
		HLayout(a, b)
    )
).front;
)
```
literally so easy just "~counterUpdate.value" aaaaaaaaaaa
anyway so I went into rachel's notes for week 2 and it was there

anyway we're basically done now
it's just expanding all that a bunch
and then some audio
i'm thinking we do a nice little click when you press a button (maybe an array of a couple clicks)
and a very simple layering track that just adds a new instrument as you get achievements lol


so here's some types of things you should be able to do:
- double escargot (every time you click, 2x snails)
- escargot factory (automatically adds a snail every x seconds)
- upgrades to factory (make it faster, make it buy more per second)
- have to buy factory and upgrades with snails
- can have multiple factories
- stretch goal: can sell stuff

AUDIO:
- UI click
- layers for # of snails (ex. at 5 snails, music starts, at 100 snails get drum beat)

ok 1st things first, let's figure out the factory/automatic snails

```

// This is a really useful trick: like Pfindur but for value patterns
(
p = Pbind(
    \degree, Pif(Ptime(inf) < 4.0, Pwhite(-4, 11, inf)),
    \dur, 0.25
).play;
)
```
ok so i closed it and then opened it again and now it isn't working

```
(
var counter = 0;
var add = 0;

~counterUpdate = {
	counter = counter + add;
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter == 5, {b.visible = true});
};

~counterOne = {
	add = 1;
	~counterUpdate.value;
};

~counterTwo = {
	add = 2;
	~counterUpdate.value;
}



a = Button.new().string_("Buy 🐌").action_(~counterOne);
b = Button.new().string_("Buy 🐌🐌").action_(~counterTwo);
b.visible = false;
c = StaticText.new().string_("🐌: " + counter);

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c ),
		HLayout(a, b)
    )
).front;
)
```

ok nevermind a semicolon just got deleted at somepoint
it's working fine

https://docs.supercollider.online/Classes/Clock.html

can schedule events
so potentially we could have this call itself every 3 seconds or whatever

```
(
AppClock.sched(1.0, { |time|
    ["AppClock has been playing for ", time].postln;
});
)
```

```
(
~clock = {AppClock.sched(4.0, { |time|
    ["AppClock has been playing for ", time].postln;
	~clock.value;
});};
~clock.value;
)
```
that works beautifully
The only thing is that "appclock" isn't exactly accurate, but it's close enough for me

```
(
var counter = 0;

~counterUpdate = {
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter > 5, {b.visible = true; a.visible = false;});
	if (counter > 20, {d.visible = true;});
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
	~clock = {AppClock.sched(4.0,
		{ |time|
			["AppClock has been playing for ", time].postln;
			~counterOne.value;
			~clock.value;
	    });
	};
};

~buyAutoSnails = {
	if (counter > 20, {
		counter = counter - 20;
		~counterOne.value;
		~autoSnails.value;
	});
};

a = Button.new().string_("Buy 🐌").action_(~counterOne);
b = Button.new().string_("Buy 🐌🐌").action_(~counterTwo);
d = Button.new().string_("Buy 🐌 Factory: 20 🐌").action_(~buyAutoSnails);

d.visible = false;
b.visible = false;

c = StaticText.new().string_("🐌: " + counter);

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c ),
		HLayout(a, b, d)
    )
).front;
)
```
works BEAUTIFULLY

```
(
var counter = 0;
var factorySpeed = 4;
var factories = 0;

~counterUpdate = {
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter > 5, {b.visible = true; a.visible = false;});
	if (counter > 20, {d.visible = true;});
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
			~counterOne.value;
			~clock.value;
	    });
	};
};

~buyAutoSnails = {
	if (counter > 20, {
		counter = counter - 20;
		~counterOne.value;
		factories = factories + 1;
		d.string = "Buy Factory for 20 🐌: (" + factories + ")";
		~autoSnails.value;
	}, {e.string = "Not enough 🐌";});
};

a = Button.new().string_("Buy 🐌").action_(~counterOne);
b = Button.new().string_("Buy 🐌🐌").action_(~counterTwo);
d = Button.new().string_("Buy Factory for 20 🐌: (" + factories + ")").action_(~buyAutoSnails);

d.visible = false;
b.visible = false;

c = StaticText.new().string_("🐌: " + counter);
e = StaticText.new().string_("");

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c ),
		HLayout( e),
		HLayout(a, b, d)
    )
).front;
)
```

Now we also get an error message if we try to buy factory without enough snails


```
(
var counter = 0;
var autoSnailsNum = 0;
var factorySpeed = 4;
var factories = 0;
var factoryCost = 20;
var upgrades = 0;
var upgradeCost = 40;


~counterUpdate = {
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter > 5, {b.visible = true; a.visible = false;});
	if (counter > factoryCost, {d.visible = true;});
	if (counter > 40, {f.visible = true;});
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
			//["AppClock has been playing for ", time].postln;
			counter = counter + autoSnailsNum;
			~counterUpdate.value;
			~clock.value;
	    });
	};
};

~buyAutoSnails = {
	if (counter > factoryCost, {
		counter = counter - factoryCost;
		autoSnailsNum = autoSnailsNum + 1;
		counter = counter + autoSnailsNum;
		~counterUpdate.value;
		factories = factories + 1;
		factoryCost = factoryCost + (factoryCost/2);
		d.string = "Buy Factory for " + factoryCost + "🐌: (" + factories + ")";
		if (factories == 1, {~autoSnails.value;});
	}, {e.string = "Not enough 🐌";
		AppClock.sched(2.0,
			{ |time|
				e.visible = false;
		});
	});
};

~upgradeFactory = {
	if (counter > upgradeCost, {
		counter = counter - upgradeCost;
		~counterUpdate.value;
		factorySpeed = factorySpeed / 2;
		upgrades = upgrades + 1;
		upgradeCost = upgradeCost + (upgradeCost/2);
		f.string = "Upgrade Factory for " + upgradeCost + "🐌: (" + upgrades + ")";
	});
};

a = Button.new().string_("Buy 🐌").action_(~counterOne);
b = Button.new().string_("Buy 🐌🐌").action_(~counterTwo);
d = Button.new().string_("Buy Factory for " + factoryCost + "🐌: (" + factories + ")").action_(~buyAutoSnails);
f = Button.new().string_("Upgrade Factory for " + upgradeCost + "🐌: (" + upgrades + ")").action_(~upgradeFactory);

d.visible = false;
b.visible = false;
e.visible = false;
f.visible = false;

c = StaticText.new().string_("🐌: " + counter);
e = StaticText.new();

w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c, e ),
		HLayout(a, b, d, f)
    )
).front;
)
```
Ok I'm actually in awe of how well this is going
Like not to jinx it but wow
cookie clicker in supercollider lmao

ok let's get some spice in here — color, audio, etc

https://ccrma.stanford.edu/wiki/SuperCollider_Tweets
Coming back here and using some of the micromoog for a hihat sound

https://depts.washington.edu/dxscdoc/Help/Reference/Control-Structures.html


ok so I opened it up this morning and now something weird is going on so I'm just going to go back to the last version (the one I copied above)
and redo any audio stuff, since it wasn't really working anyway

ok nevermind the weird thing is still happening
basically I copied one of rachel's things:
```
(
SynthDef(\cfstring1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99, 1.01), Rand(0.99, 1.01)], 0, amp) }).distort * 0.2;
    eg = EnvGen.kr(Env.asr(1, 1, 1), gate, doneAction: Done.freeSelf);
    out = eg * RLPF.ar(osc, fc, 0.1);
    #a, b = out;
    Out.ar(i_out, Mix.ar(PanAz.ar(2, [a, b], [pan, pan+0.3])));
}).add;

e = Pbind(
    \degree, Pseq((-12..24), inf),
    \dur, 0.2,
    \instrument, \cfstring1
).play; // returns an EventStream
)

( // an interactive session
e.stop
e.play
e.reset
e.mute; // keeps playing, but replaces notes with rests
e.unmute;
)
```
and it broke everything
so that's fun
ugh im going to come back to this some other time

no actually i'm going to do it now
the problem has to do with what i copied from rachel's thing, once i commented stuff out and put it back it was fine so idk

```
(
a = { |tempo = 1| Ringz.ar(Impulse.ar(tempo), [501, 500], 1/tempo) }.play;
t = TempoBusClock(a);
Task { loop { "klink".postln; 1.wait } }.play(t);
);

t.tempo = 1.3;
t.tempo = 0.5;
t.tempo = 1.0;


// in ProxySpace, a TempoBusClock can be added together with a ~tempo NodeProxy:

p = ProxySpace.push(s);
p.makeTempoClock;
p.clock; // now the ProxySpace's clock is a TempoBusClock

~out.play;
~out = { Ringz.ar(Impulse.ar(~tempo.kr), [501, 500], 1/~tempo.kr) * 0.3 };
p.clock.tempo = 1.3;

// patterns and tasks are synchronized:

~out2.play;
~out2 = Pbind(\dur, 1, \note, Pwhite(0, 7, inf));

p.clock.tempo = 3;
p.clock.tempo = 1;
```
https://docs.supercollider.online/Classes/TempoBusClock.html

anyway i'm giving up on layers and i'm just going to try and have something that goes on forever but changes tempo based on the number of snails you have
i have to go pretty soon but i'll experiment with that later

below is what i have currently, no tempo stuff working

```
(
//VARIABLES
var counter = 0;
var autoSnailsNum = 0;
var factorySpeed = 4;
var factories = 0;
var factoryCost = 20;
var upgrades = 0;
var upgradeCost = 40;
var audioLayers = 0;
var milestoneReached = 0;
var curEvent = ~harmony;



//FUNCTIONS
~counterUpdate = {
	//t.beats.postln;
	counter.postln;
	c.string = "🐌: " + counter;
	if (counter == 1, {~nextLayer.value;});
	if (counter > 5, {if (milestoneReached < 1, {b.visible = true; a.visible = false; milestoneReached = milestoneReached + 1;
		//~nextLayer.value;

	})});
	if (counter > factoryCost, {if(milestoneReached < 2, {d.visible = true; milestoneReached = milestoneReached + 1;
		// ~nextLayer.value;

	})});
	if (counter > upgradeCost, {if (milestoneReached < 3, {f.visible = true; milestoneReached = milestoneReached + 1;
		// ~nextLayer.value;
	})});
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
			//["AppClock has been playing for ", time].postln;
			counter = counter + autoSnailsNum;
			~counterUpdate.value;
			~clock.value;
	    });
	};
};

~buyAutoSnails = {
	if (counter > factoryCost, {
		counter = counter - factoryCost;
		autoSnailsNum = autoSnailsNum + 1;
		counter = counter + autoSnailsNum;
		~counterUpdate.value;
		factories = factories + 1;
		factoryCost = factoryCost + (factoryCost/2);
		d.string = "Buy Factory for " + factoryCost + "🐌: (" + factories + ")";
		if (factories == 1, {~autoSnails.value;});
	}, {e.string = "Not enough 🐌";
		AppClock.sched(2.0,
			{ |time|
				e.visible = false;
		});
	});
};

~upgradeFactory = {
	if (counter > upgradeCost, {
		counter = counter - upgradeCost;
		~counterUpdate.value;
		factorySpeed = factorySpeed / 2;
		upgrades = upgrades + 1;
		upgradeCost = upgradeCost + (upgradeCost/2);
		f.string = "Upgrade Factory for " + upgradeCost + "🐌: (" + upgrades + ")";
	});
};

~tempo = {
	TempoBusClock.tempo(120 + counter);
};

// ~nextLayer = {
// 	if (audioLayers == 0, {curEvent = ~harmony;});
// 	if (audioLayers == 1, {curEvent = ~harmony2;});
// 	if (audioLayers == 2, {curEvent = ~hihat;});
// 	//t.sched(1, { curEvent.value; nil });
// 	audioLayers = audioLayers + 1;
// };



//BUTTONS
a = Button.new().string_("Buy 🐌").action_(~counterOne);
b = Button.new().string_("Buy 🐌🐌").action_(~counterTwo);
d = Button.new().string_("Buy Factory for " + factoryCost + "🐌: (" + factories + ")").action_(~buyAutoSnails);
f = Button.new().string_("Upgrade Factory for " + upgradeCost + "🐌: (" + upgrades + ")").action_(~upgradeFactory);

d.visible = false;
b.visible = false;
e.visible = false;
f.visible = false;

//TEXT
c = StaticText.new().string_("🐌: " + counter);
e = StaticText.new();



//AUDIO
//t = TempoClock.new(beats: 0);
/*~harmony = {
	{
		Pan2.ar(
			SinOsc.ar(Duty.ar(2,0,Dseq([220, 207.65, 185, 164.81], inf)), 0, 0.2)
		);
	}.play;
};

~harmony2 = {
	{
		Pan2.ar(
			SinOsc.ar(Duty.ar(0.5,0,Dseq([329.63, 329.63, 554.37, 329.63], inf)), 0, 0.2)
		);
	}.play;
};

~hihat = {play{(WhiteNoise.ar(LFPulse.kr(4,0,LFPulse.kr(1,3/4)/4+0.05))/8)!2}};

~harmony.value;
~harmony2.value;
~hihat.value;*/




//MAKE WINDOW
w = Window.new("🐌 Ester's Escargot 🐌").background_(Color.white).layout_(
    VLayout(
		HLayout( c, e ),
		HLayout(a, b, d, f)
    )
).front;
)
```

ITS NOT WORKING AGAIN
im gonna crash out

ok im going back to the first one that really worked and then im going to build back up and see if we get anywhere


OK so, it's breaking when we get to the first version with upgrading the factories
So I'm going to see what I can do about that


```
(
//VARIABLES
var counter = 0;
var autoSnailsNum = 0;
var factorySpeed = 4;
var factories = 0;
var factoryCost = 20;
var upgrades = 0;
var upgradeCost = 40;



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
			~counterOne.value;
			~clock.value;
	    });
	};
};

~buyAutoSnails = {
	if (counter > factoryCost, {
		counter = counter - factoryCost;
		~counterOne.value;
		factories = factories + 1;
		factoryCost = factoryCost + (factoryCost/2);
		d.string = "Buy Factory for " + factoryCost + "🐌: (" + factories + ")";
		~autoSnails.value;
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
```
This is working
It's also working in new, untouched documents
so hopefully that's fine


```
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
```
This is working in new doc, and is a little cleaner (not running autoSnails multiple times)
ok for audio rn what im going to try is JUST making a noise when the counter updates and that's it

https://github.com/SCLOrkHub/SCLOrkSynths
going to just steal some sounds from here

```
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
```
Added a sound for the counter going up, from here https://github.com/SCLOrkHub/SCLOrkSynths/blob/master/SynthDefs/bass/doubleBass.scd

```
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
	if (counter > 5, {b.visible = true; a.visible = false; g.unmute;});
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

(
SynthDef(\cfstring1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99, 1.01), Rand(0.99, 1.01)], 0, amp) }).distort * 0.2;
    eg = EnvGen.kr(Env.asr(1, 1, 1), gate, doneAction: Done.freeSelf);
    out = eg * RLPF.ar(osc, fc, 0.1);
    #a, b = out;
    Out.ar(i_out, Mix.ar(PanAz.ar(2, [a, b], [pan, pan+0.3])));
}).add;

g = Pbind(
    \degree, Pseq((-12..24), inf),
    \dur, 0.2,
    \instrument, \cfstring1
).play; // returns an EventStream
);
g.mute;

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
```
This is working!
ok going to try replacing rachel's synthdef with my audio

https://github.com/SCLOrkHub/SCLOrkSynths/blob/master/SynthDefs/keyboards/FMRhodes1.scd

```
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
	if (counter > 5, {b.visible = true; a.visible = false; p.unmute;});
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


//AUDIO
(
p = Pbind(
	\degree, Pseq(#[0, -1, -2, -3], inf),
    \dur, 2,
	\instrument, \FMRhodes1;
).play;
);
p.mute;


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
```


```
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
	if (counter > 5, {b.visible = true; a.visible = false; p.unmute;});
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


//AUDIO
(
g = Pbind(
	\degree, Pseq([0, -1, -2, -3], inf),
    \dur, 2,
	\instrument, \FMRhodes1;
).play;
);

(
p = Pbind(
	\degree, Pseq([Rest(1), 4, 9, 4], inf),
    \dur, 0.5,
	\instrument, \FMRhodes1;
).play;
);
p.mute;


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
```
It's beautiful
actually i'm not a huge fan of the fm sound
but like overall its really beautiful

https://github.com/SCLOrkHub/SCLOrkSynths/blob/master/SynthDefs/keyboards/cs80leadMH.scd
https://github.com/SCLOrkHub/SCLOrkSynths/blob/master/SynthDefs/drums/kick808.scd

```
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
	c.string = "🐌: " + counter;
	if (counter > 5, {if (achievement < 1, {b.visible = true; a.visible = false; ~audioLayers.value;});});
	if (counter > factoryCost, {if (achievement < 2, {d.visible = true; ~audioLayers.value;});});
	if (counter > upgradeCost, {if (achievement < 3, {f.visible = true; ~audioLayers.value;});});
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

~kick.mute;
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
```
working beautifully

https://github.com/SCLOrkHub/SCLOrkSynths/blob/master/SynthDefs/drums/hihatElectro.scd

```
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
```

I'm stopping here for today
Going to ask rachel if there's an easier way to stop checking if statement after its been satisfied in class tomorrow so that I can keep adding layers
Yay!

```
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
```
I lied about stopping, added color
