/*
This document contains code for the Scultping Gestural Space Using Envelopes Part 1 post on scottericpetersen.com.

#supercollider #envelope #Env #EnvelopeView #Plotter
(c) scott petersen 2021
*/

// Ex 1a -- Linear Ramp (up-down) plot

Env([0,1,0], [0.5,0.5]).plot

// Ex 1b -- curves

[ Env([0,1], 1, 'lin'), Env([0,1], 1, 'sine'), Env([0,1], 1, 4), Env([0,1], 1, -4) ].plot("curves");

/* Using Plotter with editMode = true to easily create custom arrays for amplitudes or frequencies. Here, we use it to generate a series of harmonic partials.*/

// Ex. 2 -- plotter
a = (0..40).plot; // create a Plotter object
a.editMode = true; // now edit the data by clicking into the plot..
a.value; // print the value
b = a.value.normalize(0.0, 1.0); // assign the array to a new variable with amplitude ranges of 0.0-1.0
b.plot;
play { Mix(SinOsc.ar(Array.fill(b.size, {|i| i = i + 1; 75 * i}), mul: b * 0.05)) }; // b supplies amplitudes for the partials here

// Ex. 3 -- two plotters as envelope data

a = (0..10).plot("values").editMode = true; // values
b = (0..9).plot("times").editMode = true; // times -- one less than values
c = Env(a.(), b.()).plot(name: "Resulting Envelope"); // use the results in your Env

/* Ex. 4 -- EnvelopeView

From help:

Nodes can be selected and moved using mouse. Shift-clicking a node will add it to the selection.

You can also move selected nodes and change selection using keyboard. Pressing the arrow keys will move selected nodes (as long as -step is larger than 0). Pressing the left or right arrow keys while holding down Alt will select previous or next node, and holding down Shift will extend selection to the left or to the right. Other GUI kits may differ.

*/

(
w = Window("EnvelopeView", Rect(150 , Window.screenBounds.height - 250, 1000, 500)).front;
w.view.decorator = FlowLayout(w.view.bounds);

b = EnvelopeView(w, Rect(0, 0, 995, 490))
.value_([Array.fill(10, {|i| i = i + rrand(0.01, 0.1)}).normalize,Array.fill(10, {rrand(0.001, 1.0)}).normalize ])
.grid_(Point(0.1, 0.1))
.gridOn_(true)
.drawLines_(true)
.selectionColor_(Color.red)
.drawRects_(true)
.step_(0.005)
.action_({arg b; [b.index, b.value].postln})
.thumbSize_(10)
.keepHorizontalOrder_(true)
;
w.front;
)

// Convert the array from X coordinates to times:
c = b.();
d = Array.fill(c[0].size -1, {|i| c[0][i + 1] - c[0][i] });
Env(c[1], d).plot;

// save the arrays in plain text:

c.postln;
// [ [ 0.0, 0.11, 0.29, 0.34, 0.4, 0.56, 0.66, 0.77, 0.85, 1.0 ], [ 0.98, 0.0, 0.15, 0.91, 0.245, 0.41, 0.41, 1.0, 0.455, 0.8 ] ]

// convert to desired ranges (values, times) as needed
play { SinOsc.ar(Env(c[1].linlin(0.0, 1.0, 400, 800), d.linlin(0.0, 1.0, 0.0, 5.0)).kr) }
