local config = require 'src.config'
local pulse  = require 'src.actions.pulse-button'
local debug  = require('src.debug')('run-button')

local RunButton = {}

function RunButton.new(onRunEvent, onEndRunEvent)
  local self = {}
  local widget = require 'widget'
  local jumpButton

  local pressButton = function(event)
    if event.phase == 'began' then
      pulse(jumpButton)
      onRunEvent()
      return
    end
    if event.phase == 'ended' then
      onEndRunEvent()
      return
    end
  end

  self.build = function()
    jumpButton = widget.newButton{
  		width=config.actionButtonSize, height=config.actionButtonSize,
  		defaultFile="images/buttons/button_forward.png"
  	}
  	jumpButton.x = display.contentWidth - config.actionButtonMargin
  	jumpButton.y = display.contentHeight - config.actionButtonMargin

    jumpButton:addEventListener('touch', pressButton)
  end

  self.destroy = function()
    package.loaded[widget] = nil
    widget = nil
    jumpButton:removeEventListener('touch', pressButton)
    jumpButton:removeSelf()
    jumpButton = nil
  end

  return self
end

return RunButton
