local M = {}


function M:create_actor_from_object_sheets(parent, behavior_path, object_sheets, init_data)
  local actor = require(behavior_path)
  actor:create_sprite(
                    parent, init_data.x, init_data.y, object_sheets)

  -- local weapons_path = nil

  -- local wepons = require(weapons_path)
  

  return actor
end

return M