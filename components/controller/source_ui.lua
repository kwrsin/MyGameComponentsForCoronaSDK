local vc = require("components.controller.virtual_controller")
local M = {
  vc = vc,
  listeners = nil
}

function M:is_repeated(event)
  local keep = false
  if event.phase == "began" then
    keep = true
  elseif event.phase == "ended" or event.phase == "cancelled" then
    keep = false
  end
  return keep
end

function M:set_vc_event_listeners(listeners)
  self.listeners = listeners
end

function M:enable_touch(enabled)
  if enabled then
    self.touch_guard.isHitTestable = false
  else
    self.touch_guard.isHitTestable = true
  end
end

function M:create_vertual_controller(layer_object, listeners)
  local event_handlers = {}
  self.listeners = listeners

  local function touch(self, event)
    event.is_repeated = M:is_repeated(event)

    if event.target == nil then
      if M.listeners.touch then
        vc:virtual_touch(event, M.listeners.touch)
        return true
      end
    elseif event.target.name == 'up' then
      if M.listeners.up then
        vc:virtual_up(event, M.listeners.up)
      end
    elseif event.target.name == 'down' then
      if M.listeners.down then
        vc:virtual_down(event, M.listeners.down)
      end
    elseif event.target.name == 'left' then
      if M.listeners.left then
        vc:virtual_left(event, M.listeners.left)
      end
    elseif event.target.name == 'right' then
      if M.listeners.right then
        vc:virtual_right(event, M.listeners.right)
      end
    elseif event.target.name == 'north' then
      if M.listeners.north then
        vc:virtual_north(event, M.listeners.north)
      end
    elseif event.target.name == 'south' then
      if M.listeners.south then
        vc:virtual_south(event, M.listeners.south)
      end
    elseif event.target.name == 'east' then
      if M.listeners.east then
        vc:virtual_east(event, M.listeners.east)
      end
    elseif event.target.name == 'west' then
      if M.listeners.west then
        vc:virtual_west(event, M.listeners.west)
      end
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

  local function create_touch_guard(layer_object)
    local touch_guard = display.newRect(layer_object, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    touch_guard.isVisible = false
    touch_guard.isHitTestable = true
    touch_guard:addEventListener("touch", function(event)
      print("can not touch!!")
      return true
    end)
    touch_guard:setFillColor(0, 1, 0)
    touch_guard.alpha = .3
    M.touch_guard = touch_guard
  end


  event_handlers.touch = touch
  create_buttons(layer_object, event_handlers)

  create_touch_guard(layer_object)

  return event_handlers
end

function M:get_virtual_controller(layer_object, listeners)
  return self:create_vertual_controller(layer_object, listeners)
end

return M
