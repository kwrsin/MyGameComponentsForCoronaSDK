return function(scenario_list)
  local M = {}

  M.CONTINUE = -1
  M.CANCEL_ALL = 0
  M.NEXT = 1

  local eval = M.CONTINUE
  function M:enterFrame()
    if M.scenario == nil then
      if M:has_children() then
        M.scenario = M:get_child(eval)
        eval = M.CONTINUE
        M.scenario.running = false
        M.scenario:quest(function()
          M.scenario.running = true
        end)
      -- else
      --   M:clean_up()
      --   return
      end
    end
    if M.scenario and M.scenario.running == true then
      eval = M.scenario.evaluate()
      if eval >= M.CANCEL_ALL then
        M.scenario.running = false
        if eval == M.CANCEL_ALL then
          M:delete_children()
        elseif M.scenario.scenario_list and #M.scenario.scenario_list > 0 then
          M.scenario_list = M.scenario.scenario_list
        end
        M.scenario:answer(eval, function()
          M.scenario = nil
        end)
      end
    end
  end

  function M:has_children(eval)
    return #M.scenario_list > 0
  end

  function M:get_child(eval)
    if eval >= M.NEXT then
      local scenario = table.remove(M.scenario_list, eval)
      return scenario
    else
      return table.remove(M.scenario_list, 1)
    end
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
    print("close scenario_runner")
    Runtime:removeEventListener("enterFrame", M)
    M:delete_children()
    M.scenario = nil
  end

  M.scenario_list = scenario_list
  Runtime:addEventListener("enterFrame", M)
  return M
end