return function(parent, width, height, child, target, world_width, world_height)
  local M = {}
  M.is_playing = false
  local root = display.newGroup()
  root:insert(child)
  root.x = -width / 2
  root.y = -height / 2

  function M:set_following(target)
    M.target = target
  end

  function M:move(onAction)
    M.is_playing = true
    onAction(M.child, function() M.is_playing = false end)
  end

  function M:get_following_positions()
    return -(M.target.x - width / 2), -(M.target.y - height / 2)
  end

  local function clamp()
    local target_width = 0
    local target_height = 0
    if M.target then
      target_width = M.target.width / 2
      target_height = M.target.height / 2
    end
    M.target.x = math.min(math.max(M.target.x, width / 2), world_width - width / 2)
    M.target.y = math.min(math.max(M.target.y, height / 2), world_height - height / 2)
  end

  local function enterFrame()
    if M.target and not M.is_playing then
      clamp()
      M.child.x = - (M.target.x - width / 2)
      M.child.y = - (M.target.y - height / 2)

    end

  end

  function M:start_following()
    self.enterFrame = Runtime:addEventListener("enterFrame", enterFrame)
  end

  function M:stop_following()
    Runtime:removeEventListener("enterFrame", enterFrame)
  end

  local container = display.newContainer(width, height)
  -- container.anchorChildren = false
  container.anchorX = 0
  container.anchorY = 0
  -- container.width = world_width
  -- container.height = world_height
  -- root:insert(container)
  M.container = container
  M.child = child
  M.container:insert(root)
  -- M.container:translate(display.contentCenterX, display.contentCenterY)
  parent:insert(container)
  M:set_following(target)


  return M
end