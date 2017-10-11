local imagePath = require 'src.image-path'
local composer  = require 'composer'
local widget    = require 'widget'

local scene = composer.newScene()

local playBtn, background, title, description

local function onPlayBtnRelease()
	composer.gotoScene("src.runner", "fade", 500)
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	composer.removeScene('src.runner', true)

	background = display.newImageRect(imagePath('space-background.png'), display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	titleShadow = display.newText("Chad Died", 264, 42, native.systemFontBold,90)
	titleShadow:setFillColor( 0.3 )
	titleShadow.x = (display.contentWidth * 0.5) + 4
	titleShadow.y = 104

	title = display.newText("Chad Died", 264, 42, native.systemFontBold,90)
	title:setFillColor( 1 )
	title.x = display.contentWidth * 0.5
	title.y = 100
	title:toFront()

	descriptionShadow = display.newText("And you probably don't even care.", 264, 42, native.systemFont,25)
	descriptionShadow:setFillColor( 0.1 )
	descriptionShadow.x = (display.contentWidth * 0.5) + 2
	descriptionShadow.y = 175 + 2

	description = display.newText("And you probably don't even care.", 264, 42, native.systemFont,25)
	description:setFillColor( 1 )
	description.x = display.contentWidth * 0.5
	description.y = 175
	description:toFront()

	playBtn = widget.newButton{
		label="Restart Game",
		labelColor = { default={1}, over={1} },
		fontSize=40,
		fillColor={0, 0, 0, 0},
		font=native.systemFontBold,
		onRelease = onPlayBtnRelease
	}
	playBtn.x = display.contentWidth * 0.5
	playBtn.y = display.contentHeight * 0.85

	playBtnShadow = display.newText("Restart Game", 264, 42, native.systemFontBold,40)
	playBtnShadow:setFillColor( 0.3 )
	playBtnShadow.x = (display.contentWidth * 0.5) + 5
	playBtnShadow.y = (display.contentHeight * 0.85) + 5

	sceneGroup:insert( background )
	sceneGroup:insert( titleShadow )
	sceneGroup:insert( title )
	sceneGroup:insert( descriptionShadow )
	sceneGroup:insert( description )
	sceneGroup:insert( playBtnShadow )
	sceneGroup:insert( playBtn )
end

function scene:destroy( event )
	local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

return scene
