local vc = require("components.controller.virtual_controller")
local M = {
  vc = vc,
  listeners = nil,
  controller_group = nil
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

function M:show_controller(enabled)
  self.controller_group.isVisible = enabled
end

function M:create_vertual_controller(layer_object, listeners)
  local event_handlers = {}
  self.listeners = listeners

  local function touch(self, event)
    -- event.is_repeated = M:is_repeated(event)
    if event.target then
      local distance_x = event.x - M.cursor_group.x
      local distance_y = event.y - M.cursor_group.y
      event.target.distance_normal_x = distance_x / event.target.path.radius
      event.target.distance_normal_y = distance_y / event.target.path.radius
      if event.phase == "began" then
        event.target.alpha = 0.6
        display.getCurrentStage():setFocus(event.target)
        self.isFocus = true
        event.is_repeated = true
        M.cursor_object.x = distance_x
        M.cursor_object.y = distance_y

      elseif event.phase == "moved" then
        if not self.isFocus then
          display.getCurrentStage():setFocus(event.target)
          self.isFocus = true
          event.is_repeated = true
        end
        event.target.alpha = 0.6

        if (distance_x * distance_x +  distance_y * distance_y < event.target.path.radius * event.target.path.radius) then
          M.cursor_object.x = distance_x
          M.cursor_object.y = distance_y
          event.is_repeated = true
        else
          M.cursor_object.x = 0
          M.cursor_object.y = 0
          event.target.alpha = 1
          display.getCurrentStage():setFocus(nil)
          self.isFocus = nil
          event.is_repeated = false
        end
      elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
          M.cursor_object.x = 0
          M.cursor_object.y = 0
          event.target.alpha = 1
          display.getCurrentStage():setFocus(nil)
          self.isFocus = nil
          event.is_repeated = false
        end
      end 
    end

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
    return true
  end

  local function create_buttons(layer_object, event_handlers)
    self.controller_group = display.newGroup()
    layer_object:insert(self.controller_group)

    self.cursor_group = display.newGroup()
    self.cursor_group.x = display.contentCenterX - 82
    self.cursor_group.y = display.contentCenterY
    self.controller_group:insert(self.cursor_group)


    local go = display.newCircle(self.cursor_group, 0, 0, 64)
    go.name = "up"
    go:setFillColor(1, 0, 0)
    go:addEventListener("touch", event_handlers)

    local cursor_object = display.newCircle(self.cursor_group, 0, 0, 24)
    self.cursor_object = cursor_object
    cursor_object:addEventListener("touch", function(event)
      return false
    end)

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
