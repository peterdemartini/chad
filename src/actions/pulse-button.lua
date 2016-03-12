return function(button, onComplete)
  local goBackToNormal = function()
    transition.scaleTo(button, {xScale=1, yScale=1, time=100, onComplete=onComplete})
  end
  transition.scaleTo(button, {xScale=1.2, yScale=1.2, time=100, onComplete=goBackToNormal})
end
