
boardSprites = {
    [0] = " ",
    [1] = "X",
    [2] = "O"
};

function Randomis() -- Get a num BTW 1-2
    math.randomseed(os.time());
    return math.random(1,2); 
end

-- The game class
-- turn(1 = ME, 2 = Cptr) , turnCount
Game = { turn,turnCount,board,Ctkn,Utkn };
Game.__index = Game;
-- Derived class method new
function Game:new(o)
    local o = o or {};
    setmetatable(o, self);
    self.turn = Randomis();
    self.turnCount = 0;
    self.Ctkn  = 'O';
    self.Utkn  = 'X';
    self.board = {
        1,0,0,
        1,0,0,
        1,0,0
    };
    return o;
end

function Game:isEmpty(pos)
    return self.board[pos] == 0;
end

function Game:promptUser()
    io.write("Please select a square,from top left :[1-9] ");
    local pos = io.read();
    return tonumber(pos);
end

function Game:playTurn()
    local pos;
    if turn == 1 then
        pos = self:promptUser();
        while (self:isEmpty(pos) == false )
        do
            io.write("Please choose an empty square.\n");
            pos = self:promptUser();
        end
    else
        -- Computer
    end
    self.board[pos] = turn;
end

function Game:getSprite(ind)
    return boardSprites[ind];
end

function Game:draw()
    for pos=1,9 do
       if (pos==1 or pos==5 or pos==7 or (pos%2==0 and pos~=6))  then
            io.write(self:getSprite(self.board[pos])," ","|"," ");
       elseif pos%2==1 or pos==6  then
            io.write(self:getSprite(self.board[pos]));
            io.write("\n");
       else
            io.write(self:getSprite(self.board[pos]));
       end
    end
end

TTT = Game:new(nil);

TTT:draw();


-- print(TTT:isEmpty(2));
-- print("|","X","|","X","|","X","|");
-- print("-------------------------------------------------");
-- print("|","X","|","X","|","X","|");
-- print("-------------------------------------------------");
-- print("|","X","|","X","|","X","|");
