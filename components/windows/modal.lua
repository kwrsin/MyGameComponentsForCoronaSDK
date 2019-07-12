local M = require("components.windows.frame")()
M.result = -1

function M:create_modal(sceneGroup, length, size, amount, margin, object_sheet, direction, onCreateButton)
  local contents_group = display.newGroup()
  local frame_group = display.newGroup()
  local touch_guard = display.newGroup()
  sceneGroup:insert(touch_guard)
  sceneGroup:insert(contents_group)
  sceneGroup:insert(frame_group)
  local filter = display.newRect(
    touch_guard, 0, 0, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
  filter.isVisible = false
  filter.isHitTestable = true
  filter:addEventListener("touch", function() return true end)

  local contents = {}
  for i = 1, amount do
    local content
    if onCreateButton then
      content = onCreateLabel(contents_group, length, size)
    else
      content = display.newText(contents_group, 0, 0, "", native.systemFont, size)
    end
    content:addEventListener("touch", function()
      return i
    end)

    content.isVisible = false
    table.insert(contents, content)
  end
  M.contents = contents







  M:create_frame(frame_group, width, height, object_sheet)
  self.frame_group = frame_group
  frame_group:isVisible = false

end


function M:show(labels)
  M.result = -1
  
end



function M:hide()
end







return M  
