-----------------------------------------------------------------------------------------
--
-- computerStrategy.lua
--
-- Computer logic for winning for each difficulty setting
--
-- CSP2108 - Introduction to Mobile Applications Development
-- Student: Minh Quang Pham
-- ID: 10376093
--
-----------------------------------------------------------------------------------------
local EMPTY, PLAYER, COM = 0, 1, 2

M = {}

--function for 'Easy' difficulty's winning strategy
function M.getComMoveEasy(board)
  local t
	repeat
		t = math.random(1,9)
	until board[t][7] == EMPTY
  return t
end


--function for 'Hard' difficulty's winning strategy
function M.getComMoveHard(board,winningConditions)
	local t
	--first winning strategy: if you or your opponent has two in a row, play on the remaining square
	for i=1,#winningConditions do
		if board[winningConditions[i][1]][7] == board[winningConditions[i][2]][7] and board[winningConditions[i][2]][7] == COM and board[winningConditions[i][3]][7] == EMPTY then
			t = winningConditions[i][3]

		elseif board[winningConditions[i][1]][7] == board[winningConditions[i][3]][7] and board[winningConditions[i][3]][7] == COM and board[winningConditions[i][2]][7] == EMPTY then
			t = winningConditions[i][2]

		elseif board[winningConditions[i][2]][7] == board[winningConditions[i][3]][7] and board[winningConditions[i][3]][7] == COM and board[winningConditions[i][1]][7] == EMPTY then
			t = winningConditions[i][1]
		end
	end

	if t == nil then
		for i=1,#winningConditions do
			if board[winningConditions[i][1]][7] == board[winningConditions[i][2]][7] and board[winningConditions[i][2]][7] == PLAYER and board[winningConditions[i][3]][7] == EMPTY then
				t = winningConditions[i][3]

			elseif board[winningConditions[i][1]][7] == board[winningConditions[i][3]][7] and board[winningConditions[i][3]][7] == PLAYER and board[winningConditions[i][2]][7] == EMPTY then
				t = winningConditions[i][2]

			elseif board[winningConditions[i][2]][7] == board[winningConditions[i][3]][7] and board[winningConditions[i][3]][7] == PLAYER and board[winningConditions[i][1]][7] == EMPTY then
				t = winningConditions[i][1]
			end
		end
	end

	--second winning strategy: if there is a move that creates two lines of two in a row, play that
	if t == nil then
		if (board[1][7] == board[3][7] and board[1][7] == COM) or
			(board[1][7] == board[7][7] and board[1][7] == COM) or
			(board[3][7] == board[9][7] and board[3][7] == COM) or
			(board[7][7] == board[9][7] and board[7][7] == COM) or
			(board[2][7] == board[4][7] and board[2][7] == COM) or
			(board[2][7] == board[6][7] and board[2][7] == COM) or
			(board[8][7] == board[4][7] and board[8][7] == COM) or
			(board[8][7] == board[6][7] and board[7][7] == COM) then
			if board[5][7] == EMPTY then
				t = 5
			end

		elseif (board[1][7] == board [4][7] and board[1][7] == COM) or
			(board[3][7] == board [6][7] and board[3][7] == COM) then
			if board[2][7] == EMPTY then
				t = 2
			end

		elseif (board[1][7] == board[2][7] and board[1][7] == COM) or
			(board[7][7] == board[8][7] and board[7][7] == COM) then
			if board[4][7] == EMPTY then
				t = 4
			end

		 elseif (board[2][7] == board [3][7] and board[2][7] == COM) or
			(board[8][7] == board [9][7] and board[8][7] == COM) then
			if board[6][7] == EMPTY then
				t = 6
			end

		elseif (board[4][7] == board [7][7] and board[4][7] == COM) or
			(board[6][7] == board [9][7] and board[6][7] == COM) then
			if board[8][7] == EMPTY then
				t = 8
			end

		elseif board[2][7] == board[4][7] and board[2][7] == COM then
			if board[1][7] == EMPTY then
				t = 1
			end
		elseif board[2][6] == board[6][7] and board[2][7] == COM then
			if board[3][7] == EMPTY then
				t = 3
			end
		elseif board[8][6] == board[4][7] and board[8][7] == COM then
			if board[7][7] == EMPTY then
				t = 7
			end
		elseif board[8][6] == board[6][7] and board[8][7] == COM then
			if board[9][7] == EMPTY then
				t = 9
			end
		end

	end

	--third winning strategy: if the center square is free, play there
	if t == nil and board[5][7] == EMPTY then
		t = 5
	end

	--fourth winning strategy: if your opponent plays in a conner, play in the opposite conner
	if t == nil then
		if board[1][7] == PLAYER and board[9][7] == EMPTY then
			t = 9
		elseif board[3][7] == PLAYER and board[7][7] == EMPTY then
			t = 7
		elseif board[7][7] == PLAYER and board[3][7] == EMPTY then
			t = 3
		elseif board[9][7] == PLAYER and board[1][7] == EMPTY then
			t = 1
		end
	end

	--fifth winning strategy: if there is an empty conner, play there
	if t == nil then
		for i = 1, 9, 2 do
			if board[i][7] == EMPTY then
				t = i
				break
			end
		end
	end

	-- otherwise just play on a random empty square
	if t == nil then
		repeat
			t = math.random(1,9)
		until board[t][7] == EMPTY
	end
	comPlayed = 1

  return t
end


--functions for 'Medium' difficulty's winning strategy
function M.getComMoveMedium(board,winningConditions,turn)
  local t
	if turn % 2 == 0 then
		t = M.getComMoveHard(board,winningConditions)
	elseif turn % 2 ~= 0 then
	  t = M.getComMoveEasy(board)
	end
	turn = turn + 1
  return t, turn
end


return M
