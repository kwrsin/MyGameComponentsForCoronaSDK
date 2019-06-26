local vc = require("components.controller.virtual_controller")
local M = {
  vc = vc,
}

function M:get_event_listener(layer_object, listeners)
  local event_handlers = {}

  local function touch(self, event)

    if event.target == nil then
      vc:virtual_touch(event, listeners.touch)
      return true
    elseif event.target.name == 'up' then
      vc:virtual_up(event, listeners.up)
    elseif event.target.name == 'down' then
      vc:virtual_down(event, listeners.down)
    elseif event.target.name == 'left' then
      vc:virtual_left(event, listeners.left)
    elseif event.target.name == 'right' then
      vc:virtual_right(event, listeners.right)
    elseif event.target.name == 'north' then
      vc:virtual_north(event, listeners.north)
    elseif event.target.name == 'south' then
      vc:virtual_south(event, listeners.south)
    elseif event.target.name == 'east' then
      vc:virtual_east(event, listeners.east)
    elseif event.target.name == 'west' then
      vc:virtual_west(event, listeners.west)
    end
    if event.phase == "began" then
      event.target.alpha = 0.6
      display.getCurrentStage():setFocus(event.target)
      self.isFocus = true
    elseif self.isFocus then
      if event.phase == "ended" or event.phase == "cancelled" then
        event.target.alpha = 1
        display.getCurrentStage():setFocus(nil)
        self.isFocus = nil
      end
    end 
    return true
  end

  local function create_buttons(layer_object, event_handlers)
    local go = display.newRect(layer_object, display.contentCenterX, display.contentCenterY, 32, 32)
    go.name = "up"
    go:setFillColor(1, 0, 0)
    go:addEventListener("touch", event_handlers)
  end


  event_handlers.touch = touch
  create_buttons(layer_object, event_handlers)

  return event_handlers
end

function M:get_virtual_controller(layer_object, listeners)
  return self:get_event_listener(layer_object, listeners)
end

return M
