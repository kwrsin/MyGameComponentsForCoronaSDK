local M = {}


function M:create_actor_from_tileset(parent, behavor_path, tileset, init_data)
  local actor = require(behavor_path) -- call _player
  

  

  return actor
end

return M