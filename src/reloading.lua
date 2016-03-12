local composer = require 'composer'
local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view
	composer.removeScene("src.reloading")
	composer.removeScene("src.runner")
	composer.gotoScene("src.runner", "fade", 500)
end

scene:addEventListener("create", scene)

return scene
