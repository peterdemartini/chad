local composer = require( "composer" )
local scene = composer.newScene()

local physics = require "physics"
physics.start(); physics.pause()

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:create( event )
	local sceneGroup = self.view

	local background = display.newRect( 0, 0, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( .5 )

	local crate = display.newImageRect( "images/crate.png", 90, 90 )
	crate.x, crate.y = 160, -100
	crate.rotation = 15

	physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )

	local grass = display.newImageRect( "images/grass.png", screenW, 82 )
	grass.anchorX = 0
	grass.anchorY = 1
	grass.x, grass.y = 0, display.contentHeight

	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )

	sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( crate )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function scene:destroy( event )
	-- Called prior to the removal of scene's "view" (sceneGroup)
	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
