local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local playBtn, background, title, description

local function onPlayBtnRelease()
	composer.removeScene("src.reloading")
	composer.removeScene("src.runner")
	composer.gotoScene("src.runner", "fade", 500)
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	background = display.newImageRect( "images/background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	title = display.newText("Chad Died", 264, 42, "Arial", 60 )
	title.x = display.contentWidth * 0.5
	title.y = 100

  description = display.newText("And you probably don't care", 264, 42, "Arial", 20 )
  description.x = display.contentWidth * 0.5
  description.y = 200

	playBtn = widget.newButton{
		label="Restart Game",
		labelColor = { default={255}, over={128} },
		width=300, height=100,
		onRelease = onPlayBtnRelease
	}
	playBtn.x = display.contentWidth * 0.5
	playBtn.y = display.contentHeight - 125

	sceneGroup:insert( background )
	sceneGroup:insert( title )
  sceneGroup:insert( description )
	sceneGroup:insert( playBtn )
end

function scene:destroy( event )
	local sceneGroup = self.view

	if playBtn then
		playBtn:removeSelf()
		playBtn = nil
	end

	if title then
		title:removeSelf()
		title = nil
	end

	if description then
		description:removeSelf()
		description = nil
	end

	if background then
		background:removeSelf()
		background = nil
	end

	package.loaded[physics] = nil
	package.loaded[widget] = nil
	physics = nil
	widget = nil

	sceneGroup:removeSelf()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

return scene
