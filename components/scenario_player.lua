local M = {}

function M:enterFrame()
  if M.scenario == nil then
    if #M.scenario_list > 0 then
      M.scenario = table.remove(M.scenario_list, 1)
      M.scenario.start()
    -- else
    --   M:clean_up()
    --   return
    end
  end
  if M.scenario then
    local eval = M.scenario.evaluate()
    if eval >= 0 then
      if eval == 0 then
        for i = 1, #M.scenario_list do
          table.remove(M.scenario_list, i)
        end
      end
      M.scenario.finalize()

      M.scenario = nil
    end
  end
end

function M:set_scenario_list(scenario_list)
  M.scenario_list = scenario_list
end

function M:clean_up()
  print("close scenario_player")
  Runtime:removeEventListener("enterFrame", M)
  if #M.scenario_list > 0 then
    for i = 1, #M.scenario_list do
      table.remove(M.scenario_list, i)
    end
  end
  M.scenario = nil
end

return function(scenario_list)
  M.scenario_list = scenario_list
  Runtime:addEventListener("enterFrame", M)
  return M
end