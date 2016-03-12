local config = require 'src.config'
local pulse  = require 'src.actions.pulse-button'
local debug  = require('src.debug')('jump-button')

local JumpButton = {}

function JumpButton.new(onJumpEvent)
  local self = {}
  local widget = require 'widget'
  local jumpButton

  local _onJumpEvent = function()
    debug('onJumpEvent')
    pulse(jumpButton)
    onJumpEvent()
  end

  self.build = function()
    jumpButton = widget.newButton{
  		width=config.actionButtonSize, height=config.actionButtonSize,
  		defaultFile="images/buttons/button_jump.png",
  		onRelease=_onJumpEvent
  	}
  	jumpButton.x = config.actionButtonMargin
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

return JumpButton
