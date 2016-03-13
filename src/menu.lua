local imagePath = require 'src.image-path'
local composer  = require 'composer'
local widget    = require 'widget'

local scene = composer.newScene()

local playBtn, background, title

local function onPlayBtnRelease()
	composer.removeScene("src.reloading")
	composer.removeScene("src.runner")
	composer.gotoScene("src.runner", "fade", 500)
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	background = display.newImageRect(imagePath('background.jpg'), display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	titleShadow = display.newText("Chad the Dinosaur", 264, 42, native.systemFontBold,90)
	titleShadow:setFillColor( 0.3 )
	titleShadow.x = (display.contentWidth * 0.5) + 4
	titleShadow.y = 104

	title = display.newText("Chad the Dinosaur", 264, 42, native.systemFontBold,90)
	title:setFillColor( 1 )
	title.x = display.contentWidth * 0.5
	title.y = 100
	title:toFront()

	playBtn = widget.newButton{
		label="Start Game",
		labelColor = { default={1}, over={1} },
		fontSize=40,
		font=native.systemFontBold,
		onRelease = onPlayBtnRelease
	}
	playBtn.x = display.contentWidth * 0.5
	playBtn.y = display.contentHeight * 0.85

	playBtnShadow = display.newText("Start Game", 264, 42, native.systemFontBold,40)
	playBtnShadow:setFillColor( 0.3 )
	playBtnShadow.x = (display.contentWidth * 0.5) + 5
	playBtnShadow.y = (display.contentHeight * 0.85) + 5


	sceneGroup:insert( background )
	sceneGroup:insert( titleShadow )
	sceneGroup:insert( title )
	sceneGroup:insert( playBtnShadow )
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
