local M = {
  CONTINUE = -1,
  BREAK = 0,
  NEXT = 1,
}

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
        if tile.properties.behavior then
          actor_instance = actor:create_actor_from_object_sheets(
            layer_object, tile.properties.behavior, get_object_sheets_from_tilesets(loader.tilemap.tilesets), init_data)
          actor_instance:start_timer()
          sprite_object = actor_instance.sprite
        else

        end
        if player and tile.properties.behavior == player.player_behavior then

          player.actor = actor_instance
        end
        table.insert(actor_list, actor_instance)
        return sprite_object
      end
    }
  }, physics)
  return actor_list
end

function M:create_bbs(sceneGroup, map_path)
  local bbs = require('components.windows.bbs')()
  local object_sheets = M:get_object_sheets(map_path)

  bbs:create_bbs(sceneGroup, 0, -180, 6, 20, native.systemFont, 12, object_sheets[3], nil, M.bbs_audio_path)
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

function M:create_camera(sceneGroup, view_group, width, height, view_width, view_height)
  local camera_group = display.newGroup()
  camera = require("components.camera")(camera_group, width, height, view_group, nil, view_width, view_height)
  sceneGroup:insert(camera_group)
  camera_group.x = display.contentCenterX - width / 2
  return camera
end

function M:clear_audio()
  global_audio:destory_sound_assets()
end

return M