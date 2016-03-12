local debug       = require('src.debug')('frame-master')
local config      = require 'src.config'

local FrameMaster = {}
local screenW = config.screenW

function FrameMaster.new(chad, sceneGroup)
  local layoutItems = require 'src.layouts.default'
  local self = {}
  local moveTimer = nil

  local frames = {}
  local currentFrame = 0
  local currentPosition = 0
  local running = true

  function buildFrame(frame, startX)
    if layoutItems[frame] == nil then
      return
    end
  	debug('buildFrame', frame)
  	frames[frame] = layoutItems[frame].build(sceneGroup, startX - 5)
  end

  local function cancelFrame(frame)
    if frames[frame] == nil then
      return
    end
    debug('cancelFrame', frame)
    frames[frame].cancel()
  end

  local function deleteFrame(frame)
    if frames[frame] == nil then
      return
    end
    debug('deleteFrame', frame)
    frames[frame].destroy(sceneGroup)
    frames[frame] = nil
  end

  local function moveFrame(frame)
    if frames[frame] == nil then
      return
    end
    debug('moveFrame', frame)
    frames[frame].moveX(config.scrollMovementX)
  end

  local function getRemainderOfFrame()
    return currentPosition + (currentFrame * screenW)
  end

  local function maybeDeleteOrCreateFrame()
    local remainderOfFrame = getRemainderOfFrame()
    debug('maybeDeleteOrCreateFrame', remainderOfFrame)
    if remainderOfFrame <= 0 then
      debug('deleteCurrentFrame')
      deleteFrame(currentFrame)
      currentFrame = currentFrame + 1
      local nextStartX = getRemainderOfFrame()
      local nextFrame = currentFrame + 1
      buildFrame(nextFrame, nextStartX)
      moveFrame(currentFrame)
    end
  end

  local function enterTimer()
    debug('enter timer for frame')
    if not running then
      return
    end

    cancelFrame(currentFrame)
    cancelFrame(currentFrame + 1)

    maybeDeleteOrCreateFrame()

    moveFrame(currentFrame)
    moveFrame(currentFrame + 1)

    currentPosition = currentPosition + config.scrollMovementX
    chad.moveX(config.scrollMovementX)
  end

  self.pause = function()
    running = false
  end

  self.play = function()
    running = true
  end

  self.destroy = function()
    debug('destorying')
    if moveTimer then
      timer.cancel(moveTimer)
      moveTimer = nil
    end
    for i = 1, #frames do
      deleteFrame(i)
    end
    package.loaded[layoutItems] = nil
    layoutItems = nil
  end

  buildFrame(1, 0)
  buildFrame(2, screenW - 1)
  currentFrame = 1
  currentPosition = -1

  moveTimer = timer.performWithDelay(config.scrollDelay, enterTimer, -1)

  return self
end

return FrameMaster
