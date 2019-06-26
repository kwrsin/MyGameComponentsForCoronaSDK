local M = {
  command_queue = {},
  current_command = nil
}

function M:clear_current_command()
  if self.current_command then
    self.current_command = nil
  end
end

function M:regist_command(cb)
  table.insert(self.command_queue, cb)
end

function M:command_processor()
  local function execute()
    if self.current_command then
      self.current_command()
    end
  end

  if self.current_command == nil and #self.command_queue > 0 then
    self.current_command = table.remove(self.command_queue, 1)
    execute()
  end
end

function M:enterFrame()
  self:command_processor()
end

return M