local composer = require 'composer'
local scene = composer.newScene()

function scene:create(event)
	composer.removeScene("src.runner", true)
	composer.gotoScene("src.runner", "fade", 500)
end

scene:addEventListener("create", scene)

return scene
