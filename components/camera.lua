return function(parent, width, height, child, target)
  local M = {}
  local root = display.newGroup()
  root:insert(child)
  function M:set_position(x, y)
    child.x = child.x + x
    child.y = child.y + y
  end
  function M:get_position()
    return child.x, child.y
  end
  local container = display.newContainer(parent, width, height)
  M.container = container
  M.child = child
  M.container:insert(root)


  return M
end