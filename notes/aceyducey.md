Notes on Acey-Ducey
-------------------

Original source:
http://www.atariarchives.org/basicgames/showpage.php?page=2

I've never heard of a card game by this name, but I have heard of a
backgammon variant named "Acey-Deucey", where the key differences are
(a) that all pieces have to be "brought on" to the board instead of having 
a fixed starting configuration, and (b) the roll 1-2 has a special effect.

If I were implementing the game from scratch, I'd actually model a deck
of cards with objects - the existing game simply generates new random 
numbers from 2 to 14 when it needs a card, as if it were drawing from 
an infinite-deck shoe.
