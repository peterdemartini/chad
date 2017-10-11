local RestartButton = require 'src.buttons.restart'
local PlayPauseButton = require 'src.buttons.play-pause'
local RunnerButtons = {}

function RunnerButtons.new()
  local group = display.newGroup()
  local onRestartEvent = function()
    group:dispatchEvent({ name="restart" })
  end
  local onPlayEvent = function()
    group:dispatchEvent({ name="play" })
  end
  local onPauseEvent = function()
    group:dispatchEvent({ name="pause" })
  end

  group:insert(RestartButton.new(onRestartEvent))
  group:insert(PlayPauseButton.new(onPlayEvent, onPauseEvent))

  return group
end

return RunnerButtons
