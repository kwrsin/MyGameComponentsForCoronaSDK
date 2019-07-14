local utf8 = require('plugin.utf8')

local M = require("components.windows.frame")()
M.result = -1
M.amount = 9

function M:create_modal(sceneGroup, object_sheet, text_options, onCreateButton)
  local root_group = display  .newGroup()
  local contents_group = display.newGroup()
  local frame_group = display.newGroup()
  local touch_guard = display.newGroup()
  root_group:insert(touch_guard)
  root_group:insert(contents_group)
  root_group:insert(frame_group)
  sceneGroup:insert(root_group)
  root_group.x = display.contentCenterX
  root_group.y = display.contentCenterY
  M.root_group = root_group
  M.contents_group = contents_group

  local filter = display.newRect(
    touch_guard, 0, 0, display.actualContentWidth, display.actualContentHeight)
  filter.isVisible = false
  filter.isHitTestable = false
  filter:addEventListener("touch", function() print("guard") return true end)
  M.filter = filter
  M.default_text_options = text_options

  local size = nil
  if text_options then
    size = text_options.size 
  end
  local contents = {}
  for i = 1, M.amount do
    local content
    if onCreateButton then
      content = onCreateLabel(contents_group, length, size)
    else
      content = display.newText(contents_group, "", 0, 0, native.systemFont, size)
    end
    if text_options then
      for k, v in pairs(text_options) do
        content[k] = v
      end
    end
    content.index = i
    content:addEventListener("touch", function(event)
      if event.phase == "ended" or event.phase == "cancelled" then
        M.result = content.index
        M:close()
      end
      return true
    end)

    content.isVisible = false
    table.insert(contents, content)
  end
  M.contents = contents

  M:create_frame(frame_group, object_sheet)
  M.frame_group = frame_group
  frame_group.isVisible = false
end


function M:show(labels, width, height, size, margin, onClose, text_options)
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
  local function put_demension(labels, max_length, size, offset_y, spacing)
    for i = 1, #labels do
      if type(labels[i]) == "table" then
        put_demension(labels[i], max_length, size, offset_y + size * (i - 1), spacing)
      else
        local content = M.contents[M.used_index]
        content.size = size
        content.text = labels[i]
        content.y = offset_y + margin
        if #labels == 1 then
          content.x = 0
        else
          content.x = -display.contentCenterX + margin + utf8.len(labels[1]) * size / 2 + spacing * (i - 1)
        end
        content.isVisible = true
        M.used_index = M.used_index + 1
        if text_options then
          for k, v in pairs(text_options) do
            content[k] = v
          end
        elseif M.default_text_options then
          for k, v in pairs(M.default_text_options) do
            content[k] = v
          end
        end
      end
    end
  end

  local strings = flatten(labels)
  -- table.sort(strings, function(m, l) return (#m > #l) end)
  local max_length = utf8.len(strings[1])
  local most_left_side = margin + utf8.len(strings[1]) * size / 2
  local most_right_side = display.actualContentWidth - margin - utf8.len(strings[#strings]) * size / 2
  local max_row, max_col = get_max_count_dimension(labels)
  local spacing
  if (max_col - 1) <= 0 then
    spacing = display.contentCenterX
  else
    spacing = (most_right_side - most_left_side) / (max_col - 1)
  end

  put_demension(labels, max_length, size, -margin, spacing)

end

function M:close()
  if M.onClose then
    M.onClose(M.result)
  end
  M.frame_group.isVisible = false
  M.filter.isHitTestable = false
  for i = 1, #M.contents do
    M.contents[i].isVisible = false
  end
  M.root_group.isVisible = false
end







return M  
