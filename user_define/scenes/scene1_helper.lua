
local M = require("user_define.scenes.scene_helper")

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

  local function get_object_sheets(tilesets)
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
            layer_object, tile.properties.behavor, get_object_sheets(loader.tilemap.tilesets), init_data)
          actor_instance:start_timer()
          sprite_object = actor_instance.sprite
        else

        end
        if tile.properties.behavor == player.player_behavior then

          player.actor = actor_instance
        end
        table.insert(actor_list, actor_instance)
        return sprite_object
      end
    }
  }, physics)
  return actor_list
end

function M:create_stage(sceneGroup)
  -- background
  local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
  bg:setFillColor(0, 0, 0)
end


return M