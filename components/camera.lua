return function(parent, width, height, child, target)
  local M = {}
  local root = display.newGroup()
  root:insert(child)

  function M:set_target(target)
    M.target = target
  end

  function M:start_focus()
    -- self.enterFrame = Runtime:addEventListener("enterFrame", function()
    --   if M.target then
    --     M.child.x = M.target.x

    --     M.child.y = M.target.y
    --   end
    -- end)
  end

  function M:stop_focus()
    -- if self.enterFrame then
    --   Runtime:removeEventListener("enterFrame", self.enterFrame)
    -- end
  end

  local container = display.newContainer(parent, width, height, target)
  M.container = container
  M.child = child
  M.container:insert(root)
  M:set_target(target)


  return M
end