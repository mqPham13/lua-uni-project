-----------------------------------------------------------------------------------------
--
-- whichTurnScene.lua
--
-- choosing difficulty and move type and sound setting screen
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

--attributes for UI elements
local difficultyOffsetX      = 20
local difficultyOffsetY1     = 150
local difficultyOffsetY2     = difficultyOffsetY1 - 80
local difficultyOffsetY3     = difficultyOffsetY2 - 80
local difficultyLabelOffsetX = 40


local radioOffsetX1 = 120
local radioOffsetX2 = 120
local radioOffsetY1 = difficultyOffsetY1
local radioOffsetY2 = difficultyOffsetY2
local labelOffsetX1 = radioOffsetX1-50
local labelOffsetX2 = radioOffsetX2-50

local soundOffsetX      = 50
local soundOffsetY      = 120
local soundLabelOffsetX = 20

-- Image sheet options and declaration
local options = {
    width              = 100,
    height             = 100,
    numFrames          = 2,
    sheetContentWidth  = 200,
    sheetContentHeight = 100
}

local checkboxSheet = graphics.newImageSheet("speaker_sheet.png", options )
local radioSheet    = graphics.newImageSheet("radio_sheet.png", options)


--UI creation functions and their event handlers
local function handleDifficultyRadio( event )
	local switch = event.target
	if switch.id == "Easy" then
		data.difficulty = 1
	elseif switch.id == "Medium" then
		data.difficulty = 2
	elseif switch.id == "Hard" then
		data.difficulty = 3
	end
end


local function handlePlayAsRadio( event )
    local switch = event.target
    if switch.id == "X" then
    	data.playAs = "X"
    elseif switch.id == "O" then
    	data.playAs = "O"
    end
end


local function makeRadio(x,y,id,initialState,press)
	radioBttn = widget.newSwitch(
		{
			x = x,
			y = y,
			style = "radio",
			id = id,
			initialSwitchState = initialState,
			onPress = press,
			sheet = radioSheet,
			frameOn = 1,
			frameOff = 2
		}
	)
	return radioBttn
end


local function handleSoundCheckbox(event)
	soundCheckbox = event.target
	if soundCheckbox.isOn then
		data.enableSound = 1
	else
		data.enableSound = 0
	end
end


local function makeSoundCheckbox(x,y)
	local soundCheckbox = widget.newSwitch(
		{
			x = x,
			y = y,
			style = "checkbox",
			initialSwitchState = true,
			onPress = handleSoundCheckbox,
			sheet = checkboxSheet,
			frameOn = 2,
			frameOff = 1
		}
	)
	return soundCheckbox
end


local function handleBackButton(event)
	composer.gotoScene("whichTurnScene","slideRight")
end

local function handleAboutButton(event)
  composer.gotoScene("creditScene","slideLeft")
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create( event )

    local sceneGroup = self.view

		backButton = widget.newButton(
		{
			width = 32,
      height = 32,
			x = 32,
			y = 0,
			onPress = handleBackButton,
			defaultFile = "back.png",
      overFile = "back (1).png"
		}
	)
  sceneGroup:insert(backButton)

  aboutButton = widget.newButton(
    {
      width = 32,
      height = 32,
      x = display.contentWidth-32,
      y = 0,
      onPress = handleAboutButton,
      defaultFile = "about.png",
      overFile = "about (1).png"
    }
  )
  sceneGroup:insert(aboutButton)

  difficultyRadioButtons = {
    							makeRadio(display.contentCenterX-difficultyOffsetX, display.contentCenterY-difficultyOffsetY1,"Easy",true,handleDifficultyRadio),
    							makeRadio(display.contentCenterX-difficultyOffsetX, display.contentCenterY-difficultyOffsetY2,"Medium",false,handleDifficultyRadio),
    							makeRadio(display.contentCenterX-difficultyOffsetX, display.contentCenterY-difficultyOffsetY3,"Hard",false,handleDifficultyRadio)
	}

	radioButtonsGroup1 = display.newGroup()

	for _,button in pairs(difficultyRadioButtons) do
		radioButtonsGroup1:insert(button)
	end

	sceneGroup:insert(radioButtonsGroup1)

	local easyLabel = display.newText("Easy", difficultyLabelOffsetX, display.contentCenterY-difficultyOffsetY1,"Calibri",23,"left")
	sceneGroup:insert(easyLabel)
	local mediumLabel = display.newText("Medium", difficultyLabelOffsetX+20, display.contentCenterY-difficultyOffsetY2,"Calibri",23,"left")
	sceneGroup:insert(mediumLabel)
	local hardLabel = display.newText("Hard", difficultyLabelOffsetX, display.contentCenterY-difficultyOffsetY3,"Calibri",23,"left")
	sceneGroup:insert(hardLabel)


	playAsRadioButtons = {
							makeRadio(display.contentCenterX+radioOffsetX1, display.contentCenterY-radioOffsetY1,"X",true,handlePlayAsRadio),
							makeRadio(display.contentCenterX+radioOffsetX2, display.contentCenterY-radioOffsetY2,"O",false,handlePlayAsRadio)

	}

	radioButtonsGroup2 = display.newGroup()

	for _,bttn in pairs(playAsRadioButtons) do
		radioButtonsGroup2:insert(bttn)
	end

	sceneGroup:insert(radioButtonsGroup2)


	local radioLabel1 = display.newText("X", display.contentCenterX+labelOffsetX1, display.contentCenterY-radioOffsetY1,"Calibri",38)
	sceneGroup:insert(radioLabel1)
	local radioLabel2 = display.newText("O", display.contentCenterX+labelOffsetX2, display.contentCenterY-radioOffsetY2,"Calibri",38)
	sceneGroup:insert(radioLabel2)


	local soundCheckbox = makeSoundCheckbox(display.contentCenterX+soundOffsetX, display.contentCenterY+soundOffsetY)
	sceneGroup:insert(soundCheckbox)
	local soundCheckboxLabel = display.newText("Sound", display.contentCenterX-soundLabelOffsetX, display.contentCenterY+soundOffsetY,"Calibri",23)
	sceneGroup:insert(soundCheckboxLabel)
end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
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
