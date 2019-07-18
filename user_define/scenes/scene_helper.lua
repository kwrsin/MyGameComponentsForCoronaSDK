local M = {}

function M:get_object_sheets(map_path)
  local loader = require('components.tilemap_loader')
  return loader:get_object_sheets(map_path)
end

function M:create_tilemap(tilemap_panel, player, map_path, physics)
  local actor_list = {}

  local function touch_event(event)
    print("hello " .. event.target.identifier .. " " .. event.target.layer_name)
    return true
  end

  local function collision_event(self, event)
    if event.phase == "began" then
      -- print("collided " .. event.target.identifier)
    end
  end

  local function get_object_sheets_from_tilesets(tilesets)
    local object_sheets = {}
    for i, t in ipairs(tilesets) do
      table.insert(object_sheets, t.object_sheet)
    end
    return object_sheets
  end

  local loader = require('components.tilemap_loader')
  loader:load_tilemap(tilemap_panel, map_path, {
    tilelayer_1 = {
      onTouch = touch_event,
      onLocalCollision = collision_event
    },
    objectlayer_1 = {
      onTouch = touch_event,
      onLocalCollision = collision_event,
      onCreateGameObject = function(layer_object, local_id, width, height, tile, object_sheet, l, onTouch)
        -- char definition
        local actor = require('components.actor')
        local init_data = {
          x = 0,
          y = 0
        }
        local actor_instance
        local sprite_object = nil
        if tile.properties.behavor then
          actor_instance = actor:create_actor_from_object_sheets(
            layer_object, tile.properties.behavor, get_object_sheets_from_tilesets(loader.tilemap.tilesets), init_data)
          actor_instance:start_timer()
          sprite_object = actor_instance.sprite
        else

        end
        if player and tile.properties.behavor == player.player_behavior then

          player.actor = actor_instance
        end
        table.insert(actor_list, actor_instance)
        return sprite_object
      end
    }
  }, physics)
  return actor_list
end

function M:create_bbs(sceneGroup)
  local bbs = require('components.windows.bbs')()
  local bbs_group = display.newGroup()
  sceneGroup:insert(bbs_group)
  local local_queue = require("components.synchronized_non_blocking_methods")()
  bbs:create_bbs(bbs_group, 0, 0, 6, 20, native.systemFont, 12, "frame_path", local_queue)
  Runtime:addEventListener("enterFrame", local_queue)
  return bbs
end

function M:create_modal(sceneGroup, map_path)
  local modal = require("components.windows.modal")
  local object_sheets = M:get_object_sheets(map_path)
  modal:create_modal(sceneGroup, object_sheets[3], nil)
  return modal
end

function M:create_banner(sceneGroup, map_path)
  local banner = require("components.windows.banner")
  local object_sheets = M:get_object_sheets(map_path)
  banner:create_banner(sceneGroup, object_sheets[3], nil)
  return banner
end

return M