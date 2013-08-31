Awari
-----

Original source:

http://www.atariarchives.org/basicgames/showpage.php?page=6

http://www.atariarchives.org/basicgames/showpage.php?page=7

The BASIC source for Awari is already fairly structured, with subroutines for printing the board, processing moves, getting player moves, computing computer moves, and checking for victory. It was thus straightforward to port into Ruby. The interesting part was deciphering the decision process for the computer's moves.

The computer player uses a minimax strategy with one-move lookahead. For each legal computer move, it saves the board, processes that move, then looks at all possible legal human moves at that point, approximating the maximum possible net gain for the human player from one of those moves. It then chooses the computer move that minimizes that maximum. 

The game also keeps track of the first eight moves of each game in the current set of games that ended in a draw or human victory. When considering a move, the computer increases the gain to the human by 2 points for each game in that list where the current move sequence plus the computer's possible move is a prefix. Thus, it tries to avoid sequences of moves that led to it not winning in the past. The BASIC program keeps track of these eight-move initial sequences as numbers computed thusly, where a move is one of the six possible moves, numbered 0 through 5:

`move8 + 6*(move7 + 6*(move6 + 6*(move5 + 6*(move4 + 6*(move3+6*(move2+6*move1))))))`

which equals

`move8 + 6*move7 + 6^2*move6 + ... + 6^6*move2 + 6^7*move1`

To perform the prefix check, the computer checks if `candidate_move + 6*current_state = floor(past_game_encoding / 6^(7-N)`, where N is the number of moves already made. In the Ruby version, I simply maintain an array of arrays of move sequences and check for equality against each of them.

The move evaluation algorithm the computer uses does not entirely reflect the rules of the game, as it doesn't consider potential double-moves by either itself or the human, or exactly compute the net gain for potential human moves. This would be fairly straightforward to implement in Ruby, as keeping track of game states is a simple matter of pushing and popping them on and off an array.