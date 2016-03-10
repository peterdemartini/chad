local composer = require 'composer'
local scene = composer.newScene()

local physics = require 'physics'
physics.start(); physics.pause()

local function restart()
	composer.removeScene("src.reloading")
	composer.removeScene("src.runner")
	composer.gotoScene("src.runner", "fade", 20)
	return true
end

function scene:create(event)
	local sceneGroup = self.view
  restart()
end

function scene:show( event )
	local sceneGroup = self.view

	if event.phase == "did" then
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
	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
