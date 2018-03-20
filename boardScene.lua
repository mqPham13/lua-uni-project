-----------------------------------------------------------------------------------------
--
-- boardScene.lua
--
-- This is the scene in which the game is played
--
-- CSP2108 - Introduction to Mobile Applications Development
-- Student: Minh Quang Pham
-- ID: 10376093
--
-----------------------------------------------------------------------------------------
local composer  = require("composer")
local scene     = composer.newScene()
local currScene = composer.getSceneName("current")

local widget    = require("widget")
local strategy  = require ("computerStrategy")

local EMPTY, PLAYER, COM = 0, 1, 2

local mode
local moveType
local sound
local endGame
local turn
local replaying
local message
local comPlayed
local currTimer
local undoable
local result -- 1: win, 2: lose, 3:draw

local board = {}
local moves = {}
local texts = {}
local soundTable = {}

local options =
{
    --required parameters
    width = 48,
    height = 48,
    numFrames = 5,
}
local timerSheet = graphics.newImageSheet("timer.png",options)

--attributes for stroke lines
local paint =
{
  type = "gradient",
  color1 = {211/255, 47/255, 47/255},
  color2 = {244/255, 67/255, 54/255},
  direction = "down"
}

-- conditions for X or O to win
winningConditions = {{1,2,3}, {4,5,6}, {7,8,9}, --rows
					 {1,4,7}, {2,5,8}, {3,6,9}, --columns
					 {1,5,9}, {3,5,7}}			--diagonals


-- properties for message
messageX    = display.contentCenterX
messageY    = display.contentCenterY - 180
messageFont = "Calibri"
messageSize = 40


-- properties for restart button
local restartBtnFillColor    = { default={211/255, 47/255, 47/255}, over={127/255, 140/255, 141/255} }
local restartBtnXOffset      = 40
local restartBtnYOffset      = 180


-- FUNCTIONS AND EVENT HANDLERS
local function  removeDisplayObject(obj)
	display.remove(obj)
	obj = nil
end

--timer related functions and event handler
local function timerListener(event)
	if event.phase == "began" then
		undoable = 1
	elseif event.phase == "ended" then
		timer.performWithDelay(500, function()
        removeDisplayObject(currTimer)
        undoable = 0
    end)
	end
end

local function displayTimer()
	local timer = display.newSprite(timerSheet, {name="timer", start=1, count=5, time=5000, loopCount=1})
	timer.x = display.contentCenterX-display.contentWidth/4
	timer.y = display.contentHeight - display.screenOriginY/2.25 - 48
	timer:addEventListener("sprite",timerListener)
	timer:play()
	return timer
end


--check for win and draw, called after X or O has made a moveocal function checkState()
local function checkState()
	local winner
	local winningPos = {}
	if endGame == 0 then
		for i=1,#winningConditions do
			if board[winningConditions[i][1]][7] == board[winningConditions[i][2]][7] and board[winningConditions[i][1]][7] == board[winningConditions[i][3]][7] and board[winningConditions[i][1]][7] ~= EMPTY then
				endGame = 1
				winner = board[winningConditions[i][1]][7]
				winningPos = {winningConditions[i][1],winningConditions[i][2],winningConditions[i][3]}
			end
		end

		if #moves == 9 and endGame ~=  1 then
			message = display.newText("Draw",messageX,messageY,messageFont,messageSize)
			audio.play(soundTable["drawSound"])
			endGame = 1
      result = 3
		end

		if endGame == 1 then
      removeDisplayObject(currTimer)
			if winner == PLAYER then
				message = display.newText("You wins!",messageX,messageY,messageFont,messageSize)
				audio.play(soundTable["winSound"])
        result = 1
			elseif winner == COM then
				message = display.newText("Computer wins!",messageX,messageY,messageFont,messageSize)
				audio.play(soundTable["loseSound"])
        result = 2
			end

			for i=1,#winningPos do
				for j=1,#moves do
					if moves[j].position == winningPos[i] then
						transition.to(moves[j].text, {time=1000, rotation=1080})
						moves[j].text:setFillColor(255/255,255/255,0/255)
					end
				end
			end
		end
	end
end


local function drawMove(move,t)
	moveText = display.newText(move,(board[t][3]+board[t][5])/2,(board[t][4]+board[t][6])/2,"Calibri",20)
	transition.to(moveText, {delay = 0, time = 200, size = 60})
	table.insert(texts, moveText)
	return moveText
