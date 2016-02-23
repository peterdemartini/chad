local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local playBtn

local function onPlayBtnRelease()
	composer.gotoScene( "src.levels.level1", "fade", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	local background = display.newImageRect( "images/background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	local title = display.newText( "Chad the Dinosaur", 264, 42, "Arial", 60 )
	title.x = display.contentWidth * 0.5
	title.y = 100

	playBtn = widget.newButton{
		label="Start Game",
		labelColor = { default={255}, over={128} },
		width=154, height=40,
		onRelease = onPlayBtnRelease
	}
	playBtn.x = display.contentWidth * 0.5
	playBtn.y = display.contentHeight - 125

	sceneGroup:insert( background )
	sceneGroup:insert( title )
	sceneGroup:insert( playBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

	elseif phase == "did" then

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	if playBtn then
		playBtn:removeSelf()
		playBtn = nil
	end

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
