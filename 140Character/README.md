# 140 Dr. Umentation

### Messing Around
Went to provided link: https://ccrma.stanford.edu/wiki/SuperCollider_Tweets#
Tossed "micromoog" into supercollider
Listened to it, didn't really care for it
Went to look at my notes from class instead and see what I can do there
Meh not vibing with that either/not getting any ideas
Went back to looking at micromoog — maybe can just change some of the sounds and see?
I like this:
```
{WhiteNoise.ar(LFPulse.kr(4, width: 0.05))}.play
```

Something like below based on 2nd half of micromoog

```
{SinOsc.ar(LFPulse.kr(LFPulse.kr(1/2,1/4,1/4)*2+2,1,-20,50))}.play
```

Their documentation explains the inner part with the 1/2,1/4 etc., but I still don't really get it
Looking here https://doc.sccode.org/Classes/LFPulse.html to see if that helps me


This is fun
```
{ LFPulse.ar(500, 0, MouseX.kr, 0.5) }.scope;
```
Now looking at randomness in supercollider docs
I like rrand(#, #)

something like this might be nice
```
{SinOsc.ar(440, 0, 1, 0.1) + LFPulse.ar(500, 0, 0.5, 0.1, 0)}.play;
```

I think my headphones might be broken, only stuff coming from the left
Nope, other audio working
I guess I didn't do something to make the supercollider stuff stereo
so i guess that's why we always put pan2 at the beginning of stuff in class

Where I'm at, having added some MouseX mousey (remembered from class, checked supercollider documentation)
```
{Pan2.ar(SinOsc.ar(MouseX.kr(40, 1000, 1), 0, 0.1) + LFPulse.ar(MouseY.kr(40, 1000, 1), 0, 0.5, 0.1))}.play;
```
Fun to play around but not actually fun to listen to

Took a look at next thing in the 140 doc, headcube 1

```
{LocalOut.ar(a=CombN.ar(BPF.ar(LocalIn.ar(2)*7.5+Saw.ar([32,33],0.2),2**LFNoise0.kr(4/3,4)*300,0.1).distort,2,2,40));a}.play
```
This one's very fun

```
LFNoise0.kr(2).range(500, 5000)
```
Above bit gave me understanding of how to randomize pitch better
```
{Pan2.ar(SinOsc.ar(LFNoise0.kr(2).range(130.813, 523.251), 0.1, 0.1))}.play;
```

https://sengpielaudio.com/calculator-notenames.htm help me pick pitches

```
{Pan2.ar(SinOsc.ar(LFNoise0.kr(2).range(130.813, 523.251), 0.1, 0.1)) + LFPulse.ar(MouseY.kr(40, 1000, 1), 0, 0.5, 0.1)}.play;
```
more fun
still don't like the total randomness

continued looking in headcube
made this 
```
{Pan2.ar(CombN.ar(SinOsc.ar(LFNoise0.kr(2).range(130.813, 523.251), 0.1, 0.1), 3, 0.25, 3))}.play;
```
only 98 characters

now looking at headcube 2

```
{Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(1/5,0,Dseq([92.4986, 103.826, 116.541, 138.591, 155.563], 4)), 0.1, 0.1), 3, 0.25, 3))}.play;
```
kind of works — putting in duty.ar and dseq so it chooses randomly from pitches I choose instead of a random range. But it stops at a certain point and just holds a pitch

oh it's just repeating as many times as I have it after the array (4)

checked the docs and found dshuf, very nice
want to find a way to have them randomly shuffle forever though

```
{Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(2/3,0,Dshuf([466, 554, 622, 740, 831], 4)), 0.1, 0.1).loop.asStream, 3, 0.25, 3))}.play;
```
https://docs.supercollider.online/Reference/loop.html
supposedly the first one loops forever but I can't figure out how to get it to actually work

```
f = {Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(2/3,0,Dshuf([466, 554, 622, 740, 831], 4)), 0.1, 0.1), 3, 0.25, 3)).yield};
x = Routine({f.loop});
10.do({x.next.postln})
```

I just looked it up and changing the "[], 4" to "[], inf" did the trick (https://composerprogrammer.com/teaching/supercollider/sctutorial/3.3%20Sequencing.html)

but what I actually want it to do is keep randomly picking from within duty.ar as opposed to picking a random order at the beginning and going forever

tried this
```
{Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(2/3,0,Dshuf([466, 554, 622, 740, 831], 4)), 0.1, 0.1)*inf, 3, 0.25, 3))}.play;
```
and it was awful so don't do that

```
var a;
a ={ {Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(2/3,0,Dshuf([466, 554, 622, 740, 831], 1)), 0.1, 0.1), 3, 0.25, 3))}.play};
a.play;
```
with this, I can just keep cmd-enter on a.play;
it's a start


I did it!!!!!
```
{Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(2/3,0,Dshuf([466, 554, 622, 740, 831]*(Dshuf([0.3, 0.6, 0.9],1)), inf)), 0.1, 0.1), 3, 0.25, 3))}.play;
```
I was messing around with multiplying the 1st dshuf by different numbers so that when I hit a.play again it wouldn't have the same pitches, but then I realized I could put a dshuf instead of just a number. that returned way more than just 1 loop like it had been and I realized that bc both dshufs had a # of loops thing in it, then I could have 1 be 1 within the other and have the other be infinity and we still wouldn't get the same pitches all the time
I picked .3, .6, .9 by random but they're pretty sonorous w each other so it works out
AND it's 139 characters :)

```
{Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(2/3,0,Dshuf([466, 554, 622, 740, 831]*(MouseX.kr(0.3, 2)), inf)), 0.1, 0.1), 3, 0.25, 3))}.play;
```
also cool, 132 characters

having mouse.kr for the length of the notes would be really cool actually but idk how to fit it in w the # of characters


```
{Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(MouseX.kr(1/6, 5/6),0,Dshuf([466, 554, 622, 740, 831]*(Dshuf([0.3, 0.6, 0.9],1)), inf)))))}.play;
```
This is under! (133 characters)

```
{Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(MouseX.kr(1/20, 1/2),0,Dshuf([466, 554, 622, 740, 831]*(MouseY.kr(0.3, 1.2)), inf)))))}.play;
```
Messed around some more, this might be what I stick with (129 characters)



https://depts.washington.edu/dxscdoc/Help/Classes/DegreeToKey.html


I'd like to get some harmony in there or something, maybe a beat
So it's not just the random notes


maybe something like this but it's 5 characters over
```
{Pan2.ar(CombN.ar(SinOsc.ar(Duty.ar(MouseX.kr(1/20, 1/2),0,Dshuf([466, 554, 622, 740, 831]*(MouseY.kr(0.3, 1.2)), inf)))))*MouseX.kr(1, 3)}.play;
```




