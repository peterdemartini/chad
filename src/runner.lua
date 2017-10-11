local config        = require 'src.config'
local composer      = require 'composer'
local physics       = require 'physics'
local Chad          = require 'src.characters.chad'
local LevelOne      = require 'src.levels.one'
local RunnerButtons = require 'src.buttons.runner-buttons'
local debug         = require('src.debug')('runner')

local screenW, screenH = display.contentWidth, display.contentHeight
local chad, touchObject, runnerButtons, frames
local destroyed = false
local runtime = 0
local scrollSpeed = 5

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

function onDeath()
	scene:destroy()
	composer.gotoScene("src.dead", "fade", 100)
	return true
end

local function onPauseEvent()
	physics.pause()
	return true
end

local function onPlayEvent()
	physics.start()
	return true
end

local function getDeltaTime()
   local temp = system.getTimer()
   local dt = (temp-runtime) / (1000/60)
   runtime = temp
   return dt
end

local function onEnterFrame(event)
	local dt = getDeltaTime()
	chad:toFront()
	local moveX = -(scrollSpeed * dt)
	for i = 1, #frames do
		frames[i]:translate(moveX, 0)
	end
end

function scene:create(event)
	debug('Creating scene')
	local sceneGroup = self.view

	composer.removeScene('src.dead', true)
	composer.removeScene('src.reloading')

	chad = Chad.new()
	chad:addEventListener("dead", onDeath)
	sceneGroup:insert(chad)

	frames = LevelOne.new()
	for i = 1, #frames do
		sceneGroup:insert(frames[i])
	end
	runnerButtons = RunnerButtons.new()
	runnerButtons:addEventListener("play", onPlayEvent)
	runnerButtons:addEventListener("pause", onPauseEvent)
	runnerButtons:addEventListener("restart", onRestartEvent)
	sceneGroup:insert(runnerButtons)
	destroyed = false
end

function scene:show(event)
	local sceneGroup = self.view
	if event.phase == "did" then
		Runtime:addEventListener('enterFrame', onEnterFrame)
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
			Runtime:addEventListener('enterFrame', onEnterFrame)
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
	chad:removeEventListener("dead", onDeath)
	runnerButtons:removeEventListener("play", onPlayEvent)
	runnerButtons:removeEventListener("pause", onPauseEvent)
	runnerButtons:removeEventListener("restart", onRestartEvent)
	scene:removeEventListener("create")
	scene:removeEventListener("show")
	scene:removeEventListener("hide")
	scene:removeEventListener("destroy")
	runnerButtons:removeSelf()
	chad:removeSelf()
	for i = 1, #frames do
		frames[i].removeSelf()
	end

	destroyed = true
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene
