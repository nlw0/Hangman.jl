# Hangman.jl
Hangman game with a Mealy machine in Julia.

<img src="hangman.png">

This project illustrates how to implement a Mealy machine, following the same idea from the [inspiring talk](https://www.youtube.com/watch?v=WGT9_cEImAk) by Joshua Ballanco from JuliaCon2019. We rely on multiple dispatch, and define state transitions and outputs by writing a multimethod `trans` that takes in  a state-input pair and return a state-output pair.

The idea is that first we can implement the game of "Hangman" as a Mealy machine, in an abstract way. Then later we create a GUI with Gtk.jl on top of this Hangman.jl module. The GUI code sends input objects to the machine, and handles the output objects coming out of it. The game logic is thus completely separated from the interface.

Tests show how to produce a list of outputs and states given a list of inputs, something that can be very handy to test complex applications.