end


local function getComMove()
	local t
	local moveText
	--get position on board
	if mode == 1 then
		t = strategy.getComMoveEasy(board)
	elseif mode == 2 then
		t, turn = strategy.getComMoveMedium(board,winningConditions,turn)
	elseif mode == 3 then
		t = strategy.getComMoveHard(board,winningConditions)
	end
--draw the move according to the position
	if moveType == "X" then
		moveText = drawMove("O",t)
	elseif moveType == "O" then
		moveText = drawMove("X",t)
	end
--add the move to tracking tables and play move sound
	moves[#moves+1] = {position=t, text=moveText}
	board[t][7] = COM
	audio.play(soundTable["moveSound"])
--check game state after move has been played
	checkState()
	if endGame == 1 then
		Runtime:removeEventListener("touch", getPlayerMove)
	end
	comPlayed = 1
end


local function getPlayerMove (event)
	playerPlayed = 0
	local moveText

	if event.phase == "began" then
		--check if the game has already ended
		if endGame == 1 then
			Runtime:removeEventListener("touch", getPlayerMove)
			else
				--get move touched position on screen
				for t = 1, 9 do
					if event.x > board[t][3] and event.x < board [t][5] then
						if event.y < board[t][4] and event.y > board[t][6] then
							if board[t][7] == EMPTY then
								--draw move according to touched position
								if moveType == "X" then
									moveText = drawMove("X",t)
								elseif moveType == "O" then
									moveText = drawMove("O",t)
								end
								--enter move to tracking tables and play move sound
								moves[#moves+1] = {position=t, text=moveText}
								board[t][7] = PLAYER
								audio.play(soundTable["moveSound"])
								--remove old timer (if exists) and display new timer
								if currTimer ~= nil then
								  removeDisplayObject(currTimer)
								end
								currTimer = displayTimer()
								--check game state after move has been played
								checkState()
								if endGame == 1 then
									Runtime:removeEventListener("touch", getPlayerMove)
								  removeDisplayObject(currTimer)
								end

								playerPlayed = 1
                comPlayed = 0
							end
						end
					end
				end

			--if player has played and game is not ended then computer can make its move
			if playerPlayed == 1 and endGame == 0 then
				timer.performWithDelay(100,getComMove)
			end
		end
	end
end


local function handleRestartButton(event)
	composer.removeScene(currScene,true)
end


local function handleReplayButton(event)
	if replaying == 0 and endGame == 1 then --only allow replay when game has been ended and there isn't any on going replay
		replaying = 1
		local count = 0
		for c=1, #texts do
			texts[c].alpha = 0
			count = count+1
			timer.performWithDelay(400*count, function()
						transition.to(texts[c],{time = 0, alpha=1})
						audio.play(soundTable["moveSound"])
						if c == #texts then
							replaying = 0
						end
					end)
		end
	end
end


local function handleUndoButton()
	if undoable == 1 then --only allow undo within 5 seconds after last move has been made
		--only allow undo if game has not been ended and after computer has made a move and there is at least one move on the board
		if endGame == 0 and comPlayed == 1 and #moves>0 then
			if #moves ~= 1 or board[moves[1].position][7] ~= COM then --if first move is computer's then don't allow undo
				for i=#texts, #texts-1, -1 do
					removeDisplayObject(texts[i])
					table.remove(texts,i)
				end
				for i=#moves, #moves-1, -1 do
					board[moves[i].position][7] = EMPTY
					table.remove(moves,i)
				end
        removeDisplayObject(currTimer)
        audio.play(soundTable["undoSound"])
				comPlayed = 0
			end
		end
	end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create(event)

	local sceneGroup = self.view

	-- load in sounds
	sound = event.params.sound

	if sound == 1 then
		soundTable = {
			moveSound = audio.loadSound("move.wav"),
			winSound  = audio.loadSound("win.wav"),
			loseSound = audio.loadSound("lose.wav"),
			drawSound = audio.loadSound("draw.wav"),
      undoSound = audio.loadSound("undo.wav")
		}
	end

	--create the board
	w20 = display.contentWidth * .2
	h20 = display.contentHeight * .2
	w40 = display.contentWidth * .4
	h40 = display.contentHeight * .4
	w60 = display.contentWidth * .6
	h60 = display.contentHeight * .6
	w80 = display.contentWidth * .8
	h80 = display.contentHeight * .8
	--DRAW LINES FOR BOARD
	local lline = display.newLine(w40,h20,w40,h80 )
	lline.strokeWidth = 5
	sceneGroup:insert(lline)
	local rline = display.newLine(w60,h20,w60,h80 )
	rline.strokeWidth = 5
	sceneGroup:insert(rline)
	local bline = display.newLine(w20,h40,w80,h40 )
	bline.strokeWidth = 5
	sceneGroup:insert(bline)
	local tline = display.newLine(w20,h60,w80,h60 )
	tline.strokeWidth = 5
	sceneGroup:insert(tline)
	--PLACE BOARD COMPARTMENT DIMENSIONS IN TABLE
	board ={
	{"tl", 1, w20, h40, w40, h20,0},
	{"tm",2, w40,h40,w60,h20,0},
	{"tr",3, w60,h40,w80,h20,0},
	{"ml", 4, w20, h60, w40, h40,0},
	{"mm",5, w40,h60,w60,h40,0},
	{"mr",6, w60,h60,w80,h40,0},
	{"bl", 7, w20, h80, w40, h60,0},
	{"bm",8, w40,h80,w60,h60,0},
	{"br",9, w60,h80,w80,h60,0}
	}

	--create button dock
	local buttonDock = display.newRect(display.contentCenterX,display.contentHeight - display.screenOriginY, display.contentWidth, display.contentHeight/5)
  buttonDock.strokeWidth = 2
	buttonDock.stroke = paint
	sceneGroup:insert(buttonDock)

	--create a restart button
	restartButton = widget.newButton(
		{
      width = 45,
      height = 45,
			onRelease = handleRestartButton,
			defaultFile = "restart.png",
			overFile = "restart (1).png",
			x = display.contentWidth-restartBtnXOffset,
			y = display.contentCenterY+restartBtnYOffset,
		}
	)
	sceneGroup:insert(restartButton)

	--create undo button
	undoButton = widget.newButton(
	{
    width = 45,
    height = 45,
		onPress = handleUndoButton,
		defaultFile = "undo.png",
		overFile = "undo (1).png",
		x = display.contentCenterX-display.contentWidth/4,
		y = display.contentHeight - display.screenOriginY/2.25
	}
	)
	sceneGroup:insert(undoButton)

	--create replay button
	replayButton = widget.newButton(
	{
    width = 48,
    height = 48,
		onPress = handleReplayButton,
		defaultFile = "replay.png",
		overFile = "replay (1).png",
		x = display.contentCenterX+display.contentWidth/4,
		y = display.contentHeight - display.screenOriginY/2.25
	}
	)

	sceneGroup:insert(replayButton)
end


function scene:show(event)
	local sceneGroup = self.view
	local phase      = event.phase

	--setting variables
	local whichTurn = event.params.whichTurn
	moveType        = event.params.moveType
	mode            = event.params.mode
	replaying = 0
	turn      = 1
	endGame   = 0
	comPlayed = 0

	if (phase == "will") then

	elseif (phase == "did") then
		if whichTurn == PLAYER then
			Runtime:addEventListener("touch", getPlayerMove)
		elseif whichTurn == COM then
			getComMove()
			Runtime:addEventListener("touch", getPlayerMove)
		end
	end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end


function scene:destroy(event)
	local sceneGroup = self.view
  composer.setVariable("gameResult", result)

	--clean up tables and variables
	for i=1,#board do
		board[i][7] = EMPTY
	end
	for i=1,#texts do
		removeDisplayObject(texts[i])
	end
  if currTimer ~= nil then
    removeDisplayObject(currTimer)
  end
	display.remove(message)
	message  = nil

	texts    = {}
	moves    = {}
	moveType = nil
	sound    = nil
	comPlayed = nil
  result = 0
	endGame  = 0
	turn     = 1
	replay   = 0

	-- cleaning up audio
	audio.stop()
	for s,v in pairs( soundTable ) do
		audio.dispose( soundTable[s] )
		soundTable[s] = nil
	end

	--cleaning up event listener
	Runtime:removeEventListener("touch",getPlayerMove)
	--return to whichTurnScene
	composer.gotoScene("whichTurnScene","slideDown")

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
