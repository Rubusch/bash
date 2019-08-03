ASSIGNMENT06
Lothar Rubusch

Lothar's Version of Maze algorithm / Depth First Search

The Robot takes the coordinates of the Goal in X and Y and makes the difference
to its current position dX and dY. Based on this it makes up a list of the for
next directions to go by priority:
"higher difference in X or Y" "higher difference in X or Y"
"less deviation in X or Y" "less deviation in X or Y", e.g.:
"down" "right" "left" "up"

In the next step, when "down" is not possible, e.g. blocked by a wall, or a
field where the robot already was, it goes "right". If "right" is not possible,
it goes "left", and so on. Means the list of priorized directions is compared
with a list of possible directions in each step.

For that, it keeps a list of coordinates where it already was. Always it passes
a point with more than one way to go ( = "ahead", since back is blocked because
already passed), it puts the coords on a stack of "fork points".

It tries to follow the paths so to the depth. But when the robot comes to a
point where there is no further possibility than moving into a field where it
already was, lets him pop the "stack of fork points" as position to go back. At
this position it starts over with the same analysis, but since it already passed
one option, it takes the other. If the poped solution does not have any 
possibilities anymore, since all surrounding fields are already passed, it pops
again.


ISSUES:
The script is working, although it's still a bit messy with debugging comments.
It is commented, but not fully cleaned up, due to lack of time and other
assignments.


The script runs on Bash, and was developped on Debian / Linux.

Start the program:
$> ./maze.sh

Stop it
CTRL+C


Best regards,
Lothar Rubusch


