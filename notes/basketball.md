Basketball
----------

Original source:
http://www.atariarchives.org/basicgames/showpage.php?page=13

The BASIC version of this program has some functionality broken out into subroutines (scoring, free throws), but the bulk of it is a loop that bounces back and forth between two sections resolving the player's and computer's plays (lines 425 and 3000 in the BASIC). This translates into the `play_game` method in the Ruby. 

The BASIC source contains two bits of vestigial code that are never reached in the existing control flow. One is the section from lines 1180 through 1195, which would handle a Dartmouth player being fouled or the ball being stolen from them. The other is line 3015, which would invoke the "two minute warning" routine when it occurs during an opponent's play. I have included mentions of these at appropriate places in the Ruby as comments, but not incorporated them into the running program.
