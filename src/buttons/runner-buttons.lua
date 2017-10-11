local RestartButton = require 'src.buttons.restart'
local PlayPauseButton = require 'src.buttons.play-pause'
local RunnerButtons = {}

function RunnerButtons.new(buttonActions)
  local group = display.newGroup()

  group:insert(RestartButton.new(buttonActions.onRestartEvent))
  group:insert(PlayPauseButton.new(buttonActions.onPlayEvent, buttonActions.onPauseEvent))

  return group
end

return RunnerButtons
