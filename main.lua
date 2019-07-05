-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
t = require("components.i18n.locale")("assets.translations")
global_queue = require("components.synchronized_non_blocking_methods")()
-- Your code here

local player_behavor = "components.actors.player_behavor"
local player
local actor_list = {}


local func = nil

-- load a tilemap file

local tilemap_panel = display.newGroup()
local physics = require("physics")
-- physics.setDrawMode("hybrid")
physics.start()
physics.pause()

system.activate( "multitouch" )

local map_path = 'assets.abcde'

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
      local actor = require('components.actors.actor')
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

      if tile.properties.behavor == player_behavor then
        player = actor_instance
      end
      table.insert(actor_list, actor_instance)
      return sprite_object
    end
  }
}, physics)





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
      if func then
        func()
      end
    end
  end,
  up = function(event)
    if isRepeat(event) then
      print(event.target.name .. " ON!!")
      player:up()
      player:move_up(true)
    else
      player:down()
      player:move_up(false)
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

Runtime:addEventListener("enterFrame", function(event)
  for i = 1, #actor_list do
    actor_list[i].enterFrame(event)
  end
  
  global_queue:enterFrame()
end)


-- scenario



local scenario_panel = display.newGroup()
local banner = display.newText(scenario_panel, "READY", -display.contentCenterX, display.contentCenterY, "Arial", 32 )
banner.isVisible = false
local touch_guard = display.newRect(scenario_panel, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
touch_guard.isVisible = false
touch_guard.isHitTestable = true
touch_guard:addEventListener("touch", function(event)
  print("can not touch!!")
  return true
end)
touch_guard:setFillColor(0, 1, 0)
touch_guard.alpha = .3
local function clear_current_command()
  global_queue:clear_current_command()
end


local function execute_opening()
  global_queue:regist_command(function()
    banner.isVisible = true
    transition.to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    transition.to(banner, {time=200, x=display.contentCenterX, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    transition.to(banner, {time=100, x= display.contentWidth + display.contentCenterX, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    banner.x = -display.contentCenterX
    banner.text = "GO"
    transition.to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    transition.to(banner, {time=200, x=display.contentCenterX, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    transition.to(banner, {time=100, x= display.contentWidth + display.contentCenterX, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    banner.x = -display.contentCenterX
    banner.text = "FIGHT"
    transition.to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    transition.to(banner, {time=200, x=display.contentCenterX, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    transition.to(banner, {time=100, x= display.contentWidth + display.contentCenterX, onComplete=clear_current_command})
  end)
  global_queue:regist_command(function()
    timer.performWithDelay(100, function()
      banner.isVisible = false
      touch_guard.isHitTestable = false
      physics.start()
      clear_current_command()
    end)
  end)
end

local function execute_ending()
end


local bbs = require('components.windows.bbs')
local bbs_group = display.newGroup()
local local_queue = require("components.synchronized_non_blocking_methods")()
bbs.create_bbs(bbs_group, 0, 0, 10, 20, native.systemFont, 12, "frame_path", local_queue)
Runtime:addEventListener("enterFrame", local_queue)


func = function()
  bbs:set_speed(10)
end
-- start game

execute_opening()
-- bbs:clearBBS()
bbs:say(nil, t("HELLO").value .. "\nあういぇおあういぇおあういぇおあういぇおあういぇおあういぇおあういぇおあういぇおあういぇおあういぇお\nはげ\n", 50, nil, {{begin=3, stop=4, color_table={0.7, 1, 0}}})
bbs:clear_bbs()
bbs:say(nil, "リゾット\nねいろ\n暗殺者\n", 100, nil, nil)
bbs:say(nil, "オー　ドッピオ！！　私の可愛いドッピオよっ！\n", 180, nil, nil)
bbs:say(nil, "なんだと？　ドッピオ！！　さすがに足をやられるダメージはまずいっ！\nドッピオでは\nもう倒せない\n", 80, nil)
bbs:say(nil, "リゾット　俺はドッピオに言ったんだ！\nもうお前では\n勝てないって・・・\n", 80, nil, {{begin=10, stop=14, color_table={0.5, 0, 0}}})
bbs:clear_bbs()
bbs:say(nil, "最近・・！\nうちのハムスターが\nメタボってきた(T T)\n", 80, nil, {{begin=9, stop=13, color_table={1, 0, 1}}})
bbs:say(nil, "transition.*\nThe transition library provides functions and methods to transition tween display objects or display groups over a specific period of time. Library features include\nAbility to pause, resume, or cancel a transition (or all transitions)\n", 80, nil, {{begin=32, stop=38, color_table={1, 1, 0}}})

