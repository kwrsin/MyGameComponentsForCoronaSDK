return function(player, actor_list, listener)
  local M = {}
  function M:stop_actors_runner()
    Runtime:removeEventListener("enterFrame", actors_runner)
    self.observers = nil
  end

  function M:set_observers(listener)
    self.observers = listener
  end


  local actors_runner = function(event)
    if M.observers then
      M.observers()
    end

    for i = 1, #actor_list do
      actor_list[i].enterFrame(event)
    end
  end

  Runtime:addEventListener("enterFrame", actors_runner)
  M:set_observers(listener)

  return M
end