Notes on Animal
---------------

Original source pages:

http://www.atariarchives.org/basicgames/showpage.php?page=4

http://www.atariarchives.org/basicgames/showpage.php?page=5

At the heart of Animal is a binary tree where the leaf nodes represent
the animals and the interior nodes represent questions to decide among
them. In the original program, the tree is represented by an array of 
strings, where the question strings have the format 
`\Q[question]\Y[yes_node]\N[no_node]\` and the animal strings have 
the format `\A[animal_name]`; the node pointers are simply array indexes. 
In the Ruby port, I implemented the tree in a more naturalistic way, using
a `Node` class with subclasses `Question` and `Animal`. My version is less
compact but hopefully more understandable.

For a true early '80s experience the game should be played with caps lock
active, but to help those who don't, I convert all player responses to
all upper case.

Note that although the dialect of BASIC used for this program has
`GOSUB`, and the authors use it on line 170, they don't use it for the 
routine to print the list of known animals, which uses `GOTO` to enter
and exit.
