local M = {}
M.listeners = nil
M.controller_group = nil
M.RELEASED = 0
M.PUSHED = 1
M.button_state = {}


function M:disable_touch_hit_testable(enabled)
  if enabled then
    self.touch_guard.isHitTestable = false
  else
    self.touch_guard.isHitTestable = true
  end
end

function M:show_controller(enabled)
  self.controller_group.isVisible = enabled
end

function M:set_pad_position(x, y)
  self.cursor_group.x = display.contentCenterX + x
  self.cursor_group.y = display.contentCenterY + y
end

function M:create_vertual_controller(layer_object, listeners)
  local event_handlers = {}
  M:set_vc_event_listeners(listeners)

  local function touch(self, event)
    if event.target and event.target.name == 'cursor' then
      local distance_x = event.x - M.cursor_group.x
      local distance_y = event.y - M.cursor_group.y
      event.target.distance_normal_x = distance_x / event.target.path.radius
      event.target.distance_normal_y = distance_y / event.target.path.radius
      if event.phase == "began" then
        event.target.alpha = 0.6
        display.getCurrentStage():setFocus(event.target)
        self.isFocus = true
        M.cursor_object.x = distance_x
        M.cursor_object.y = distance_y

      elseif event.phase == "moved" then
        event.target.alpha = 0.6

        if (distance_x * distance_x +  distance_y * distance_y < event.target.path.radius * event.target.path.radius) then
          if not self.isFocus then
            display.getCurrentStage():setFocus(event.target)
            self.isFocus = true
          else
          end
          M.cursor_object.x = distance_x
          M.cursor_object.y = distance_y
        else
          M.cursor_object.x = 0
          M.cursor_object.y = 0
          event.target.alpha = 1
          display.getCurrentStage():setFocus(nil)
          self.isFocus = nil
        end
      elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
          M.cursor_object.x = 0
          M.cursor_object.y = 0
          event.target.alpha = 1
          display.getCurrentStage():setFocus(nil)
          self.isFocus = nil
        end
      end 
    end
    local result
    if event.target == nil then
      result = M:execute(event, "touch")
    else
      result = M:execute(event, event.target.name)
    end
    if result == nil then
      return true
    else
      return result
    end
  end

  local function create_buttons(layer_object, event_handlers)
    self.controller_group = display.newGroup()
    layer_object:insert(self.controller_group)

    self.cursor_group = display.newGroup()
    self:set_pad_position(-82, 180)
    self.controller_group:insert(self.cursor_group)


    local go = display.newCircle(self.cursor_group, 0, 0, 64)
    go.name = "cursor"
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

function M:set_vc_event_listeners(listeners)
  self.listeners = listeners
  for button_name, v in pairs(self.listeners) do
    M.button_state[button_name] = M.RELEASED
  end
end

function M:execute(event, button_name)
  if event.phase == "began" or event.phase == "moved" then
    M.button_state[button_name] = M.PUSHED
  elseif event.phase == "ended" or event.phase == "cancelled" then
    M.button_state[button_name] = M.RELEASED
  end
  if self.listeners then
    return self.listeners[button_name](event)
  end
  return true
end

function M:observe(button_name, handler)
  if M.button_state[button_name] == M.PUSHED then
    handler()
  end
end

function M:is_button_repeated(button_name)
  return M.button_state[button_name] == M.PUSHED
end

return M
