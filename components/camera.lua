return function(parent, width, height, child, target)
  local M = {}
  local root = display.newGroup()
  root:insert(child)

  function M:set_focus(target)
    M.target = target
  end

  local function enterFrame()
    if M.target then
      M.child.x = - (M.target.x - width / 4)
      M.child.y = - (M.target.y - height / 4)

    end

  end

  function M:start_focus()
    self.enterFrame = Runtime:addEventListener("enterFrame", enterFrame)
  end

  function M:stop_focus()
    Runtime:removeEventListener("enterFrame", enterFrame)
  end

  local container = display.newContainer(parent, width, height, target)
  M.container = container
  M.child = child
  M.container:insert(root)
  M:set_focus(target)


  return M
end