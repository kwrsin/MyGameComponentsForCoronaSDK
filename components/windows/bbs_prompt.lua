
return function(parent,object_sheet)
  local M = {}

  function M:create_prompt(parent, object_sheet)
    M.prompt = display.newImage(object_sheet, 1)
    parent:insert(M.prompt)
    M.prompt.isVisible = false
    M.is_visibled = false
  end

  function M:set_position(width, height)
    M.prompt.x = display.contentCenterX
    M.prompt.y = display.contentCenterY
  end

  function M:show_prompt()
    M.is_visibled = true
    M.prompt.isVisible = true
    M.prompt.alpha = 1.0
    M.blink = transition.blink(M.prompt, {time=1000})
  end

  function M:hide_prompt()
    M.is_visibled = false
    M.prompt.isVisible = false
    transition.cancel(M.blink)
  end

  function M:clean_up()
    transition.cancel(M.blink)
  end

  function M:is_shown()
    return M.is_visibled
  end

  M:create_prompt(parent, object_sheet)
  return M
end