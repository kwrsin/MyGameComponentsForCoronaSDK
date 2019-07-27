local composer = require('composer')

local scene = composer.newScene()

local player
local actor_list = {}
local tilemap_panel
local banner
local actors_runner
local map_path = 'assets.fghi'
local physics = require("physics")
local helper = require("user_define.scenes.scene1_helper")
local scenario_runner
local camera

local back_to_title

function scene:create(event)
  local sceneGroup = self.view
  -- physics.setDrawMode("hybrid")
  physics.start()
  physics.pause()

  player = composer.getVariable("player")
  helper:create_stage(sceneGroup)
  tilemap_panel = display.newGroup()
  camera = helper:create_camera(sceneGroup, tilemap_panel, 300, 300, 5760, 576)

  -- banner
  local banner_panel = display.newGroup()
  sceneGroup:insert(banner_panel)
  banner = display.newText(banner_panel, "READY", -display.contentCenterX, display.contentCenterY, "Arial", 32 )
  banner.isVisible = false

  print("scene1 created")
end

function scene:show(event)
  local sceneGroup = self.view

  if(event.phase == 'will') then
    print("scene1 show will")
    physics.pause()
    
    -- player controller
    camera.x_origin = 0
    camera.y_origin = 0
    player.controller:set_listeners(
      helper:get_controller_listeners(player, camera))

    actor_list = helper:create_tilemap(tilemap_panel, player, map_path, physics)
    camera:set_following(player.actor.sprite)
    -- camera:set_following({x=0, y=0, width=32, height=32})
    camera:start_following()

    actors_runner = helper:create_actors_runner(player, actor_list)

    scenario_runner = helper:start_game(player, banner, physics)

  elseif(event.phase == 'did') then

    print("scene1 show did")
  end
end

function scene:hide(event)
  local sceneGroup = self.view

  if(event.phase == 'will') then
    camera:stop_following()
    global_command_queue:clean_up()
    actors_runner:stop_actors_runner()
    for i = 1 , #actor_list do
      if actor_list[i].timerId then
        timer.cancel(actor_list[i].timerId)
        actor_list[i] = nil
      end
    end
    if tilemap_panel then
      for i = tilemap_panel.numChildren , 1, -1 do
        display.remove(tilemap_panel[i])
        tilemap_panel[i] = nil
      end
    end
    scenario_runner:clean_up()
    scenario_runner = nil

    print("scene1 hide will")
  elseif(event.phase == 'did') then
    print("scene1 hide did")
  end
end

function scene:destroy(event)
  local sceneGroup = self.view
  print("scene1 destroyed")
end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene