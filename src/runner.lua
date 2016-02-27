local composer = require 'composer'
local scene = composer.newScene()

local physics = require 'physics'
physics.start(); physics.pause()

local Chad = require 'src.characters.chad'
local Actions = require 'src.invisibles.actions'

local layoutItems = require 'src.levels.one.layout'

local screenH = display.contentHeight
local chad = Chad.new(0, screenH - 75)

function scene:create(event)
	local sceneGroup = self.view

	for i = 1, #layoutItems do
		local layout = layoutItems[i]
	  layout.build(sceneGroup)
	end

	sceneGroup:insert(chad.getBody())

end

function scene:show( event )
	local sceneGroup = self.view

	if phase == "did" then
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view

	if event.phase == "will" then
		physics.stop()
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
