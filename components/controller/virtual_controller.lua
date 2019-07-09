local M = {}

function M:execute(event, callback)
  if callback then
    callback(event)
  end
end

function M:button_000(event, callback)
  self:execute(event, callback)
end

function M:button_001(event, callback)
  self:execute(event, callback)
end

function M:button_002(event, callback)
  self:execute(event, callback)
end

function M:button_003(event, callback)
  self:execute(event, callback)
end

function M:button_004(event, callback)
  self:execute(event, callback)
end

function M:button_005(event, callback)
  self:execute(event, callback)
end

function M:button_006(event, callback)
  self:execute(event, callback)
end

function M:button_007(event, callback)
  self:execute(event, callback)
end

function M:button_008(event, callback)
  self:execute(event, callback)
end

function M:button_009(event, callback)
  self:execute(event, callback)
end

M.virtual_touch = M.button_000
M.virtual_up = M.button_001
M.virtual_down = M.button_002
M.virtual_left = M.button_003
M.virtual_right = M.button_004
M.virtual_north = M.button_005
M.virtual_south = M.button_006
M.virtual_east = M.button_007
M.virtual_west = M.button_008
M.virtual_cursor = M.button_009

return M