-----------------------------------------------------------------------------------------
--
-- creditScene.lua
--
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
local scoreBoardYOffset = 100

local text = "Author: Minh Quang Pham\n\n\nIcon art: Phuong Nghi Hoang\n\n\nIn-app icons: icons8.com"

local function handleBackButton(event)
	composer.removeScene(currScene)
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

  local scoreBoard = display.newRect(display.contentCenterX,display.contentCenterY, display.contentWidth-30, display.contentHeight/1.5)
  scoreBoard.strokeWidth = 2
  scoreBoard.stroke = paint
  scoreBoard.fill = {60/255,60/255,60/255}
  sceneGroup:insert(scoreBoard)

  creditText = display.newText(text, display.contentCenterX,display.contentCenterY,"Calibri",20)
  sceneGroup:insert(creditText)
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
    composer.gotoScene("settingScene","slideRight")

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
