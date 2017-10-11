local config        = require 'src.config'
local composer      = require 'composer'
local physics       = require 'physics'
local Chad          = require 'src.characters.chad'
local Actions       = require 'src.actions.defaults'
local Walls         = require 'src.invisibles.walls'
local LevelOne      = require 'src.levels.one'
local RunnerButtons = require 'src.buttons.runner-buttons'
local debug         = require('src.debug')('runner')

local screenW, screenH = display.contentWidth, display.contentHeight
local chad, actions, touchObject

local fixedStatics = {}
local frameMaster, runnerButtons
local destroyed = false

local scene = composer.newScene()
physics.start(); physics.pause()
physics.setGravity( 0, 32 )

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
	actions.pause()
	physics.pause()
	return true
end

local function onPlayEvent()
	actions.play()
	physics.start()
	return true
end

function scene:setFixedStatics()
	local sceneGroup = self.view
  sceneGroup:insert(Walls.new())
end

function scene:updateFixedStatics(currentX)
	for i = 1, #fixedStatics do
		local static = fixedStatics[i]
		static:toFront()
	end
end

function scene:create(event)
	debug('Creating scene')
	local sceneGroup = self.view

	composer.removeScene('src.dead', true)
	composer.removeScene('src.reloading')

	scene:setFixedStatics()

	chad = Chad.new(screenW / 5, screenH - 75)
	sceneGroup:insert(chad)

	local levelOne = LevelOne.new(sceneGroup, chad)
	sceneGroup:insert(levelOne)

	local buttonActions = {
		onPlayEvent=onPlayEvent,
		onPauseEvent=onPauseEvent,
		onRestartEvent=onRestartEvent,
	}

	runnerButtons = RunnerButtons.new(buttonActions)
	sceneGroup:insert(runnerButtons)

	actions = Actions.new(chad, chadDied)
	destroyed = false
end

function scene:enterFrame(event)
	if chad ~= nil then
		chad:toFront()
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

	actions.destroy()

	fixedStatics:removeSelf()
	chad:removeSelf()
	runnerButtons:removeSelf()

	destroyed = true
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener('enterFrame', scene)

return scene
