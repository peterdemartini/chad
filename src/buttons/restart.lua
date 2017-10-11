local widget = require 'widget'
local config = require 'src.config'
local pulse  = require 'src.actions.pulse-button'
local debug  = require('src.debug')('restart-button')

local RestartButton = {}

function RestartButton.new(onRestartEvent)
  local button

  local _onRestartEvent = function()
    debug('onRestartEvent')
    local onComplete = function()
      onRestartEvent()
    end
    pulse(button, onComplete)
  end

  button = widget.newButton{
		width=config.gameButtonSize, height=config.gameButtonSize,
		defaultFile="images/buttons/button_repeat.png",
		onRelease=_onRestartEvent
	}
	button.x = display.contentWidth - config.gameButtonMargin
	button.y = config.gameButtonMargin

  return button
end

return RestartButton
