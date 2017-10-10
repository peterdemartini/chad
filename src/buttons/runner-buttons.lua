local RunnerButtons = {}

function RunnerButtons.new(buttonActions)
  local self = {}
  local RestartButton = require 'src.buttons.restart'
  local PlayPauseButton = require 'src.buttons.play-pause'
  local jumpButton, restartButton, playPauseButton

  self.build = function()
    restartButton = RestartButton.new(buttonActions.onRestartEvent)
    restartButton.build()

    playPauseButton = PlayPauseButton.new(buttonActions.onPlayEvent, buttonActions.onPauseEvent)
    playPauseButton.build()
  end

  self.destroy = function()
    restartButton.destroy()
    package.loaded[RestartButton] = nil
    RestartButton = nil
    restartButton = nil

    playPauseButton.destroy()
    package.loaded[PlayPauseButton] = nil
    PlayPauseButton = nil
    playPauseButton = nil
  end
  return self
end

return RunnerButtons
