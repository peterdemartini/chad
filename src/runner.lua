local composer = require 'composer'
local scene = composer.newScene()

local widget = require "widget"

local physics = require 'physics'
physics.start(); physics.pause()

local Chad = require 'src.characters.chad'
local Actions = require 'src.invisibles.actions'

local layoutItems = require 'src.levels.one.layout'

local screenH = display.contentHeight
local chad, actions
local frames = {}
local currentFrame = 1

local function onRestartEvent()
	composer.removeScene("src.reloading")
	composer.gotoScene("src.reloading", "fade", 500)
	return true
end

function scene:buildFrame(i)
	local sceneGroup = self.view
	frames[i] = layoutItems[i].build(sceneGroup)
end

function scene:create(event)
	local sceneGroup = self.view

	scene:buildFrame(currentFrame)

	chad = Chad.new(0, screenH - 75)
	sceneGroup:insert(chad.getBody())

	restartButton = widget.newButton{
		width=50, height=50,
		defaultFile = "images/restart-button.png",
		onRelease = onRestartEvent
	}
	restartButton.x = display.contentWidth - 50
	restartButton.y = 50

	actions = Actions.new(chad)
end

function scene:enterFrame(event)
	local moveX = -2
	local currentFrameX = frames[currentFrame].x
	frames[currentFrame].x = currentFrameX + moveX
	local nextFrame = currentFrame + 1
	if frames[nextFrame] == nil and layoutItems[nextFrame] ~= nil then
		scene:buildFrame(nextFrame)
		frames[nextFrame].x = frames[nextFrame].x + display.contentWidth
	end
	if frames[nextFrame] ~= nil then
		frames[nextFrame].x = frames[nextFrame].x + moveX
		if frames[nextFrame].x == 0 then
			currentFrame = nextFrame
		end
	end
	chad.getBody():toFront()
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

	for i = 1, #layoutItems do
		local layout = layoutItems[i]
		layout.destroy(sceneGroup)
	end

	actions.destroy()
	chad.destroy()
	chad = nil

	package.loaded[physics] = nil
	package.loaded[Chad] = nil
	package.loaded[Actions] = nil
	package.loaded[layoutItems] = nil
	physics = nil
	Chad = nil
	Actions = nil
	layoutItems = nil
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener("enterFrame", scene)

return scene
