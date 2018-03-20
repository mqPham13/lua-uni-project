-----------------------------------------------------------------------------------------
--
-- whichTurnScene.lua
--
-- choose turn and move type and sound setting screen
--
-- CSP2108 - Introduction to Mobile Applications Development
-- Student: Minh Quang Pham
-- ID: 10376093
--
-----------------------------------------------------------------------------------------

local composer  = require("composer")
local scene     = composer.newScene()
local currScene = composer.getSceneName("current")

local widget = require("widget")
local data   = require("myData")

local difficulty  = data.difficulty
local playAs      = data.playAs
local enableSound = data.enableSound

--attributes for turn choice buttons
local turnChoiceWidth        = 2*display.contentWidth/5
local turnChoiceHeight       = display.contentHeight/7
local turnChoiceConnerRadius = 10
local turnChoiceFillColor    = { default={211/255, 47/255, 47/255}, over={244/255, 67/255, 54/255} }
local turnChoiceYOffset1     = display.contentWidth - 220
local turnChoiceYOffset2     = display.contentWidth - 130

--attributes for setting button
local settingBttnY = 0
local settingBttnX = 32

--attributes for scoreboard and its labels
local scoreBoardYOffset = 100
local scoreXOffset = 20
local labelXOffset = 80
local loseLabelYOffset = scoreBoardYOffset
local winLabelYOffset = loseLabelYOffset + 35
local drawLabelYOffset = loseLabelYOffset - 35

-- properties for reset scores button
local restartBtnFillColor    = { default={211/255, 47/255, 47/255}, over={127/255, 140/255, 141/255} }
local resetScoresBttnXOffset     = 60
local resetScoresBttnYOffset      = scoreBoardYOffset

--attributes for stroke lines
local paint = {
type = "gradient",
color1 = {211/255, 47/255, 47/255},
color2 = {244/255, 67/255, 54/255},
direction = "down"
}

--json for retrieving scores
local json = require("json")
local wCount
local lCount
local dCount
local countTable = display.newGroup()
local scoresTable

local filePath = system.pathForFile("scores.json",system.DocumentsDirectory)


--FUNCTIONS AND EVENT HANDLERS
local function  removeDisplayObject(obj)
	display.remove(obj)
	obj = nil
end


--functions for loading, saving, resetting and displaying scores
local function loadScores()
	local file = io.open(filePath,"r")
	if file then
		local contents = file:read("*a")
		io.close(file)
		scoresTable = json.decode(contents)
	end

	if scoresTable == nil or #scoresTable == 0 then
		scoresTable = {0,0,0}
	end
end


local function saveScores()
	local file = io.open(filePath, "w")
	if file then
		file:write(json.encode(scoresTable))
		io.close(file)
	end
end


local function resetScores()
	for i=1, #scoresTable do
		scoresTable[i] = 0
	end
end


local function displayScores()
	wCount = display.newText(scoresTable[1],display.contentCenterX+scoreXOffset,display.contentCenterY-winLabelYOffset,"Calibri",25)
	lCount = display.newText(scoresTable[2],display.contentCenterX+scoreXOffset,display.contentCenterY-loseLabelYOffset,"Calibri",25)
	dCount = display.newText(scoresTable[3],display.contentCenterX+scoreXOffset,display.contentCenterY-drawLabelYOffset,"Calibri",25)
	countTable:insert(wCount)
	countTable:insert(lCount)
	countTable:insert(dCount)
end

--functions for creating UI elements and handling their listeners
local function handleSettingsButton(event)
	composer.removeScene(currScene)
	composer.gotoScene("settingScene","slideLeft")
end


local function handleTurnChoice(event)
	if event.target:getLabel() == "Go first" then
		option = {effect="slideUp", params={whichTurn=1, mode = difficulty, moveType=playAs, sound=enableSound}}
		composer.gotoScene("boardScene", option)
	elseif event.target:getLabel() == "Go second" then
		option = {effect="slideUp", params={whichTurn=2, mode = difficulty, moveType=playAs, sound=enableSound}}
		composer.gotoScene("boardScene", option)
	end

end


local function makeTurnChoice(label,x,y)
	turnChoice = widget.newButton(
		{
			label = label,
			onRelease = handleTurnChoice,
			emboss = true,
			--Properties for a rounded rectangle button
			shape = "roundedRect",
			x = x,
			y = y,
			width = turnChoiceWidth,
			height = turnChoiceHeight,
			cornerRadius = turnChoiceConnerRadius,
			fillColor = turnChoiceFillColor,
			labelColor = {default={1,1,1}},
			font = "Calibri",
			fontSize = 20
		}
	)
	return turnChoice
end


local function handleResetScoresButton(event)
	resetScores()
	saveScores()
	loadScores()
	removeDisplayObject(wCount)
	removeDisplayObject(lCount)
	removeDisplayObject(dCount)
	displayScores()
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create( event )
  local sceneGroup = self.view

	turnChoices = {
    				makeTurnChoice("Go first", display.contentCenterX, display.contentCenterY + turnChoiceYOffset1),
					  makeTurnChoice("Go second", display.contentCenterX, display.contentCenterY + turnChoiceYOffset2),
	}

	for _, button in pairs(turnChoices) do
		sceneGroup:insert(button)
	end

	settingBttn = widget.newButton(
		{
			width=32,
			height=32,
			onPress = handleSettingsButton,
			x = settingBttnX,
			y = settingBttnY,
			defaultFile = "settings.png",
			overFile = "settings (1).png"
		}
	)
	sceneGroup:insert(settingBttn)

	local scoreBoard = display.newRect(display.contentCenterX,display.contentCenterY-scoreBoardYOffset, display.contentWidth-30, display.contentHeight/4)
	scoreBoard.strokeWidth = 2
	scoreBoard.stroke = paint
	scoreBoard.fill = {60/255,60/255,60/255}
	sceneGroup:insert(scoreBoard)

	local winLabel = display.newText("wins",display.contentCenterX-labelXOffset,display.contentCenterY-winLabelYOffset,"Calibri",18)
	sceneGroup:insert(winLabel)
	local loseLabel = display.newText("loses",display.contentCenterX-labelXOffset+2,display.contentCenterY-loseLabelYOffset,"Calibri",18)
	sceneGroup:insert(loseLabel)
	local drawLabel = display.newText("draws",display.contentCenterX-labelXOffset+2,display.contentCenterY-drawLabelYOffset,"Calibri",18)
	sceneGroup:insert(drawLabel)

	resetScoresButton = widget.newButton(
		{
			width =32,
			height =32,
			onRelease = handleResetScoresButton,
			defaultFile = "reset.png",
			overFile = "reset (1).png",
			x = display.contentWidth-resetScoresBttnXOffset,
			y = display.contentCenterY-resetScoresBttnYOffset,
		}
	)
	sceneGroup:insert(resetScoresButton)
end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
			local lastResult = composer.getVariable("gameResult")
			composer.setVariable("gameResult", 0)
			loadScores()
			if lastResult == 1 then
				scoresTable[1] = scoresTable[1] + 1
			elseif lastResult == 2 then
				scoresTable[2] = scoresTable[2] + 1
			elseif lastResult == 3 then
				scoresTable[3] = scoresTable[3] + 1
			end
			saveScores()

			if wCount ~= nil or lCount ~= nil or dCount ~= nil then
				removeDisplayObject(wCount)
				removeDisplayObject(lCount)
				removeDisplayObject(dCount)
			end
			displayScores()
			sceneGroup:insert(countTable)
    elseif ( phase == "did" ) then
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end


function scene:destroy( event )
    local sceneGroup = self.view
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
