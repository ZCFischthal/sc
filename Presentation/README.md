# Presentation Doc

### https://github.com/Steftones/Birb

#### Presentation Outline
- Make someone try and get it running as a little audience participation opening — literally just be like here's the scd file, I'm going to open it, now try and get it working
- The thing I like most about it is that it's SO easy to get up and running. You have to cmd-enter 2x, but otherwise very accessible. I did change it a little — the person who created it has their own reverb ugen, which I don't have, so I had to switch it out for one of supercollider's (freeverb), but other than that, it works immediately
    - they just put parentheses around everything and you can just boot, cmd-return, and it works
- I'm going to be mostly focusing on the ui today, bc that's the thing that really drew me to this project over the others i looked at — we really haven't talked about how to do any of this, and I think it does just make the project so much more accessible to a newcomer like me, and also makes it more like the sort of thing I could show to my friends
- Also really like the look of the ui — it's so simple, and old-school. the ascii art really does it for me
    - show edited versions with different art style birds in there
- The glitches are also really great
- some things i don't like:
    - not immediately clear what everything does. in a way it's kind of nice bc it leads to experimentation, which can be fun, but it's also a little annoying
    - the window doesn't resize, so it looks a little odd if you change it at all

- how do they do all this?
    - Here's the code!
        - 1stly, it's pretty well organized. All the audio stuff is together, all the ui stuff is together.
        - UI is also ordered really nicely. The code is pretty linear, with the only time I had to jump back being something I'll talk about later — the auto button, which calls a function that's actually above itself
    - you can see that they're creating the window, then the stuff that's going to go on it
    - it's really easy to read
    - the big thing that's out of the ordinary for me is the images, which are done like this:
        -(show the literal screenshots of the code)
    - these text images are in an array called ~birdStrings, which is then called on by a function called ~drawBird
    - ~drawBird is called on in every button except for the "auto" button, which calls a function called ~rout that repeatedly calls drawBird in a loop
And that's it! Any questions?

#### Links
https://favpng.com/png_view/smurfs-tweety-looney-tunes-cartoon-drawing-clip-art-png/agdV4uaY

http://pngimg.com/download/20091

https://www.oldbookillustrations.com/illustrations/snowy-owl-gould/



#### Notes
Just playing around in it, took a few minutes to get it running
Creator is using a reverb they created/their own ugen — it isn't included, so you have to find where that is in the script and replace it with freeverb or another ugen
not immediately obvious what the sliders do just by playing with it — no text to tell you
The button text isn't always super clear either — I guess 1 and 2 are "regular" bird noises, and W is a woodpecker. The bottom 3 are more clear, and I guess it makes sense that dafuq? wouldn't actually tell you what it does lol
The bird itself really works for me, I don't think it would be AT ALL the same if it was a picture of a bird or something
And the way it glitches rocks

I really like that the code pretty much does just work out of the box, except for the one reverb thing
There's parentheses around everything, so you just boot, click anywhere and cmd-return and that's it. There's no searching for all the things you need to put on the server and making sure they're in the right order and then having to play them, everything is in this really nice interface after starting it up

the main reason i wanted to do this one is bc of the UI stuff — we haven't touched on that at all in class and i feel like its something that makes supercollider more approachable and like, something i could actually mess around with and show my friends
so let's get into how they actually do all that


Here's sort of all the ui stuff
```
~ui = Dictionary[
	\font -> Dictionary[
		\global -> Font("Hiragino Sans", 12),
		\title -> Font("Hiragino Sans", 110),
		\bird -> Font("Monaco", 3.5, true),
	],
	\color -> Dictionary[
		\background -> Color.fromHexString("#F5F5F5"),
		\slider -> Color.fromHexString("#FFF6F6"),
		\button -> [
			"#E0E0E0",
			"#FFBA49",
			"#99EBE8",
			"#EF5B5B"
		].collect({ |color| Color.fromHexString(color) }),
		\bird -> Color.black,
	],
	\bounds -> Dictionary[
		\window -> Rect(400, 400, 600, 412),
		\title -> Rect(10, 12.5, 300, 100),
		\editSlider -> Rect(20, 130, 200, 50),
		\fxSlider -> Rect(20, 200, 200, 50),
		\bird1 -> Rect(20, 270, 50, 50),
		\bird2 -> Rect(95, 270, 50, 50),
		\woodPecker -> Rect(170, 270, 50, 50),
		\makeNewFxButton -> Rect(20, 340, 50, 50),
		\autoOn -> Rect(95, 340, 50, 50),
		\shh -> Rect(170, 340, 50, 50),
		\ascii -> Rect(220, 10, 400, 400),
	],
];

~granularEffects.set(\wetAmount, 0);

w = Window.new("Birb", ~ui[\bounds][\window])
.front
.background_(~ui[\color][\background])
.alwaysOnTop_(true);

StaticText(w, ~ui[\bounds][\title]).string_("birb.")
.font_(~ui[\font][\title]);

Slider.new(w, ~ui[\bounds][\editSlider])
.font_(~ui[\font][\global])
.background_(~ui[\color][\slider])
.value_(0)
.action_({
	|slider|
	~editValue = slider.value;
});

Slider.new(w, ~ui[\bounds][\fxSlider])
.font_(~ui[\font][\global])
.background_(~ui[\color][\slider])
.value_(0)
.action_({
	|slider|
	~fxSliderValue = slider.value;
	~recordBufferPlaybackSynth.set(\edit, slider.value);
});

~globChoices = Pxrand([0, 0, 1, 2], inf).asStream;
~globTypes = Pxrand([0, 0, 0, 1, 2, 3, 4, 6], inf).asStream;

Button(w, ~ui[\bounds][\bird1])
.font_(~ui[\font][\global])
.states_([
	["1", nil, ~ui[\color][\button][0]],
])
.action_({
	s.bind {
		Synth(\otherBirds, [
			envSelect: ~globTypes.next,
			speed: 1/4,
			edit: ~editValue,
			choice: ~globChoices.next,
			speed: 1/8,
			out: ~recordBufChannel,
		]);
	};
	rrand(2,4).do {
		s.bind { ~drawBird.(~editValue, ~fxSliderValue); };
	};
});

Button(w, ~ui[\bounds][\bird2])
.font_(~ui[\font][\global])
.states_([
	["2", nil, ~ui[\color][\button][0]],
])
.action_({
	fork {
		var waits = rrand(1/8, 1/5);
		rrand(3, 7).do {
			var bird;
			s.bind {
				bird = Synth(\shortBird, [out: ~recordBufChannel, edit: ~editValue ]);
				~drawBird.(~editValue, ~fxSliderValue);
			};
			waits.wait;
			s.bind { bird.free };
		};
	};
});

Button(w, ~ui[\bounds][\woodPecker])
.font_(~ui[\font][\global])
.states_([
	["W", nil, ~ui[\color][\button][0]],
])
.action_({
	fork {
		rrand(5, 16).do {
			s.bind {
				Synth(\woodpecker, [freq: rrand(1, 10), out: 0, edit: ~editValue]);
				~drawBird.(~editValue, ~fxSliderValue);
			};
			(1/16).wait;
		};
	};
});

~returnButtonStates = {
	|text, variable|
	[
		[text, nil, nil],
		[text, nil, variable]
	];
};

Button(w, ~ui[\bounds][\makeNewFxButton])
.font_(~ui[\font][\global])
.states_(~returnButtonStates.("dafuq?", ~ui[\color][\button][1]))
.action_({
	|button|
	s.bind { ~granularEffects.set(\makeFx, button.value); };
});

Button(w, ~ui[\bounds][\autoOn])
.font_(~ui[\font][\global])
.states_(~returnButtonStates.("auto", ~ui[\color][\button][2]))
.action_({
	|button|
	if(button.value === 1, { ~rout.play }, { ~rout.stop });
});

Button(w, ~ui[\bounds][\shh])
.font_(~ui[\font][\global])
.states_(~returnButtonStates.("shhhh", ~ui[\color][\button][3]))
.action_({
	|button|
	s.bind { ~granularEffects.set(\isNice, button.value); };
});


~baseStrings = [
	[1,1,1,1],
	[1,1,2,2],
	[1,2,3,2],
	[1,2,3,4],
];

~drawBird = {
	|edit, fxLevel|
	var editCalc = edit.linlin(0,1,0,3).ceil();
	fork {
		var firstString, secondString, addExtra;
		firstString = " ";
		fxLevel.linexp(0, 1, 43, 10).do {
			firstString = firstString + " "
		};
		secondString = firstString;
		addExtra = 0.5.coin;

		fxLevel.linlin(0, 1, 43, 10).do {
			if(addExtra,
				{ secondString = secondString + " " },
				{ secondString = secondString[0..(secondString.size - 2)] },
			);
		};

		rrand(2,4).do {
			var toPaint = ~birdStrings[~baseStrings[editCalc].choose];
			if ((fxLevel - 0.1).coin, {
				toPaint = [
					toPaint.reverse(),
					toPaint.scramble(),
					toPaint.rotate(rrand(200,1300)),
					toPaint.replace(firstString, secondString),
					// toPaint.replace(firstString, secondString.replace(" ", replace: "-")),
				].wchoose(
					[
						1/8,
						1,
						2,
						2,
						// 2,
					].normalizeSum;
				);
			});
			{ ~asciStuff.string_(toPaint) }.defer;
			rrand(1/24,1/16).wait;
		};
		{ ~asciStuff.string_(~birdStrings[0]) }.defer;
	};
};
```
And then they've got these images literally typed out with symbols like @, +, etc. (i didn't put them in this doc but they're in my presentation itself)

The way the code is laid out is pretty nice
All the UI stuff is in one place, all the audio is in one place, everything's divided really nicely
With UI, they start by defining all the stuff they're going to use — fonts, colors, and the window itself
Sliders are together, buttons are together

They've got this "~drawBird" func at the bottom, which is choosing from these different ASCII birds
And that function is called in most of the buttons, and also in this ~rout function, which is itself called on the one button that doesn't directly call it — the "auto" button. ~rout calls ~drawbird in a loop, so it's what's making that one loop and turn on/off, while the others just call ~drawBird 1x, directly


### some options
* https://soundcloud.com/mimetik/musical-toys-for-little-robots
* https://sccode.org/1-4S9
* https://scsynth.org/t/little-an-80s-glitchy-thing-with-jazz-chords/9959
* https://github.com/Steftones/Birb
* https://vimeo.com/961502160
* https://github.com/iamsiriil/sc_sudokusound/tree/master/src/sc


