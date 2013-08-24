Notes on Amazing
----------------

Original source:
http://www.atariarchives.org/basicgames/showpage.php?page=3

The challenge here was figuring out the algorithm from the mass of 
single-character variable names and GOTO, IF, and computed IF statements
going all over the place. This program was also written without GOSUB,
which makes things even more challenging. How much cognitive overhead
we had to allocate in those days to keeping track of our control structures!
Dijkstra's "GOTO considered harmful" rings true here.

The algorithm works as follows: two two-dimensional arrays (`V` and
`W` in the original code, `@state` and `@visited` in mine) are
initialized to all zeroes. Array V holds the state of each spot's right
and bottom exits with a number from 0 through 3. Array W holds a number
indicating the order in which each cell was visited. After randomly selecting
a start cell on the top row, the program does a random walk through the 
unvisited cells (those where W is 0), setting W for the new cell to the 
current count and V for either the current or previous cell to an 
appropriate value to create an "exit" to the previous cell. When the current
location is surrounded on all sides by the edges of the maze or already-visited
cells, the program raster-scans until it can find a location that has already
been visited, then restarts the random walk. If the current location is on
the bottom row and an exit has not been created already (variable `Z`
in the original denotes this), then an exit is possible (variable `Q` in
the original denotes this); a random move down will flag that an exit has
been created and a raster scan as above will begin. The program continues
until all cells have been visited.

In a sense, the program operates as if it is randomly tunnelling through rock,
only digging tunnels through areas still containing rock, and only exiting
off the bottom once. When the program gets stuck, it picks a spot it has
visited before and begins tunnelling anew.

The BASIC code is more complex than it needs to be. As is, the main loop
contains a tree of IF statements determining which directions for movement
are presently available, then using random number generation to select
a direction. The code could be simplified by having the main loop simply
check all four directions and add each valid one to an array, then using
random selection from that array to pick a direction.

The use of two arrays is also not necessary; the array containing the 
state of the exits in each cell could also hold whether or not the cell
has been visited (using the value 4 for this purpose and initializing the
array to that value).

I did both of these things in the refactored version `amazing2.rb`, creating
an array of permissible move functions `dir_funcs` and choosing randomly
from it for each cell, and tracking unvisited cells in the state array
with the symbol `:unvisited`. Note that the program now must set the state
of the destination cell whenever it moves, so said cell is no longer marked
as unvisited.

Nethack players, now you can easily generate your own levels of Gehennom...