local config   = require 'src.config'
local composer = require 'composer'
local physics  = require 'physics'

local Chad          = require 'src.characters.chad'
local Actions       = require 'src.actions.defaults'
local Wall          = require 'src.invisibles.wall'
local FrameMaster   = require 'src.frame-master'
local RunnerButtons = require 'src.buttons.runner-buttons'
local debug         = require('src.debug')('runner')

local screenW, screenH = display.contentWidth, display.contentHeight
local chad, actions

local fixedStatics = {}
local frameMaster, runnerButtons
local destroyed = false

local scene = composer.newScene()
physics.start(); physics.pause()

if config.debugPhysics then
	debug('Setting Draw Mode to Hybrid')
	physics.setDrawMode("hybrid")
end

function onRestartEvent()
	scene:destroy()
	composer.gotoScene("src.reloading", "fade", 100)
	return true
end

function chadDied()
	scene:destroy()
	composer.gotoScene("src.dead", "fade", 100)
	return true
end

local function onPauseEvent()
	frameMaster.pause()
	actions.pause()
	physics.pause()
	return true
end

local function onPlayEvent()
	frameMaster.play()
	actions.play()
	physics.start()
	return true
end

local function onRunEvent()
	chad.actionRun()
	return true
end

local function onEndRunEvent()
	chad.actionEndRun()
	return true
end


local function onJumpEvent()
	chad.actionJump()
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

	composer.removeScene('src.dead', true)
	composer.removeScene('src.reloading')

	scene:setFixedStatics()

	chad = Chad.new(screenW / 5, screenH - 75)
	sceneGroup:insert(chad.getBody())

	frameMaster = FrameMaster.new(chad, sceneGroup)
	frameMaster.build()

	local buttonActions = {
		onPlayEvent=onPlayEvent,
		onPauseEvent=onPauseEvent,
		onRestartEvent=onRestartEvent,
		onRunEvent=onRunEvent,
		onEndRunEvent=onEndRunEvent,
		onJumpEvent=onJumpEvent
	}

	runnerButtons = RunnerButtons.new(buttonActions)
	runnerButtons.build()

	actions = Actions.new(chad, chadDied)
	destroyed = false
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
		if not destroyed then
			onPlayEvent()
		end
	end
end

function scene:hide(event)
	local sceneGroup = self.view

	if event.phase == "will" then
		debug('Scene will hide')
		if not destroyed then
			onPauseEvent()
		end
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	if destroyed then
		debug('Scene already destroyed')
		return
	end
	debug('Scene is being destroyed')

	for i = 1, #fixedStatics do
		fixedStatics[i].destroy()
		fixedStatics[i] = nil
	end

	frameMaster.destroy()
	actions.destroy()
	chad.destroy()
	runnerButtons.destroy()

	frameMaster = nil
	actions = nil
	chad = nil
	destroyed = true
	-- sceneGroup:removeSelf()
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener('enterFrame', scene)

return scene
