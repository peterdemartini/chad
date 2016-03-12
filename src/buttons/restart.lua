local config = require 'src.config'
local pulse  = require 'src.actions.pulse-button'
local debug  = require('src.debug')('restart-button')

local RestartButton = {}

function RestartButton.new(onRestartEvent)
  local self = {}
  local widget = require 'widget'
  local restartButton

  local _onRestartEvent = function()
    debug('onRestartEvent')
    local onComplete = function()
      onRestartEvent()
    end
    pulse(restartButton, onComplete)
  end

  self.build = function()
    restartButton = widget.newButton{
  		width=config.gameButtonSize, height=config.gameButtonSize,
  		defaultFile="images/buttons/button_repeat.png",
  		onRelease=_onRestartEvent
  	}
  	restartButton.x = display.contentWidth - config.gameButtonMargin
  	restartButton.y = config.gameButtonMargin
  end

  self.destroy = function()
    package.loaded[widget] = nil
    widget = nil
    restartButton:removeSelf()
    restartButton = nil
  end

  return self
end

return RestartButton
