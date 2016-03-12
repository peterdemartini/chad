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
local frameMaster, restartButton, playButton, pauseButton

local scene   = composer.newScene()
physics.start(); physics.pause()

if config.debugPhysics then
	debug('Setting Draw Mode to Hybrid')
	physics.setDrawMode("hybrid")
end

local function onRestartEvent()
	debug('onRestartEvent()')
	composer.gotoScene("src.reloading", "fade", 100)
	return true
end

local function chadDied()
	debug('chadDied()')
	composer.gotoScene("src.dead", "fade", 100)
	return true
end

local function onPauseEvent()
	debug('onPauseEvent()')
	frameMaster.pause()
	actions.pause()
	physics.pause()
	playButton.isVisible = true
	pauseButton.isVisible = false
	return true
end

local function onPlayEvent()
	debug('onPlayEvent()')
	frameMaster.play()
	actions.play()
	physics.start()
	playButton.isVisible = false
	pauseButton.isVisible = true
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
	frameMaster.build()

	restartButton = widget.newButton{
		width=60, height=60,
		defaultFile = "images/buttons/button_repeat.png",
		onRelease = onRestartEvent
	}
	restartButton.x = display.contentWidth - 50
	restartButton.y = 50

	pauseButton = widget.newButton{
		width=60, height=60,
		defaultFile = "images/buttons/button_pause.png",
		onRelease = onPauseEvent
	}
	pauseButton.x = display.contentWidth - 110
	pauseButton.y = 50

	playButton = widget.newButton{
		width=60, height=60,
		defaultFile = "images/buttons/button_play.png",
		onRelease = onPlayEvent
	}
	playButton.x = display.contentWidth - 110
	playButton.y = 50
	playButton.isVisible = false

	actions = Actions.new(chad, chadDied)

end

function scene:enterFrame(event)
	if chad ~= nil then
		chad.toFront()
	end
end

function scene:show(event)
	local sceneGroup = self.view

	if event.phase == "did" then
		debug('Scene did show')
		physics.start()
	end
end

function scene:hide(event)
	local sceneGroup = self.view

	if event.phase == "will" then
		debug('Scene will hide')
		physics.stop()
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	debug('Scene is being destroyed')

	for i = 1, #fixedStatics do
		fixedStatics[i].destroy()
		fixedStatics[i] = nil
	end

	frameMaster.destroy()
	actions.destroy()
	chad.destroy()
	restartButton:removeSelf()
	pauseButton:removeSelf()
	playButton:removeSelf()

	package.loaded[physics] = nil
	package.loaded[Chad] = nil
	package.loaded[Actions] = nil
	package.loaded[FrameMaster] = nil
	physics = nil
	Chad = nil
	FrameMaster = nil
	Actions = nil
	frameMaster = nil
	actions = nil
	chad = nil
	restartButton = nil
	playButton = nil
	pauseButton = nil
	sceneGroup:removeSelf()
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener('enterFrame', scene)

return scene
