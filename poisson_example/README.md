Example Poisson Model For Predicting Football Scores
=========

This is example code from a [presentation](http://pena.lt/y/2014/11/02/predicting-football-using-r/) I gave to the Manchester R Users Group showing how to create a Poisson model for predicting football using R.

Warning - this code is simplified to provide a basic example, it is not designed for routine use and you are liable to lose your money if you bet with it. 

To make a working model you will need, as a minimum, to incorporate Dixon and Coles adjustment to account for the dependency in the score lines. See [Dixon and Cole's paper](http://www.math.ku.dk/~rolf/teaching/thesis/DixonColes.pdf) for more details on how to do this. 

You are also recommended to add a time decay to the training data so more recent fixtures carry a heavier weighting in the model fit and combine it all with a realistic staking strategy.