local composer = require 'composer'
local scene = composer.newScene()

local widget = require "widget"

local physics = require 'physics'
physics.start(); physics.pause()

local Chad    = require 'src.characters.chad'
local Actions = require 'src.invisibles.actions'
local Wall    = require 'src.statics.wall'

local layoutItems = require 'src.levels.one.layout'

local screenH = display.contentHeight
local chad, actions
local frames = {}
local currentFrame = 1
local fixedStatics = {}

physics.setDrawMode("hybrid") 

local function onRestartEvent()
	composer.removeScene("src.reloading")
	composer.gotoScene("src.reloading", "fade", 10)
	return true
end

function scene:buildFrame(i)
	local sceneGroup = self.view
	frames[i] = layoutItems[i].build(sceneGroup)
end

function scene:setFixedStatics()
	local sceneGroup = self.view
	fixedStatics[1] = Wall.new('top')
  fixedStatics[2] = Wall.new('left')
  fixedStatics[3] = Wall.new('right')

  sceneGroup:insert(fixedStatics[1].getBody())
  sceneGroup:insert(fixedStatics[2].getBody())
  sceneGroup:insert(fixedStatics[3].getBody())
end

function scene:updateFixedStatics(currentX)
	for i = 1, #fixedStatics do
		local static = fixedStatics[i]
		static.update(currentX)
	end
end

function scene:create(event)
	local sceneGroup = self.view

	scene:buildFrame(currentFrame)

	scene:setFixedStatics()

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
	if currentFrame == nil or frames[currentFrame] == nil then
		return
	end
	local moveSize = 2
	local moveX = -1 * moveSize
	frames[currentFrame].moveX(moveX)
	local nextFrame = currentFrame + 1
	if layoutItems[nextFrame] == nil then
		currentFrame = nil
	end
	if frames[nextFrame] == nil and layoutItems[nextFrame] ~= nil then
		scene:buildFrame(nextFrame)
		frames[nextFrame].moveX(display.contentWidth)
	end
	if frames[nextFrame] ~= nil then
		frames[nextFrame].moveX(moveX)
		if frames[nextFrame].getX() == 0 then
			frames[currentFrame].destroy()
			currentFrame = nextFrame
		end
	end
	scene:updateFixedStatics(moveSize)
	chad.moveX(moveSize)
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

	for i = 1, #frames do
		local frame = frames[i]
		frame.destroy(sceneGroup)
		frame[i] = nil
	end

	for i = 1, #fixedStatics do
		local static = fixedStatics[i]
		static.destroy()
		fixedStatics[i] = nil
	end

	Runtime:removeEventListener("enterFrame", scene)

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
