local RunnerButtons = {}

function RunnerButtons.new(buttonActions)
  local self = {}
  local JumpButton = require 'src.buttons.jump'
  local RunButton = require 'src.buttons.run'
  local RestartButton = require 'src.buttons.restart'
  local PlayPauseButton = require 'src.buttons.play-pause'
  local jumpButton, runButton, restartButton, playPauseButton

  self.build = function()
    jumpButton = JumpButton.new(buttonActions.onJumpEvent)
    jumpButton.build()

    runButton = RunButton.new(buttonActions.onRunEvent)
    runButton.build()

    restartButton = RestartButton.new(buttonActions.onRestartEvent)
    restartButton.build()

    playPauseButton = PlayPauseButton.new(buttonActions.onPlayEvent, buttonActions.onPauseEvent)
    playPauseButton.build()
  end

  self.destroy = function()
    jumpButton.destroy()
    package.loaded[JumpButton] = nil
    JumpButton = nil
    jumpButton = nil

    runButton.destroy()
    package.loaded[RunButton] = nil
    RunButton = nil
    runButton = nil

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
