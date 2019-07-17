local utf8 = require('plugin.utf8')

local M = require("components.windows.frame")()
M.result = -1
M.amount = 9

function M:create_button_background(content)
  local background = display.newRoundedRect(content, 0, 0, 12, 12, 5)
  background.kind = "bg"
end

function M:set_button_background(background, label, size)
  background:setFillColor(0, 0, 1, 1)
  background.width = utf8.len(label) * size
  background.height = size * 1.4 
end

function M:create_button_front(content)
  -- local front = display.newRoundedRect(content, 0, 0, 12, 12, 5)
  -- front.kind = "front"
end

function M:set_button_front(front, label, size)
  -- front:setFillColor(1, 1, 1, 0.6)
  -- front.width = utf8.len(label) * size
  -- front.height = size * 1.2 
end

function M:visible_content(content, enabled, onHide)
  -- M:set_filter_color(enabled)
  if enabled then
    M.frame_group.isVisible = true
    content.isVisible = enabled
    content.yScale = 0.1
    transition.scaleTo(content, {yScale=1, xScale=1, time=50})

  else
    local time = 100
    local yScale = 0.1
    if content.index == M.result then
      content.yScale = 1.2
      -- local front = M:get_label_object(content, "front")
      -- front:setFillColor(0.2, 0.15, 0.65, 0.6)
      transition.scaleTo(content, {yScale=yScale, time=time, onComplete=function()
        content.isVisible = enabled
        if onHide then
          onHide()
        end
      end})
    else
      content.yScale = 1
      transition.scaleTo(content, {yScale=yScale, time=time, onComplete=function()
        content.isVisible = enabled
      end})
    end
  end
end

function M:get_label_object(content, kind)
  for i = 1 , content.numChildren do
    if content[i].kind and content[i].kind == kind then
      return content[i]
    end
  end
end

function M:set_filter_color(enabled)
  -- if enabled then
  --   M.filter.isVisible = true
  --   M.filter.alpha = 0.3
  -- else
  --   M.filter.isVisible = false
  --   M.filter.alpha = 0
  -- end
end

function M:set_filter_effect(filter)
  -- filter:setFillColor(0, 0, 0)
end

function M:create_modal(sceneGroup, object_sheet, text_options)
  local root_group = display  .newGroup()
  local contents_group = display.newGroup()
  local frame_group = display.newGroup()
  local touch_guard = display.newGroup()
  root_group:insert(touch_guard)
  root_group:insert(contents_group)
  root_group:insert(frame_group)
  sceneGroup:insert(root_group)
  root_group.x = display.contentCenterX
  root_group.y = display.actualContentHeight / 2
  M.root_group = root_group
  M.contents_group = contents_group

  local filter = display.newRect(
    touch_guard, 0, 0, display.actualContentWidth, display.actualContentHeight)
  filter.isVisible = false
  filter.isHitTestable = false
  M:set_filter_effect(filter)

  filter:addEventListener("touch", function() print("guard") return true end)
  M.filter = filter
  M.default_text_options = text_options

  local size = nil
  if text_options then
    size = text_options.size 
  end
  local contents = {}
  for i = 1, M.amount do
    content = display.newGroup()
    M:create_button_background(content)
    label = display.newText(content, "", 0, 0, native.systemFont, size)
    label.kind = "label"
    M:create_button_front(content)

    contents_group:insert(content)
    if text_options then
      for k, v in pairs(text_options) do
        label[k] = v
      end
    end
    content.index = i
    content:addEventListener("touch", function(event)
      if event.phase == "ended" or event.phase == "cancelled" then
        if M.result == -1 then
          M.result = event.target.index
          M:close()
        end
      end
      return true
    end)

    content.isVisible = false
    table.insert(contents, content)
  end
  M.contents = contents

  M:set_frame(frame_group, object_sheet)
  M.frame_group = frame_group
  frame_group.isVisible = false
end


