local config = require 'src.config'
local debug  = require('src.debug')('play-pause-button')

local PlayPauseButton = {}

function PlayPauseButton.new(width, height, onPlayEvent, onPauseEvent)
  local self = {}
  local widget = require 'widget'
  local pauseButton, playButton

  local _onPauseEvent = function()
    debug('onPauseEvent')
    pauseButton.isVisible = false
    playButton.isVisible = true
    onPauseEvent()
  end

  local _onPlayEvent = function()
    debug('onPauseEvent')
    pauseButton.isVisible = true
    playButton.isVisible = false
    onPlayEvent()
  end

  self.build = function()
    pauseButton = widget.newButton{
  		width=width, height=height,
  		defaultFile="images/buttons/button_pause.png",
  		onRelease=_onPauseEvent
  	}
  	pauseButton.x = display.contentWidth - 110
  	pauseButton.y = 50

    playButton = widget.newButton{
  		width=width, height=height,
  		defaultFile="images/buttons/button_play.png",
  		onRelease=_onPlayEvent
  	}
  	playButton.x = display.contentWidth - 110
  	playButton.y = 50
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
