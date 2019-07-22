return function(parent, width, height, child, target, world_width, world_height)
  local M = {}
  local root = display.newGroup()
  root:insert(child)

  function M:set_focus(target)
    M.target = target
  end

  local function clamp()
    local target_width = 0
    local target_height = 0
    if M.target then
      target_width = M.target.width / 2
      target_height = M.target.height / 2
    end
    -- M.child.x = math.max(math.min(M.child.x, world_width - width / 2), width / 2)
    M.child.y = math.max(math.min(M.child.y, world_height - height / 2), height / 2)
  end

  local function enterFrame()
    if M.target then
      M.child.x = - (M.target.x - width / 4)
      M.child.y = - (M.target.y - height / 4)

      clamp()
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