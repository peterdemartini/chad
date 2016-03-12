local config = require 'src.config'
local pulse  = require 'src.actions.pulse-button'
local debug  = require('src.debug')('play-pause-button')

local PlayPauseButton = {}

function PlayPauseButton.new(onPlayEvent, onPauseEvent)
  local self = {}
  local widget = require 'widget'
  local pauseButton, playButton

  local _onPauseEvent = function()
    debug('onPauseEvent')

    local onComplete = function()
      pauseButton.isVisible = false
      playButton.isVisible = true
    end
    pulse(pauseButton, onComplete)

    onPauseEvent()
  end

  local _onPlayEvent = function()
    debug('onPlayEvent')
    local onComplete = function()
      pauseButton.isVisible = true
      playButton.isVisible = false
    end
    pulse(playButton, onComplete)
    onPlayEvent()
  end

  self.build = function()
    pauseButton = widget.newButton{
  		width=config.gameButtonSize, height=config.gameButtonSize,
  		defaultFile="images/buttons/button_pause.png",
  		onRelease=_onPauseEvent
  	}
  	pauseButton.x = display.contentWidth - ((config.gameButtonMargin * 2) + 10)
  	pauseButton.y = config.gameButtonMargin

    playButton = widget.newButton{
  		width=config.gameButtonSize, height=config.gameButtonSize,
  		defaultFile="images/buttons/button_play.png",
  		onRelease=_onPlayEvent
  	}
  	playButton.x = display.contentWidth - ((config.gameButtonMargin * 2) + 10)
  	playButton.y = config.gameButtonMargin
  	playButton.isVisible = false
  end

  self.destroy = function()
    package.loaded[widget] = nil
    widget = nil
    playButton:removeSelf()
    pauseButton:removeSelf()
    playButton = nil
    pauseButton = nil
  end

  return self
end

return PlayPauseButton
