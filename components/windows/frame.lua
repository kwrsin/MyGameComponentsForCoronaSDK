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
    if object_sheet then
      if frame_group.numChildren > 0 then
        for i = 1, frame_group.numChildren do
          frame_group[i]:removeSelf()
          frame_group[i] = nil
        end
      end
      for i = 1, 9 do
        local frame_image = display.newImage(frame_group, object_sheet, i)
      end
    end
  end

  function M:adjust_frame(frame_group, width, height)
    frame_group[1].x = -width / 2 - frame_group[1].width / 2
    frame_group[1].y = -height / 2 - frame_group[1].width / 2 - frame_group[1].width
    frame_group[2].x = 0
    frame_group[2].y = -height / 2 - frame_group[1].width / 2 - frame_group[1].width
    frame_group[2].width = width
    frame_group[3].x = width / 2 + frame_group[1].width / 2
    frame_group[3].y = -height / 2 - frame_group[1].width / 2 - frame_group[1].width
    frame_group[4].x = -width / 2 - frame_group[1].width / 2
    frame_group[4].y = 0 - frame_group[1].width
    frame_group[4].height = height + frame_group[1].width / 2
    -- frame_group[5].x = 0
    -- frame_group[5].y = 0
    frame_group[5].isVisible = false
    frame_group[6].x = width / 2 + frame_group[1].width / 2
    frame_group[6].y = 0 - frame_group[1].width
    frame_group[6].height = height + frame_group[1].width / 2
    frame_group[7].x = -width / 2 - frame_group[1].width / 2
    frame_group[7].y = height / 2 + frame_group[1].width / 2 - frame_group[1].width
    frame_group[8].x = 0
    frame_group[8].y = height / 2 + frame_group[1].width / 2 - frame_group[1].width
    frame_group[8].width = width
    frame_group[9].x = width / 2 + frame_group[1].width / 2
    frame_group[9].y = height / 2 + frame_group[1].width / 2 - frame_group[1].width

  end

  return M  
end