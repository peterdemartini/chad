local composer = require 'composer'
local scene = composer.newScene()

local physics = require 'physics'
physics.start(); physics.pause()

local ChadCharacter = require 'src.characters.chad'
local Ground = require 'src.background.ground'
local Background = require 'src.background.background'
local Actions = require 'src.invisibles.actions'

local screenH = display.contentHeight
local groundHeight = 85

local chad = ChadCharacter.new(0, screenH - groundHeight)

function scene:create(event)
	local sceneGroup = self.view

	local background = Background.new(groundHeight)
	local ground = Ground.new(groundHeight)

	sceneGroup:insert(background.getBody())
	sceneGroup:insert(ground.getBody())
	sceneGroup:insert(chad.getBody())
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

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Actions.new(chad)

return scene
