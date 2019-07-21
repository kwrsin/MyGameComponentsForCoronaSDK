return function()
  local M = {}

  function M:get_label_object(content, kind)
    for i = 1 , content.numChildren do
      if content[i].kind and content[i].kind == kind then
        return content[i]
      end
    end
  end

  function M:create_filter(touch_guard)
    local filter = display.newRect(
      touch_guard, 0, 0, display.actualContentWidth, display.actualContentHeight)
    filter.isVisible = false
    filter.isHitTestable = false
    M:set_filter_effect(filter)

    filter:addEventListener("touch", function() print("guard") return true end)
    return filter
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

  function M:set_frame(frame_group, object_sheet)
    local frame = display.newRoundedRect(frame_group, 0, 0, 32, 32, 12)
    frame:setFillColor(1, 0, 1, 0.3)
  end

  function M:adjust_frame(frame_group, width, height)
    frame_group[1].x = 0
    -- frame_group[1].y = -(size + y_spacing) / 2
    frame_group[1].y = 0  
    frame_group[1].width = width + 16
    frame_group[1].height = height + 16
    frame_group[1].strokeWidth = 3
    frame_group[1]:setFillColor( 0.1, 0, 0, 0.3 )
    frame_group[1]:setStrokeColor( 1, 0, 0 )
  end

  return M  
end