local M = {}


function M:create_actor_from_tileset(parent, behavor_path, tilesets, init_data)
  local function get_option_sheets(tilesets)
    local object_sheets = {}
    for i, t in ipairs(tilesets) do
      table.insert(object_sheets, t.object_sheet)
    end
    return object_sheets
  end
  local actor = require(behavor_path)
  actor:create_sprite(
                    parent, init_data.x, init_data.y, get_option_sheets(tilesets))

  -- local weapons_path = nil

  -- local wepons = require(weapons_path)
  

  return actor
end

return M