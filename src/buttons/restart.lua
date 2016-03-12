local config = require 'src.config'
local debug  = require('src.debug')('restart-button')

local RestartButton = {}

function RestartButton.new(width, height, onRestartEvent)
  local self = {}
  local widget = require 'widget'
  local restartButton

  local _onRestartEvent = function()
    debug('onRestartEvent')
    onRestartEvent()
  end

  self.build = function()
    restartButton = widget.newButton{
  		width=width, height=height,
  		defaultFile="images/buttons/button_repeat.png",
  		onRelease=_onRestartEvent
  	}
  	restartButton.x = display.contentWidth - 50
  	restartButton.y = 50
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
