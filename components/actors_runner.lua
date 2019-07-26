return function(player, actor_list)
  local M = {}

  local actors_runner = function(event)
    player.controller:observe("cursor", function()
      player.actor:move(player.controller:get_cursor_positions())
    end)

    for i = 1, #actor_list do
      actor_list[i].enterFrame(event)
    end
  end
  Runtime:addEventListener("enterFrame", actors_runner)

  function M:stop_actors_runner()
    Runtime:removeEventListener("enterFrame", actors_runner)
  end

  return M
end