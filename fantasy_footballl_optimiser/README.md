Optimising Fantasy Football Teams Using Linear Programming
=========

This is an example of how to use the lpSolve linear programming library in R to optimise a fantasy football team. 

The code scrapes  player data from the Premier League's website and uses it to select the mathematically optimal team based on the constraints for budget and maximum players allowed per team

*DISCLAIMER*: The scraper has a time delay built in so it does not overwhelm the Premier League's website. Please do not abuse their website, we don't want to put undue strain on their servers.

## Dependencies

To use this example you will need a recent version on R installing plus the lpSolve, stringr, jsonlite, RCurl and plyr libraries. The code has been successfully tested on Windows 7, OSX 10.9 and Elementary Luna.

Martin