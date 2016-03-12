local config = require 'src.config'
local pulse  = require 'src.actions.pulse-button'
local debug  = require('src.debug')('run-button')

local RunButton = {}

function RunButton.new(onRunEvent)
  local self = {}
  local widget = require 'widget'
  local jumpButton

  local _onRunEvent = function()
    debug('onRunEvent')
    pulse(jumpButton)
    onRunEvent()
  end

  self.build = function()
    jumpButton = widget.newButton{
  		width=config.actionButtonSize, height=config.actionButtonSize,
  		defaultFile="images/buttons/button_forward.png",
  		onRelease=_onRunEvent
  	}
  	jumpButton.x = display.contentWidth - config.actionButtonMargin
  	jumpButton.y = display.contentHeight - config.actionButtonMargin
  end

  self.destroy = function()
    package.loaded[widget] = nil
    widget = nil
    jumpButton:removeSelf()
    jumpButton = nil
  end

  return self
end

return RunButton
