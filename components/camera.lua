return function(parent, width, height, child, target, world_width, world_height)
  local M = {}
  local root = display.newGroup()
  root:insert(child)
  root.x = -width / 2
  root.y = -height / 2

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
    -- M.child.x = math.max(math.min(M.child.x, world_width - width), width / 2)
    -- M.child.y = math.max(math.min(M.child.y, world_height - height), height / 2)
    M.child.x = math.min(math.max(M.child.x, 0), world_width - width)
    M.child.y = math.min(math.max(M.child.y, 0), world_height - height)
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

  local container = display.newContainer(width, height)
  -- container.anchorChildren = false
  container.anchorX = 0
  container.anchorY = 0
  container.width = world_width
  container.height = world_height
  -- root:insert(container)
  M.container = container
  M.child = child
  M.container:insert(root)
  -- M.container:translate(display.contentCenterX, display.contentCenterY)
  parent:insert(container)
  M:set_focus(target)


  return M
end