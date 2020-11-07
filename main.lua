-- utils
local utils = require "utils";

-- Globals
HUMAN = -1;
COMP  = 1;
board = {
  {0,0,0},
  {0,0,0},
  {0,0,0}
};
infinity  = 1e309;

-- OS related
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function evaluate(state)
--  Function to heuristic evaluation of state.
-- :param state: the state of the current board
-- :return: +1 if the computer wins; -1 if the human wins; 0 draw
  local score;
  if wins(state,COMP) then
    score = 1;
  elseif wins(state,HUMAN) then
    score = -1;
  else
    score = 0;
  end
  return score;
end

function wins(state,player)
  ---
  -- This function tests if a specific player wins in this range of possibilities :
  --  * Three rows    [X X X] or [O O O]
  --  * Three cols    [X X X] or [O O O]
  --  * Two diagonals [X X X] or [O O O]
  --  :param state: the state of the current board
  --  :param player: a human or a computer
  --  :return: True if the player wins
  ---
  win_state = {
    {state[1][1], state[1][2], state[1][3]},
    {state[2][1], state[2][2], state[2][3]},
    {state[3][1], state[3][2], state[3][3]},
    {state[1][1], state[2][1], state[3][1]},
    {state[1][2], state[2][2], state[3][2]},
    {state[1][3], state[2][3], state[3][3]},
    {state[1][1], state[2][2], state[3][3]},
    {state[3][1], state[2][2], state[1][3]},
  }
  for i,v in ipairs(win_state) do
      if table.concat({player, player, player}) == table.concat(v) then
        return true;
      end
  end
  return false;
end

function game_over(state)
  -- Return true if either of the players won
  return wins(state,HUMAN) or wins(state,COMP);
end

function empty_cells(state)
--  Each empty cell will be added into cells' list
-- :param state: the state of the current board
-- :return: a list of empty cells
  local cells = {};
  for x,row in ipairs(state) do
    for y,cell in ipairs(row) do
      if cell == 0 then
        table.insert(cells,{x,y});
      end
    end
  end
  return cells;
end

function valid_move(x,y)
  --- test if a move is valid
  local cells = empty_cells(board);
  for i,v in ipairs(cells) do
      if table.concat({x, y}) == table.concat(v) then
        return true;
      end
  end
  return false;
end

function set_move(x,y,player)
  if valid_move(x,y) then
    board[x][y] = player;
    return true;
  else
    return false;
  end
end

--- The minmax Algo

function minimax(state,depth,player)
  -- :return: a list with [the best row, best col, best score]
  local best,score;
  local Cstate = utils.table_deep_copy(state); -- Make the state local for each iteration
  if player == COMP then
    best = {-1,-1; -infinity};
  else
    best = {-1,-1; infinity};
  end

  if depth == 0 or game_over(Cstate) then
    score = evaluate(Cstate);
    return {-1, -1, score};
  end

  for i,cell in ipairs(empty_cells(Cstate)) do
    x,y = cell[1] ,cell[2];
    Cstate[x][y] = player;
    score = minimax(Cstate, depth - 1, -player);
    Cstate[x][y] = 0;
    score[1], score[2] = x, y;
    if player == COMP then
      if score[3] > best[3] then
        best = score; -- max value
      end
    else
      if score[3] < best[3] then
        best = score; -- min value
      end
    end
  end
  return best;
end

function clearScreen()
  local os_name = os.capture("uname");
  if os_name == "Linux" then
    os.execute("clear");
  else
    os.execute("cls")
  end
end

function render(state,c_choice,h_choice)
  chars = {
    [-1]=h_choice,
    [1]= c_choice,
    [0]=" "
  };
  local str_line = "--------";
  print(str_line);
  for i,row in ipairs(state) do
    for j,cell in ipairs(row) do
      symbol = chars[cell]
      io.write("|",symbol,"|");
    end
      io.write("\n");
      print(str_line);
  end
end

function ai_turn(c_choice, h_choice)
-- It calls the minimax function if the depth < 9,
-- else it choices a random coordinate.
  depth = utils.getTableSize(empty_cells(board));
  if depth == 0 or game_over(board) then
    return;
  end
  clearScreen();
  io.write("Computer turn ",c_choice,"\n");
  render(board, c_choice, h_choice);
  if depth == 9 then
    x = utils.randomchoice({0, 1, 2});
    y = utils.randomchoice({0, 1, 2});
  else
    move = minimax(board, depth, COMP);
    x, y = move[1], move[2];
  end
  set_move(x,y,COMP);
  utils.sleep(1);
end

function human_turn(c_choice, h_choice)
  depth = utils.getTableSize(empty_cells(board));
  if depth == 0 or game_over(board) then
    return;
  end
  local move = -1;
  moves = {
    {1, 1},{1, 2},{1, 3},
    {2, 1},{2, 2},{2, 3},
    {3, 1},{3, 2},{3, 3},
  };
  clearScreen();
  io.write("Human turn ",h_choice,"\n");
  render(board, c_choice, h_choice);
  while move < 1 or move > 9 do
    io.write("Use the numpad (1..9): ");
    move = io.read("*n");
    coord = moves[move];
    can_move = set_move(coord[1], coord[2], HUMAN);
    if not can_move then
      io.write("Bad move !!");
      move = -1;
    end
  end
end

function main()
  --- This is the main function that will call all the functions above ---
  clearScreen();
  local h_choice = '';  -- X or O
  local c_choice = '';  -- X or O
  local first = '';  -- if human is the first

  -- Human chooses X or O
  while h_choice ~= "O" and h_choice ~= "X" do
    print('');
    io.write("Choose X or O\nChosen: ");
    h_choice = io.read();
    h_choice = string.upper(h_choice);
    ----------------------------------
    if h_choice == 'X' then
      c_choice = 'O';
    else
      c_choice = 'X';
    end
    clearScreen();

    while first ~= 'Y' and first ~= 'N' do
      io.write("First to start?[y/n]: ");
      first = io.read();
      first = string.upper(first);
    end
    ---------------------------
    --- Main game loop ---
    while utils.getTableSize(empty_cells(board)) > 0 and not game_over(board) do
      print("Debbug")
      if first == 'N' then
        ai_turn(c_choice,h_choice);
        first = '';
      end
      human_turn(c_choice, h_choice)
      ai_turn(c_choice, h_choice)
    end

    ---------------------------
    --- Game over Messages
    if wins(board, HUMAN) then
      clearScreen();
      io.write("Human turn ",h_choice);
      render(board, c_choice, h_choice);
      print('YOU WIN!');
    elseif wins(board, COMP) then
      clearScreen();
      io.write("Computer turn ",c_choice);
      render(board, c_choice, h_choice);
      print('YOU LOSE!');
    else
      clearScreen();
      render(board, c_choice, h_choice);
      print('DRAW!');
    end

  end
end


main();
