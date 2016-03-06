local config   = require 'src.config'
local composer = require 'composer'
local widget   = require 'widget'
local physics  = require 'physics'

local Chad        = require 'src.characters.chad'
local Actions     = require 'src.invisibles.actions'
local Wall        = require 'src.invisibles.wall'
local FrameMaster = require 'src.frame-master'
local debug       = require('src.debug')('runner')

local screenW, screenH = display.contentWidth, display.contentHeight
local chad, actions

local fixedStatics = {}
local frameMaster

local scene   = composer.newScene()
physics.start(); physics.pause()

if config.debug then
	debug('Setting Draw Mode to Hybrid')
	physics.setDrawMode("hybrid")
end

local function onRestartEvent()
	debug('onRestartEvent()')
	composer.removeScene("src.runner")
	composer.gotoScene("src.reloading", "fade", 10)
	return true
end

local function chadDied()
	debug('chadDied()')
	composer.removeScene("src.runner")
	composer.gotoScene("src.dead", "fade", 100)
	return true
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
	debug('Creating scene')
	local sceneGroup = self.view

	scene:setFixedStatics()

	chad = Chad.new(screenW / 5, screenH - 75)
	sceneGroup:insert(chad.getBody())

	frameMaster = FrameMaster.new(chad, sceneGroup)

	restartButton = widget.newButton{
		width=50, height=50,
		defaultFile = "images/restart-button.png",
		onRelease = onRestartEvent
	}
	restartButton.x = display.contentWidth - 50
	restartButton.y = 50

	actions = Actions.new(chad, chadDied)

end

function scene:show( event )
	local sceneGroup = self.view

	if event.phase == "did" then
		debug('Scene did show')
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view

	if event.phase == "will" then
		debug('Scene will hide')
		physics.stop()
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	debug('Scene is being destroyed')

	for i = 1, #fixedStatics do
		local static = fixedStatics[i]
		static.destroy()
		fixedStatics[i] = nil
	end

	frameMaster.destroy()
	frameMaster = nil

	actions.destroy()
	chad.destroy()
	chad = nil

	package.loaded[physics] = nil
	package.loaded[Chad] = nil
	package.loaded[Actions] = nil
	package.loaded[FrameMaster] = nil
	physics = nil
	Chad = nil
	FrameMaster = nil
	Actions = nil
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