function M:show(labels, x, y, size, x_margin, y_spacing, onClose, text_options)
  M.result = -1
  M.used_index = 1
  M.root_group.isVisible = true
  M.filter.isHitTestable = true
  M.onClose = onClose

  -- local function countup(labels)
  --   local cnt = 0
  --   for i = 1, #labels do
  --     if type(labels[i]) == "table" then
  --       cnt = cnt + countup(labels[i])
  --     else
  --       cnt = cnt + 1
  --     end
  --   end
  --   return cnt
  -- end
  local function merge(a, b)
    for i = 1, #b do
      table.insert(a, b[i])
    end
  end
  local function flatten(tbl)
    local array = {}
    for i = 1, #tbl do
      if type(tbl[i]) == "table" then
        merge(array, flatten(tbl[i]))
      else
        table.insert(array, tbl[i])
      end
    end
    return array
  end
  local function get_max_count_dimension(demensions)
    local cnt_row = #demensions
    local max_col = #demensions[1]
    if type(demensions[1]) == "table" then
      for i = 2, #demensions do
        if #demensions[i] > max_col then
          max_col = #demensions[i]
        end
      end
      return cnt_row, max_col
    else
      return 1, #demensions
    end
  end
  local function put_demension(labels, size, offset_y, max_col, x_margin, y_spacing, counter)
    for i = 1, #labels do
      local is_need_cr = false
      if type(labels[i]) == "table" then
        counter = counter + 1
        put_demension(labels[i], size, offset_y, max_col, x_margin, y_spacing, counter)
        is_need_cr = true
      else
        if is_need_cr then
          offset_y = offset_y + size * (i - 1)
          is_need_cr = false
        end

        local strings = flatten(labels)
        local most_left_side = x_margin + utf8.len(strings[1]) * size / 2
        local most_right_side = display.actualContentWidth - x_margin - utf8.len(strings[#strings]) * size / 2
        local spacing
        if (max_col - 1) <= 0 then
          spacing = display.contentCenterX
        else
          spacing = (most_right_side - most_left_side) / (max_col - 1)
        end


        local content = M.contents[M.used_index]
        local label = M:get_label_object(M.contents[M.used_index], "label")
        local back = M:get_label_object(M.contents[M.used_index], "bg")
        local front = M:get_label_object(M.contents[M.used_index], "front")
        label.size = size
        label.text = labels[i]
        if counter == -1 then
          content.y = offset_y
        else
          content.y = offset_y + (size + y_spacing) * counter
        end
        if #labels == 1 then
          content.x = 0
        else
          content.x = -display.contentCenterX + x_margin + utf8.len(labels[1]) * size / 2 + spacing * (i - 1)
        end
        M:set_button_front(front, labels[i], size)
        M:set_button_background(back, labels[i], size)
        M:visible_content(content, true)
        M.used_index = M.used_index + 1
        if text_options then
          for k, v in pairs(text_options) do
            label[k] = v
          end
        elseif M.default_text_options then
          for k, v in pairs(M.default_text_options) do
            label[k] = v
          end
        end
      end
    end
  end

  local max_row, max_col = get_max_count_dimension(labels)
  local most_top_side = -max_row * (size + y_spacing) / 2
  put_demension(labels, size, most_top_side, max_col, x_margin, y_spacing, -1)

  for i = 1, M.frame_group.numChildren do
    local width = display.actualContentWidth - x_margin - x_margin
    local height = (size + y_spacing) * max_row
    M.frame_group[i].x = 0
    M.frame_group[i].y = -(size + y_spacing) / 2
    M.frame_group[i].width = width 
    M.frame_group[i].height = height 
  end

  M.contents_group.x = M.contents_group.x + x
  M.contents_group.y = M.contents_group.x + y
  M.frame_group.x = M.frame_group.x + x
  M.frame_group.y = M.frame_group.x + y
end

function M:set_frame(frame_group, object_sheet)
  local frame = display.newRect(frame_group, 0, 0, 32, 32)
  frame:setFillColor(1, 0, 1, 0.3)
end

function M:close()
  if M.onClose then
    M.onClose(M.result)
  end
  M:hide()
end

function M:hide()
  local selected_button
  for i = 1, #M.contents do
    if M.result == M.contents[i].index then
      selected_button = M.contents[i]
      break
    end
  end
  selected_button:toFront()
  local blink = transition.to(selected_button, {xScale=1.5, yScale=1.5, time=300, transition=easing.outElastic})
  timer.performWithDelay(500, function()
    selected_button.xScale = 1
    selected_button.yScale = 1

    for i = 1, #M.contents do
      M:visible_content(M.contents[i], false, function()
        M.frame_group.isVisible = false
        M.filter.isHitTestable = false
        M.filter.isVisible = false
        M.root_group.isVisible = false
      end)
    end
  end)
end







return M  
