local utf8 = require('plugin.utf8')

local M = require("components.windows.frame")()

function M:create_banner(sceneGroup, object_sheet, text_options)
  M.banner_group = display.newGroup()
  M.contents_group = display.newGroup()
  local frame_group = display.newGroup()
  banner_group:insert(M.contents_group)
  banner_group:insert(frame_group)
  touch_guard = display.newGroup()
  M.root_group = display.newGroup()

  M.root_group:insert(M.banner_group)
  M.root_group:insert(touch_guard)
  sceneGroup:insert(M.root_group)
  M.filter = M:create_filter(touch_guard)
  M:create_text(text_options)
  M:set_frame(frame_group, object_sheet)
end

function M:create_text(text_options)
  local size = nil
  if text_options then
    size = text_options.size 
  end
  local text = display.newText(M.contents_group, "", 0, 0, native.systemFont, size)
  text.kind = "text"
  if text_options then
    for k, v in pairs(text_options) do
      text[k] = v
    end
  end

  M.banner_group.isVisible = false
end

function M:show_banner(sentence, x, y, size, text_options, onClose, onAction)
  M.filter.isHitTestable = true
  local text = M:get_label_object(M.contents_group, "text")
  if text then
    text.isVisible = true
    text.text = sentence
    text.size = size
    if text_options then
      for k, v in pairs(text_options) do
        text[k] = v
      end
    end
    local width = utf8.len(sentence) * size
    local height = size
    M:adjust_frame(width, height)
    if onAction then
      onAction(M.banner_group, x, y)
    else
      M.banner_group.x = 0
      M.banner_group.y = 0
      transition.to(M.banner_group, {time=100, onComplete=function(event)
        timer.performWithDelay(200, function(event)
          M.filter.isHitTestable = false
          if onClose then
            onClose()
          end
        end)
      end})
    end
  end
end

return M  