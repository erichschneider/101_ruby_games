Battle
------

Original source:
http://www.atariarchives.org/basicgames/showpage.php?page=15
http://www.atariarchives.org/basicgames/showpage.php?page=16
http://www.atariarchives.org/basicgames/showpage.php?page=17

The most interesting part of this game is the code for placing ships.
The ships are placed in descending order of length. For each one, a
random position and direction (N-S, NE-SW, E-W, NW-SE) is generated.
The program then checks if the chosen direction is clear; if it is,
the program moves forward in the chosen direction looking for clear
spaces. If an obstruction is found, the progarm returns to the start
point and tries moving backward in the chosen direction. If it cannot
allocate all of the spaces for the ship, it tries another random
position and direction. There are also rules to prevent diagonal ships
interpenetrating. The BASIC program uses four distinct subroutines for 
each direction; I combined them into one, using variables to represent the 
direction of desired movement.

For some reason the BASIC author decided to record a running total of hits
on each ship which started higher for the smaller ships, rather than giving
each ship a damage capacity to start with and decrementing down to zero.
