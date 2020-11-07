# Tic-Tac-Toe

This is an unbeatable game of tic tac toe built using the Minimax algorithm.

Describing Minimax
The key to the Minimax algorithm is a back and forth between the two players, where the player whose "turn it is" desires to pick the move with the maximum score. In turn, the scores for each of the available moves are determined by the opposing player deciding which of its available moves has the minimum score. And the scores for the opposing players moves are again determined by the turn-taking player trying to maximize its score and so on all the way down the move tree to an end state.

A description for the algorithm, assuming X is the "turn taking player," would look something like:

* If the game is over, return the score from X's perspective.
* Otherwise get a list of new game states for every possible move
* Create a scores list
* For each of these states add the minimax result of that state to the scores list
* If it's X's turn, return the maximum score from the scores list
* If it's O's turn, return the minimum score from the scores list
* You'll notice that this algorithm is recursive, it flips back and forth between the players until a final score is found.

Let's walk through the algorithm's execution with the full move tree, and show why, algorithmically, the instant winning move will be

Author : Tourahi Amine
