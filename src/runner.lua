local config        = require 'src.config'
local composer      = require 'composer'
local physics       = require 'physics'
local Chad          = require 'src.characters.chad'
local LevelOne      = require 'src.levels.one'
local RunnerButtons = require 'src.buttons.runner-buttons'
local debug         = require('src.debug')('runner')

local chad, runnerButtons, frames
local runtime = 0
local scrollSpeed = 10

local scene = composer.newScene()
physics.start(); physics.pause()
physics.setGravity( 0, 32 )

if config.debugPhysics then
	debug('Setting Draw Mode to Hybrid')
	physics.setDrawMode("hybrid")
end

function onRestartEvent()
	local sceneName = composer.getSceneName("current")
	composer.removeScene(sceneName)
	composer.gotoScene(sceneName, "fade", 100)
	return true
end

function onDeath()
	local sceneName = composer.getSceneName("current")
	composer.removeScene(sceneName)
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
	if dt > 10 then
		return 10
	else
		return dt
	end
end

local function onEnterFrame(event)
	local dt = getDeltaTime()
	if chad and not chad.isDead then
		chad:toFront()
	end
	local moveX = -(scrollSpeed * dt)
	for i = 1, #frames do
		if frames[i] and frames[i].x then
			frames[i]:translate(moveX, 0)
		end
	end
end

function scene:create(event)
	local sceneGroup = self.view
	debug("scene create")

	composer.removeScene('src.dead', true)
	composer.removeScene('src.reloading')

	frames = LevelOne.new()
	for i = 1, #frames do
		sceneGroup:insert(frames[i])
	end

	runnerButtons = RunnerButtons.new()
	runnerButtons:addEventListener("play", onPlayEvent)
	runnerButtons:addEventListener("pause", onPauseEvent)
	runnerButtons:addEventListener("restart", onRestartEvent)
	sceneGroup:insert(runnerButtons)
end

function scene:show(event)
	local sceneGroup = self.view
	if event.phase == "will" then
		chad = Chad.new()
		chad:addEventListener("dead", onDeath)
		sceneGroup:insert(chad)
	end
	if event.phase == "did" then
		onPlayEvent()
		runtime = 0
		Runtime:addEventListener("enterFrame", onEnterFrame)
	end
end

function scene:hide(event)
	if event.phase == "will" then
		onPauseEvent()
		runtime = 0
		Runtime:addEventListener("enterFrame", onEnterFrame)
	end
end

function scene:destroy(event)
	debug("scene destroy")
	chad:removeEventListener("dead", onDeath)
	runnerButtons:removeEventListener("play", onPlayEvent)
	runnerButtons:removeEventListener("pause", onPauseEvent)
	runnerButtons:removeEventListener("restart", onRestartEvent)
	runnerButtons:removeSelf()
	chad:removeSelf()
	for i = 1, #frames do
		frames[i]:removeSelf()
	end
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene
