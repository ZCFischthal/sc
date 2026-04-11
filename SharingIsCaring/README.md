# 🐌 Sherry the Snail 🐌

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


