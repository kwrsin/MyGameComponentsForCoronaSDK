return function(scenario_list)
  local M = {}

  M.CONTINUE = -1
  M.CANCEL_ALL = 0
  M.NEXT = 1

  function M:enterFrame()
    if M.scenario == nil then
      if M:has_children() then
        M.scenario = M:get_child()
        M.scenario.running = false
        M.scenario:start()
      -- else
      --   M:clean_up()
      --   return
      end
    end
    if M.scenario and M.scenario.running == true then
      local eval= M.scenario.evaluate()
      if eval >= M.CANCEL_ALL then
        if eval == M.CANCEL_ALL then
          M:delete_children()
        end
        M:update_scenario_list(eval)
        M.scenario.finalize(eval)
        M.scenario = nil
        eval = M.CONTINUE
      end
    end
  end

  function M:update_scenario_list(eval)
    if M.scenario.scenario_list and #M.scenario.scenario_list > 0 then
      M.scenario_list = M.scenario.scenario_list
    end
  end

  function M:has_children()
    return #M.scenario_list > 0
  end

  function M:get_child()
    return table.remove(M.scenario_list, 1)
  end

  function M:delete_children()
    if M:has_children() then
      for i = 1, #M.scenario_list do
        table.remove(M.scenario_list, i)
      end
    end
  end

  function M:set_scenario_list(scenario_list)
    M.scenario_list = scenario_list
  end

  function M:clean_up()
    print("close scenario_player")
    Runtime:removeEventListener("enterFrame", M)
    M:delete_children()
    M.scenario = nil
  end

  M.scenario_list = scenario_list
  Runtime:addEventListener("enterFrame", M)
  return M
end