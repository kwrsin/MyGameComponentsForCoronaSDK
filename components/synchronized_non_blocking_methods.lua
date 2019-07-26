return function()
  local M = {
    command_queue = {},
    current_command = nil,
    timer_id_list = {},
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

  function M:clean_up()
    self:clear_current_command()
    for i = 1 , #self.command_queue do
      -- table.remove(self.command_queue, i)
      self.command_queue[i] = nil
    end
    while #M.timer_id_list > 0 do
      local timer_id = table.remove(M.timer_id_list, 1)
      if timer_id then
        timer.cancel(timer_id)
        timer_id = nil
      end
    end
    transition.cancel("sync")
  end

  function M:to(game_object, listener)
    listener.onComplete = function() M:clear_current_command() end
    listener.tag = "sync"
    transition.to(game_object, listener)
  end

  function M:performWithDelay(time, listener)
    local timer_id = timer.performWithDelay(time, function()
      listener()
      M:clear_current_command()
    end)
    table.insert(M.timer_id_list, timer_id)
  end

  return M
end
