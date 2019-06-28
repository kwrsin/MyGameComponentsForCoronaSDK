-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here






-- load a tilemap file

local tilemap_panel = display.newGroup()
local physics = require("physics")
-- physics.setDrawMode("hybrid")
physics.start()
system.activate( "multitouch" )

local map_path = 'maps.abcde'

function touch_event(event)
  print("hello " .. event.target.identifier .. " " .. event.target.layer_name)
  return true
end

function collision_event(self, event)
  if event.phase == "began" then
    -- print("collided " .. event.target.identifier)
  end
end

local loader = require('components.tilemap_loader')
loader:load_tilemap(tilemap_panel, map_path, {
  tilelayer_1 = {
    onTouch = touch_event,
    onLocalCollision = collision_event
  },
  objectlayer_1 = {
    onTouch = touch_event,
    onLocalCollision = collision_event
  }
}, physics)


-- char definition
local actor = require('components.actors.actor')
local init_data = {
  x = display.contentCenterX,
  y = display.contentCenterY + 96
}
local player = actor:create_actor_from_tileset(
  display.newGroup(), "components.actors.player_behavor", loader.tilemap.tilesets, init_data)
player:start_timer()




-- controller panel

local ui = require('components.controller.source_ui')
local controller_panel = display.newGroup()
local function isRepeat(event)
  local keep = false
  if event.phase == "began" then
    keep = true
  elseif event.phase == "ended" or event.phase == "cancelled" then
    keep = false
  end
  return keep
end

local listeners = {
  touch = function(event)
    if event.phase == "ended" or event.phase == "cancelled" then
      print("Any Touch!!")
    end
  end,
  up = function(event)
    if isRepeat(event) then
      print(event.target.name .. " ON!!")
    else
      print(event.target.name .. " OFF!!")
    end
  end,
  down = function(event)
    if isRepeat(event) then
      print(event.target.name .. " ON!!")
    else
      print(event.target.name .. " OFF!!")
    end
  end,
  left = function(event)
    if isRepeat(event) then
      print(event.target.name .. " ON!!")
    else
      print(event.target.name .. " OFF!!")
    end
  end,
  right = function(event)
    if isRepeat(event) then
      print(event.target.name .. " ON!!")
    else
      print(event.target.name .. " OFF!!")
    end
  end,
  north = function(event)
    if isRepeat(event) then
      print(event.target.name .. " ON!!")
    else
      print(event.target.name .. " OFF!!")
    end
  end,
  south = function(event)
    if isRepeat(event) then
      print(event.target.name .. " ON!!")
    else
      print(event.target.name .. " OFF!!")
    end
  end,
  east = function(event)
    if event.phase == "ended" or event.phase == "cancelled" then
      print("EAST!!")
    end
  end,
  west = function(event)
    if isRepeat(event) then
      print(event.target.name .. " ON!!")
    else
      print(event.target.name .. " OFF!!")
    end
  end,
}

local vc = ui:get_virtual_controller(controller_panel, listeners)
Runtime:addEventListener("touch", vc)