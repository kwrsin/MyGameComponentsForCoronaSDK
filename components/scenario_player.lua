return function(scenario_list)
  local M = {}

  M.CANCEL_ALL = 0
  M.CONTINUE = -1
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
      local eval = M.scenario.evaluate()
      if eval >= 0 then
        if eval == 0 then
          M:delete_children()
        end
        M.scenario.finalize(eval)

        M.scenario = nil
      end
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